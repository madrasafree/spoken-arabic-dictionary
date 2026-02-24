import os
import re

admin_dir = "admin"
files = [f for f in os.listdir(admin_dir) if f.endswith(".asp")]

print(f"Checking {len(files)} files in {admin_dir}")

for filename in files:
    filepath = os.path.join(admin_dir, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace file="../includes/ with virtual="/includes/
    # Also handle team includes just in case: file="../includes_team/
    # And any other parent path includes

    new_content = re.sub(
        r'<!--#include\s+file="\.\./includes/([^"]+)"-->',
        r'<!--#include virtual="/includes/\1"-->',
        content,
    )

    # Specific case for team includes if they exist
    new_content = re.sub(
        r'<!--#include\s+file="\.\./includes_team/([^"]+)"-->',
        r'<!--#include virtual="/includes/\1"-->',
        new_content,
    )

    if new_content != content:
        with open(filepath, "w", encoding="utf-8", newline="") as f:
            f.write(new_content)
        print(f"Updated: {filename}")
    else:
        print(f"No changes: {filename}")
