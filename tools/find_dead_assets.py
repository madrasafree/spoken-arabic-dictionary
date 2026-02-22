import os
import re

target_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"


def get_all_assets():
    assets = []
    for root, dirs, files in os.walk(target_dir):
        if (
            ".git" in root
            or "tools" in root
            or "docs" in root
            or "App_Data" in root
            or ".gemini" in root
        ):
            continue
        for file in files:
            if file.endswith(
                (
                    ".css",
                    ".js",
                    ".png",
                    ".jpg",
                    ".gif",
                    ".svg",
                    ".jpeg",
                    ".webp",
                    ".otf",
                    ".ttf",
                )
            ):
                assets.append(
                    os.path.relpath(os.path.join(root, file), target_dir).replace(
                        "\\", "/"
                    )
                )
    return assets


def get_all_code():
    code = ""
    for root, dirs, files in os.walk(target_dir):
        if ".git" in root or "tools" in root or "docs" in root or "App_Data" in root:
            continue
        for file in files:
            if file.endswith((".asp", ".js", ".css", ".html", ".php", ".xml", ".json")):
                try:
                    with open(
                        os.path.join(root, file), "r", encoding="utf-8", errors="ignore"
                    ) as f:
                        code += f.read()
                except:
                    pass
    return code


assets = get_all_assets()
code = get_all_code()

dead = []
for asset in assets:
    filename = os.path.basename(asset)
    # Exclude common names or generic resets
    if filename not in code and filename != "normalize.css":
        dead.append(asset)

print("=== POTENTIALLY DEAD EXACT-MATCH ASSETS ===")
for d in dead:
    print(d)
