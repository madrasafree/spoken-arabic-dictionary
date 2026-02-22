import os
import glob
import re

project_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"


# 1. Get all relevant files
def get_code_files(exts):
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


code_files = get_code_files(["asp", "inc", "js", "html"])

code_content = {}
for f in code_files:
    try:
        with open(f, "r", encoding="utf-8") as file:
            code_content[f] = file.read()
    except Exception:
        try:
            with open(f, "r", encoding="windows-1255") as file:
                code_content[f] = file.read()
        except Exception:
            pass

# 2. Extract function/sub definitions
vb_subs = set()
vb_funcs = set()
js_funcs = set()

# Regexes
re_vb_sub = re.compile(r"(?i)^\s*Sub\s+([a-zA-Z0-9_]+)\b", re.MULTILINE)
re_vb_func = re.compile(r"(?i)^\s*Function\s+([a-zA-Z0-9_]+)\b", re.MULTILINE)
re_js_func = re.compile(r"\bfunction\s+([a-zA-Z0-9_]+)\s*\(", re.MULTILINE)

defined_all = {}  # symbol -> list of files

for f, content in code_content.items():
    s_matches = re_vb_sub.findall(content)
    for s in s_matches:
        s_lower = s.lower()
        if s_lower not in defined_all:
            defined_all[s_lower] = []
        defined_all[s_lower].append((s, f, "vbs_sub"))
        vb_subs.add(s_lower)

    f_matches = re_vb_func.findall(content)
    for fn in f_matches:
        fn_lower = fn.lower()
        if fn_lower not in defined_all:
            defined_all[fn_lower] = []
        defined_all[fn_lower].append((fn, f, "vbs_func"))
        vb_funcs.add(fn_lower)

    js_matches = re_js_func.findall(content)
    for jf in js_matches:
        jf_lower = jf.lower()
        if jf_lower not in defined_all:
            defined_all[jf_lower] = []
        defined_all[jf_lower].append((jf, f, "js_func"))
        js_funcs.add(jf_lower)

# VBScript events that should not be removed
ignore_list = [
    "session_onstart",
    "session_onend",
    "application_onstart",
    "application_onend",
]

dead_symbols = []

# 3. Check for usage
for sym_lower, definitions in defined_all.items():
    if sym_lower in ignore_list:
        continue

    # how many times is this symbol used in the ENTIRE codebase?
    count = 0
    # use word boundary search for accurate counts
    pattern = re.compile(r"\b" + re.escape(sym_lower) + r"\b", re.IGNORECASE)

    for content in code_content.values():
        count += len(pattern.findall(content))

    # If the total count equals the number of definitions, it might be dead
    # E.g. 1 definition and 0 usages = 1 total count. 1 definition and 1 usage = 2 total count.
    if count == len(definitions):
        for rep, fpath, stype in definitions:
            dead_symbols.append(f"{stype}: {rep} in {os.path.basename(fpath)}")


print("=== UNUSED FUNCTIONS / SUBS ===")
for d in sorted(dead_symbols):
    print(d)
