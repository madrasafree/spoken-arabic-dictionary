#!/usr/bin/env python3
"""
ASP Classic Analyzer — Pre-migration analysis tool for Classic ASP -> Django.
Scans .asp files and produces a structured migration report.

Usage:
    python analyze_asp.py [path] [--output report.md] [--csv] [--file single.asp]

Arguments:
    path        Root directory to scan (default: current dir)
    --output    Output file path (default: asp-analysis.md)
    --csv       Also export CSV summary
    --file      Analyze a single file only
    --verbose   Include full SQL query text
"""

import os
import re
import sys
import csv
import argparse
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Optional

# --- Patterns ---

INCLUDE_RE        = re.compile(r'<!--\s*#include\s+file="([^"]+)"\s*-->', re.IGNORECASE)
SQL_RE            = re.compile(r'mySQL\s*=\s*["\']?\s*(SELECT|INSERT|UPDATE|DELETE|EXEC)', re.IGNORECASE)
AUTH_CHECK_RE     = re.compile(r'session\s*\(\s*"role"\s*\)\s*[<>=!]+\s*(\d+)', re.IGNORECASE)
SESSION_VAR_RE    = re.compile(r'session\s*\(\s*"([^"]+)"\s*\)', re.IGNORECASE)
REQUEST_RE        = re.compile(r'Request(?:\.Form|\.QueryString)?\s*\(\s*"([^"]+)"\s*\)', re.IGNORECASE)
OPENDB_RE         = re.compile(r'open(?:DB|DbLogger)\s+"?([a-zA-Z0-9_]+)"?', re.IGNORECASE)
REDIRECT_RE       = re.compile(r'Response\.Redirect\s+"?([^"\n<]+)"?', re.IGNORECASE)
RESPONSE_WRITE_RE = re.compile(r'response\.write|<%=', re.IGNORECASE)
DIM_RE            = re.compile(r'\bDim\b(.+)', re.IGNORECASE)
INJECTION_RE      = re.compile(r'mySQL\s*[&+]?=.*Request\s*\(', re.IGNORECASE)

AUTH_NAMES = {0: "public", 1: "user", 2: "user+", 3: "team", 15: "admin"}


@dataclass
class AspFile:
    path: str
    lines: int = 0
    includes: List[str] = field(default_factory=list)
    databases: List[str] = field(default_factory=list)
    sql_operations: List[str] = field(default_factory=list)
    auth_level: Optional[int] = None
    session_vars: List[str] = field(default_factory=list)
    request_params: List[str] = field(default_factory=list)
    redirects: List[str] = field(default_factory=list)
    response_writes: int = 0
    has_injection_risk: bool = False
    injection_lines: List[int] = field(default_factory=list)
    errors: List[str] = field(default_factory=list)

    @property
    def complexity(self) -> str:
        score = 0
        score += min(self.lines // 50, 4)
        score += min(len(self.sql_operations), 5)
        score += len(set(self.databases))
        score += len(self.includes)
        score += 3 if self.has_injection_risk else 0
        score += 1 if len(self.request_params) > 3 else 0
        if score <= 3:
            return "LOW"
        elif score <= 7:
            return "MEDIUM"
        else:
            return "HIGH"

    @property
    def auth_label(self) -> str:
        if self.auth_level is None:
            return "public (0)"
        return AUTH_NAMES.get(self.auth_level, f"level {self.auth_level}") + f" ({self.auth_level})"

    @property
    def django_view_type(self) -> str:
        ops = set(self.sql_operations)
        if not self.sql_operations:
            return "TemplateView"
        if "INSERT" in ops and len(self.sql_operations) <= 3:
            return "CreateView"
        if "UPDATE" in ops and len(self.sql_operations) <= 3:
            return "UpdateView"
        if "DELETE" in ops:
            return "DeleteView"
        if len(self.sql_operations) == 1:
            return "DetailView / ListView"
        return "View (multiple queries)"


def analyze_file(filepath: str) -> AspFile:
    result = AspFile(path=filepath)
    try:
        with open(filepath, "r", encoding="utf-8", errors="replace") as f:
            content = f.read()
            lines_list = content.splitlines()

        result.lines = len(lines_list)
        result.includes = INCLUDE_RE.findall(content)
        result.databases = list(set(OPENDB_RE.findall(content)))
        result.sql_operations = [m.group(1).upper() for m in SQL_RE.finditer(content)]

        auth_matches = AUTH_CHECK_RE.findall(content)
        if auth_matches:
            result.auth_level = max(int(x) for x in auth_matches)

        result.session_vars = list(
            set(SESSION_VAR_RE.findall(content)) - {"role", "msg", "userID"}
        )
        result.request_params = list(set(REQUEST_RE.findall(content)))
        result.redirects = list(set(REDIRECT_RE.findall(content)))
        result.response_writes = len(RESPONSE_WRITE_RE.findall(content))

        for i, line in enumerate(lines_list, 1):
            if INJECTION_RE.search(line):
                result.has_injection_risk = True
                result.injection_lines.append(i)

    except Exception as e:
        result.errors.append(str(e))

    return result


def scan_directory(root: str) -> List[AspFile]:
    results = []
    for dirpath, _, filenames in os.walk(root):
        for fname in filenames:
            if fname.lower().endswith(".asp"):
                full = os.path.join(dirpath, fname)
                rel = os.path.relpath(full, root).replace("\\", "/")
                af = analyze_file(full)
                af.path = rel
                results.append(af)
    results.sort(key=lambda x: (x.complexity == "LOW", x.complexity == "MEDIUM", x.path))
    return results


def render_markdown(files: List[AspFile], root: str) -> str:
    out = []
    out.append("# ASP Classic -> Django Migration Analysis\n")
    out.append(f"**Root:** `{root}`  |  **Files scanned:** {len(files)}\n")

    high  = [f for f in files if f.complexity == "HIGH"]
    med   = [f for f in files if f.complexity == "MEDIUM"]
    low   = [f for f in files if f.complexity == "LOW"]
    risky = [f for f in files if f.has_injection_risk]
    dbs   = sorted(set(db for f in files for db in f.databases))

    out.append("## Summary\n")
    out.append("| | Count |")
    out.append("|---|---|")
    out.append(f"| HIGH complexity | {len(high)} |")
    out.append(f"| MEDIUM complexity | {len(med)} |")
    out.append(f"| LOW complexity | {len(low)} |")
    out.append(f"| SQL injection risk | {len(risky)} |")
    out.append(f"| Databases touched | {', '.join(dbs) or 'none'} |")
    out.append("")

    out.append("## File Overview\n")
    out.append("| File | Lines | Complexity | Auth | DBs | SQL ops | Injection |")
    out.append("|---|---|---|---|---|---|---|")
    for f in files:
        inj  = "YES" if f.has_injection_risk else "—"
        ops  = ", ".join(sorted(set(f.sql_operations))) or "—"
        dbs_ = ", ".join(sorted(set(f.databases))) or "—"
        out.append(f"| `{f.path}` | {f.lines} | {f.complexity} | {f.auth_label} | {dbs_} | {ops} | {inj} |")
    out.append("")

    out.append("## File Details (HIGH & MEDIUM)\n")
    for f in files:
        if f.complexity == "LOW":
            continue
        out.append(f"### `{f.path}`")
        out.append(f"- **Complexity:** {f.complexity}  |  **Lines:** {f.lines}")
        out.append(f"- **Auth required:** {f.auth_label}")
        out.append(f"- **Suggested Django view:** {f.django_view_type}")
        if f.databases:
            out.append(f"- **Databases:** {', '.join(sorted(set(f.databases)))}")
        if f.includes:
            out.append(f"- **Includes:** {', '.join(f.includes)}")
        if f.sql_operations:
            out.append(f"- **SQL ops ({len(f.sql_operations)}):** {', '.join(set(f.sql_operations))}")
        if f.request_params:
            out.append(f"- **Request params:** `{'`, `'.join(sorted(f.request_params))}`")
        if f.session_vars:
            out.append(f"- **Session vars:** `{'`, `'.join(sorted(f.session_vars))}`")
        if f.redirects:
            out.append(f"- **Redirects to:** {', '.join(str(r).strip() for r in f.redirects[:4])}")
        if f.has_injection_risk:
            out.append(f"- **INJECTION RISK at lines:** {', '.join(str(l) for l in f.injection_lines)}")
        if f.errors:
            out.append(f"- **Parse errors:** {'; '.join(f.errors)}")
        out.append("")

    if low:
        out.append("## LOW Complexity Files\n")
        for f in low:
            out.append(f"- `{f.path}` ({f.lines} lines, auth: {f.auth_label})")
        out.append("")

    if risky:
        out.append("## SQL Injection Risks\n")
        for f in risky:
            out.append(f"- `{f.path}` — lines: {', '.join(str(l) for l in f.injection_lines)}")
        out.append("")

    out.append("---\n*Generated by asp-classic-analyzer*")
    return "\n".join(out)


def render_csv(files: List[AspFile]) -> str:
    import io
    buf = io.StringIO()
    w = csv.writer(buf)
    w.writerow(["file", "lines", "complexity", "auth_label", "databases",
                "sql_count", "sql_ops", "request_params", "includes",
                "injection_risk", "django_view"])
    for f in files:
        w.writerow([
            f.path, f.lines, f.complexity, f.auth_label,
            "|".join(sorted(set(f.databases))),
            len(f.sql_operations),
            "|".join(sorted(set(f.sql_operations))),
            "|".join(sorted(f.request_params)),
            "|".join(f.includes),
            "YES" if f.has_injection_risk else "no",
            f.django_view_type,
        ])
    return buf.getvalue()


def main():
    parser = argparse.ArgumentParser(description="ASP Classic -> Django analyzer")
    parser.add_argument("path", nargs="?", default=".", help="Root dir or file")
    parser.add_argument("--output", default="asp-analysis.md", help="Output .md file")
    parser.add_argument("--csv", action="store_true", help="Also write CSV")
    parser.add_argument("--file", help="Analyze a single file")
    args = parser.parse_args()

    root = os.path.abspath(args.path)

    if args.file:
        files = [analyze_file(args.file)]
        files[0].path = os.path.basename(args.file)
        root = os.path.dirname(os.path.abspath(args.file))
    else:
        print(f"Scanning {root} ...")
        files = scan_directory(root)
        print(f"Found {len(files)} .asp files")

    md = render_markdown(files, root)
    with open(args.output, "w", encoding="utf-8") as fh:
        fh.write(md)
    print(f"Report: {args.output}")

    if args.csv:
        csv_path = args.output.replace(".md", ".csv")
        with open(csv_path, "w", encoding="utf-8", newline="") as fh:
            fh.write(render_csv(files))
        print(f"CSV:    {csv_path}")

    high  = [f for f in files if f.complexity == "HIGH"]
    risky = [f for f in files if f.has_injection_risk]
    if high:
        print(f"\nHIGH complexity ({len(high)}):")
        for f in high:
            print(f"  {f.path}")
    if risky:
        print(f"\nINJECTION RISK ({len(risky)}):")
        for f in risky:
            print(f"  {f.path}  lines: {f.injection_lines}")


if __name__ == "__main__":
    main()
