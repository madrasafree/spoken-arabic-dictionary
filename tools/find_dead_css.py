import os
import glob
import re

project_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"


# 1. Get all code files
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


css_files = get_code_files(["css"])
other_files = get_code_files(["asp", "inc", "js", "html"])

# 2. Extract CSS classes from CSS files
css_content = ""
for f in css_files:
    try:
        with open(f, "r", encoding="utf-8") as file:
            css_content += file.read() + "\n"
    except Exception:
        pass

# Match .classname { or .classname,
# This regex is simplified but catches most normal classes
class_pattern = re.compile(r"\.([a-zA-Z0-9_-]+)\s*[{,:]")
found_classes = set(class_pattern.findall(css_content))

# 3. Check for usage in other files
code_content = ""
for f in other_files:
    try:
        with open(f, "r", encoding="utf-8") as file:
            code_content += file.read() + "\n"
    except Exception:
        try:
            with open(f, "r", encoding="windows-1255") as file:
                code_content += file.read() + "\n"
        except Exception:
            pass

code_content_lower = code_content.lower()

dead_classes = []
for c in found_classes:
    # simple word boundary check in all code content
    # If the class name never appears in the regular code, it's unused.
    c_lower = c.lower()
    pattern = re.compile(r"\b" + re.escape(c_lower) + r"\b")
    if not pattern.search(code_content_lower):
        dead_classes.append(c)

print("=== POTENTIALLY DEAD CSS CLASSES ===")
for d in sorted(dead_classes):
    print(d)
