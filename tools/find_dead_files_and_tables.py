import os
import glob

project_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"


# 1. Find all ASP and inc files
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


code_files = get_all_code_files(["asp", "html", "js", "vbs", "inc", "css"])
code_content = {}
for f in code_files:
    try:
        with open(f, "r", encoding="utf-8") as file:
            code_content[f] = file.read().lower()
    except Exception:
        try:
            with open(f, "r", encoding="windows-1255") as file:
                code_content[f] = file.read().lower()
        except Exception:
            pass

entry_points = [
    "default.asp",
    "login.asp",
    "about.asp",
    "label.asp",
    "profile.asp",
    "sentence.asp",
    "word.asp",
]
dead_files = []

for f in code_files:
    basename = os.path.basename(f).lower()
    if (
        basename in entry_points
        or "web.config" in f.lower()
        or "global.asa" in f.lower()
    ):
        continue

    # search for this basename in all other files
    is_used = False
    for other_f, content in code_content.items():
        if f == other_f:
            continue
        if basename in content:
            is_used = True
            break

    if not is_used:
        dead_files.append(f)

# 2. Check databases used by searching for OpenDB("name") or similar usages
mdb_dir = os.path.join(project_dir, "App_Data")
mdb_files = glob.glob(os.path.join(mdb_dir, "*.mdb"))
unused_dbs = []

for mdb in mdb_files:
    basename = os.path.basename(mdb).lower()
    db_name = basename.replace(".mdb", "")

    mdb_used = False
    for content in code_content.values():
        if db_name in content:
            mdb_used = True
            break
    if not mdb_used:
        unused_dbs.append(mdb)

print("=== DEAD FILES (Unreferenced in code) ===")
for x in dead_files:
    print(x)
print("\n=== UNUSED DATABASES ===")
for x in unused_dbs:
    print(x)
