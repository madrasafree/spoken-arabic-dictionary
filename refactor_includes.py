import os
import shutil
import re

base_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"
includes_dir = os.path.join(base_dir, "includes")
includes_func_dir = os.path.join(includes_dir, "functions")

# Create directories
os.makedirs(includes_func_dir, exist_ok=True)

# Define which source files to copy to includes/
file_mappings = {
    # File paths relative to base_dir -> Destination inside includes/
    "inc/header.asp": "header.asp",
    "inc/top.asp": "top.asp",
    "inc/banner.asp": "banner.asp",
    "inc/trailer.asp": "trailer.asp",
    "inc/topTeam.asp": "topTeam.asp",
    # Root inc.asp
    "inc/inc.asp": "inc.asp",
    # Team inc.asp and inc_online.asp
    "team/inc/inc.asp": "inc_team.asp",
    "team/inc/inc_online.asp": "inc_online.asp",
    # functions
    "inc/functions/functions.asp": "functions/functions.asp",
    "inc/functions/string.asp": "functions/string.asp",
    # For soundex and time, we determined team's version is better
    "team/inc/functions/soundex.asp": "functions/soundex.asp",
    "team/inc/time.asp": "time.asp",
}

print("Copying files to includes/...")
for src_rel, dest_rel in file_mappings.items():
    src = os.path.join(base_dir, src_rel)
    dest = os.path.join(includes_dir, dest_rel)
    if os.path.exists(src):
        print(f"Copying {src_rel} to {dest_rel}")
        shutil.copy2(src, dest)
    else:
        print(f"WARNING: Source file not found: {src_rel}")


# Now, we process all .asp files in base_dir and team_dir replacing include paths
def update_file(filepath):
    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    original = content

    # Mappings for strings to replace
    # Replacing team/inc/inc.asp -> includes/inc_team.asp
    content = content.replace('file="team/inc/inc.asp"', 'file="includes/inc_team.asp"')
    content = content.replace(
        'file="team/inc/inc_online.asp"', 'file="includes/inc_online.asp"'
    )

    # team/inc/functions.asp -> includes/functions/functions.asp
    content = content.replace(
        'file="team/inc/functions.asp"', 'file="includes/functions/functions.asp"'
    )

    # other team/inc/ -> includes/
    content = content.replace('file="team/inc/time.asp"', 'file="includes/time.asp"')
    content = content.replace(
        'file="team/inc/functions/soundex.asp"', 'file="includes/functions/soundex.asp"'
    )
    content = content.replace(
        'file="team/inc/functions/string.asp"', 'file="includes/functions/string.asp"'
    )

    # standard inc/ -> includes/
    # This might match `file="inc/` and `virtual="/inc/`
    content = content.replace('file="inc/', 'file="includes/')
    content = content.replace('virtual="/inc/', 'virtual="/includes/')

    if content != original:
        # Save file with utf-8
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated {filepath}")


# Iterate through all asp files
for root, dirs, files in os.walk(base_dir):
    # skip node_modules, .git, etc
    if ".git" in root or "App_Data" in root or "includes" in root or "assets" in root:
        continue
    for file in files:
        if file.endswith(".asp") and not file == "refactor_includes.py":
            update_file(os.path.join(root, file))

print("Done updating includes!")
