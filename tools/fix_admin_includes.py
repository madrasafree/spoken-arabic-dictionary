import os
import glob
import re

# Get all asp files in the admin folder
files = glob.glob("admin/*.asp")

for f_path in files:
    with open(f_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace <!--#include file="../includes/... --> with <!--#include virtual="/includes/... -->
    # Using regex to handle variations in spacing or quotes
    new_content = re.sub(
        r'<!--#include\s+file="\.\./includes/([^"]+)"-->',
        r'<!--#include virtual="/includes/\1"-->',
        content,
    )

    # Also handle team login ref which I moved back
    # Response.Redirect "../team/login.asp" should probably stay as is since it's a URL redirect, not an include.
    # But includes are the concern for Parent Paths.

    if new_content != content:
        with open(f_path, "w", encoding="utf-8") as f:
            f.write(new_content)
        print(f"Updated {f_path}")
    else:
        print(f"No changes needed for {f_path}")
