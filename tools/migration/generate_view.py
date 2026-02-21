#!/usr/bin/env python3
"""
Generate a Django view + template skeleton from a Classic ASP file.

Usage:
    python generate_view.py path/to/file.asp [--out-dir output/]

Outputs:
    <name>_view.py   — Django view class skeleton
    <name>.html      — Django template skeleton
"""

import os
import re
import argparse
from pathlib import Path

INCLUDE_RE    = re.compile(r'<!--\s*#include\s+file="([^"]+)"\s*-->', re.IGNORECASE)
SQL_RE        = re.compile(r'mySQL\s*=\s*["\']?\s*(SELECT|INSERT|UPDATE|DELETE)', re.IGNORECASE)
AUTH_RE       = re.compile(r'session\s*\(\s*"role"\s*\)\s*[<>=!]+\s*(\d+)', re.IGNORECASE)
REQUEST_RE    = re.compile(r'Request(?:\.Form|\.QueryString)?\s*\(\s*"([^"]+)"\s*\)', re.IGNORECASE)
OPENDB_RE     = re.compile(r'open(?:DB|DbLogger)\s+"?([a-zA-Z0-9_]+)"?', re.IGNORECASE)
REDIRECT_RE   = re.compile(r'Response\.Redirect\s+"?([^"\n<]+)"?', re.IGNORECASE)
# Only capture simple variable names from <%=...%> — skip res("x"), function calls, etc.
INLINE_RE     = re.compile(r'<%=\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*%>', re.IGNORECASE)


def to_snake(name: str) -> str:
    """Convert camelCase or PascalCase to snake_case."""
    s = re.sub(r'([A-Z])', r'_\1', name).lower().lstrip('_')
    return s.replace('-', '_').replace('.', '_')


def classify_view(sql_ops, request_params, auth_level):
    ops = set(o.upper() for o in sql_ops)
    if not sql_ops:
        return "TemplateView"
    if "INSERT" in ops and len(sql_ops) <= 3 and request_params:
        return "CreateView"
    if "UPDATE" in ops and len(sql_ops) <= 3:
        return "UpdateView"
    if "DELETE" in ops:
        return "DeleteView"
    if len(sql_ops) == 1 and "SELECT" in ops:
        return "DetailView"
    # Multiple queries — use TemplateView so get() override is valid
    return "TemplateView"


def auth_mixin(level):
    if level is None or level == 0:
        return []
    if level <= 2:
        return ["LoginRequiredMixin"]
    if level < 15:
        return ["TeamRequiredMixin"]
    return ["AdminRequiredMixin"]


def generate_view(filepath: str, out_dir: str):
    with open(filepath, "r", encoding="utf-8", errors="replace") as f:
        content = f.read()

    name = Path(filepath).stem.replace(".", "_").replace(" ", "_")
    class_name = "".join(w.capitalize() for w in re.split(r'[._\s-]', name)) + "View"

    includes     = INCLUDE_RE.findall(content)
    sql_ops      = [m.group(1).upper() for m in SQL_RE.finditer(content)]
    databases    = list(set(OPENDB_RE.findall(content)))
    request_keys = list(set(REQUEST_RE.findall(content)))
    redirects    = list(set(REDIRECT_RE.findall(content)))
    auth_matches = AUTH_RE.findall(content)
    auth_level   = max(int(x) for x in auth_matches) if auth_matches else None

    view_type = classify_view(sql_ops, request_keys, auth_level)
    mixins    = auth_mixin(auth_level)

    # ─── VIEW FILE ───────────────────────────────────────────────
    lines = []
    lines.append(f"# Generated skeleton from: {os.path.basename(filepath)}")
    lines.append(f"# ASP auth level: {auth_level}  |  SQL ops: {sql_ops}  |  DBs: {databases}")
    lines.append("")
    lines.append("from django.views.generic import " + view_type)

    if mixins:
        mixin_imports = {
            "LoginRequiredMixin": "from django.contrib.auth.mixins import LoginRequiredMixin",
            "TeamRequiredMixin":  "from core.mixins import TeamRequiredMixin",
            "AdminRequiredMixin": "from core.mixins import AdminRequiredMixin",
        }
        for m in mixins:
            lines.append(mixin_imports[m])

    if "INSERT" in sql_ops or "UPDATE" in sql_ops:
        lines.append("from django.contrib import messages")
    lines.append("from django.urls import reverse_lazy")
    lines.append("")

    # Guess model from filename first, then fall back to database name
    filename_model_hints = {
        "label": "Label", "labels": "Label",
        "word": "Word", "words": "Word",
        "sentence": "Sentence", "sentences": "Sentence",
        "list": "List", "lists": "List",
        "user": "User", "users": "User",
        "profile": "User",
        "login": "User",
        "media": "Media",
        "task": "Task", "tasks": "Task",
        "stats": "WordSearched",
        "search": "WordSearched",
        "monitor": "Monitor",
        "history": "WordHistory",
    }
    db_model_map = {
        "arabicWords":   "Word",
        "arabicUsers":   "User",
        "arabicSearch":  "WordSearched",
        "arabicManager": "Task",
        "arabicLogs":    "Monitor",
    }
    # Check all underscore-split parts of the filename for a hint (exact or prefix match)
    name_parts = name.lower().split("_")
    model = None
    for part in name_parts:
        if part in filename_model_hints:
            model = filename_model_hints[part]
            break
        # prefix match: "listsnew" starts with "lists"
        for hint_key, hint_val in filename_model_hints.items():
            if part.startswith(hint_key):
                model = hint_val
                break
        if model:
            break
    if not model:
        model = next((db_model_map[db] for db in databases if db in db_model_map), "TodoModel")
    lines.append(f"from .models import {model}")
    lines.append("")
    lines.append("")

    all_bases = mixins + [view_type]
    lines.append(f"class {class_name}({', '.join(all_bases)}):")
    lines.append(f'    model = {model}')
    lines.append(f'    template_name = "TODO/{name}.html"')

    if view_type in ("CreateView", "UpdateView"):
        lines.append(f'    # form_class = {model}Form  # TODO: create form')
        lines.append(f'    success_url = reverse_lazy("TODO")')
    elif view_type in ("DetailView", "ListView"):
        lines.append(f'    context_object_name = "{to_snake(model)}"')

    lines.append("")

    if request_keys:
        lines.append("    def get_context_data(self, **kwargs):")
        lines.append("        ctx = super().get_context_data(**kwargs)")
        for key in request_keys:
            lines.append(f'        {to_snake(key)} = self.request.GET.get("{key}", "")')
        lines.append("        # TODO: build queryset using params above")
        lines.append("        # ctx[\"objects\"] = Model.objects.filter(...)")
        lines.append("        return ctx")
        lines.append("")

    if "INSERT" in sql_ops or "UPDATE" in sql_ops:
        lines.append("    def post(self, request, *args, **kwargs):")
        lines.append("        # TODO: replace with CreateView/UpdateView + ModelForm")
        if "INSERT" in sql_ops:
            lines.append("        # form.instance.creator = request.user")
        lines.append('        # messages.success(request, "TODO: success message")')
        lines.append("        # return redirect('TODO')")
        lines.append("        raise NotImplementedError")
        lines.append("")

    # Filter junk redirects (blank, contains VBScript expressions)
    clean_redirects = [
        r.strip() for r in redirects
        if r.strip() and not re.search(r'[()&"]', r) and len(r.strip()) > 2
    ]
    if clean_redirects:
        lines.append("    # ASP redirected to:")
        for r in clean_redirects[:4]:
            lines.append(f"    #   {r}")
        lines.append("")

    view_path = os.path.join(out_dir, f"{name}_view.py")
    with open(view_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"View:     {view_path}")

    # ─── TEMPLATE FILE ───────────────────────────────────────────
    tmpl = []
    tmpl.append('{% extends "base.html" %}')
    tmpl.append(f'{{# Ported from: {os.path.basename(filepath)} #}}')
    tmpl.append("")
    tmpl.append('{% block head %}')
    tmpl.append("  {# TODO: page-specific CSS #}")
    tmpl.append('{% endblock %}')
    tmpl.append("")
    tmpl.append('{% block content %}')

    # Extract inline output placeholders from ASP
    for m in INLINE_RE.finditer(content):
        var = m.group(1).strip()
        tmpl.append(f"  {{{{ {var} }}}}  {{# TODO: map to model field #}}")

    if not INLINE_RE.search(content):
        tmpl.append("  {# TODO: template content #}")

    tmpl.append('{% endblock %}')

    tmpl_path = os.path.join(out_dir, f"{name}.html")
    with open(tmpl_path, "w", encoding="utf-8") as f:
        f.write("\n".join(tmpl))
    print(f"Template: {tmpl_path}")

    # ─── SUMMARY ─────────────────────────────────────────────────
    print(f"\nSummary for {os.path.basename(filepath)}:")
    print(f"  View type:   {view_type}")
    print(f"  Auth level:  {auth_level}")
    print(f"  Databases:   {databases}")
    print(f"  SQL ops:     {sql_ops}")
    print(f"  URL params:  {request_keys}")
    print(f"  Mixins:      {mixins}")


def main():
    parser = argparse.ArgumentParser(description="ASP -> Django view generator")
    parser.add_argument("file", help=".asp file to convert")
    parser.add_argument("--out-dir", default=".", help="Output directory")
    args = parser.parse_args()

    os.makedirs(args.out_dir, exist_ok=True)
    generate_view(args.file, args.out_dir)


if __name__ == "__main__":
    main()
