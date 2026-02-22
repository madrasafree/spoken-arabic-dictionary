import os
import glob
import re

project_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"

# 1. Parse tables.txt
tables = []
current_db = None
with open(os.path.join(project_dir, "tools", "tables.txt"), "r") as f:
    for line in f:
        line = line.strip()
        if line.startswith("DB: "):
            current_db = line[4:]
        elif line.startswith("TABLE: "):
            tbl = line[7:]
            tables.append((current_db, tbl))


# 2. Get all ASP/JS/HTML files
def get_all_code_files(exts):
    files = []
    for ext in exts:
        for fname in glob.glob(
            os.path.join(project_dir, "**", f"*.{ext}"), recursive=True
        ):
            if (
                ".git" in fname
                or "App_Data" in fname
                or "\\docs\\" in fname
                or "\\tools\\" in fname
            ):
                continue
            files.append(fname)
    return files


code_files = get_all_code_files(["asp", "html", "js", "vbs", "inc"])
code_content = []
for f in code_files:
    try:
        with open(f, "r", encoding="utf-8") as file:
            code_content.append(file.read().lower())
    except Exception:
        try:
            with open(f, "r", encoding="windows-1255") as file:
                code_content.append(file.read().lower())
        except Exception:
            pass

unused_tables = []
for db, tbl in tables:
    tbl_lower = tbl.lower()

    t_used = False

    # We look for typical query usage patterns, or just the word itself bounded by quotes or spaces or brackets
    # E.g., `from words` or `update words` or `[words]` or `"words"`
    pattern1 = f"from {tbl_lower}"
    pattern2 = f"update {tbl_lower}"
    pattern3 = f"insert into {tbl_lower}"
    pattern4 = f"into {tbl_lower}"
    pattern5 = f"[{tbl_lower}]"
    pattern6 = f"join {tbl_lower}"

    for content in code_content:
        # Check patterns first (fastest)
        if (
            pattern1 in content
            or pattern2 in content
            or pattern3 in content
            or pattern4 in content
            or pattern5 in content
            or pattern6 in content
        ):
            t_used = True
            break

        # If not matched by strict patterns, check just exact word boundary, often passed as a string/variable
        # Use regex for word boundary
        if re.search(r"\b" + re.escape(tbl_lower) + r"\b", content):
            t_used = True
            break

    if not t_used:
        unused_tables.append(f"{db} -> {tbl}")

print("=== UNUSED TABLES ===")
for x in unused_tables:
    print(x)
