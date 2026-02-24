import os
import re

base_path = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"
admin_dir = os.path.join(base_path, "admin")

files = [f for f in os.listdir(admin_dir) if f.endswith(".asp")]

# Search for both ../team/login.asp and ../login.asp
# Use a more flexible regex
redirect_pattern = re.compile(
    r'Response\.Redirect\s+"(?:\.\./)+(?:team/)?login\.asp"', re.IGNORECASE
)
returnTo_logic = 'Response.Redirect "/login.asp?returnTo=" & Server.URLEncode(Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING"))'

# Search for href/src with ../assets/
asset_pattern = re.compile(r'(href|src)="(?:\.\./)+assets/', re.IGNORECASE)
asset_replacement = r'\1="/assets/'

# Search for index.asp inside links
index_pattern = re.compile(r"index\.asp", re.IGNORECASE)
index_replacement = "default.asp"

for filename in files:
    filepath = os.path.join(admin_dir, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    original = content

    content = redirect_pattern.sub(returnTo_logic, content)
    content = asset_pattern.sub(asset_replacement, content)

    # Only replace index.asp if it's not the current filename (avoid self-references if we rename)
    # But since we have both default.asp and index.asp, it's safer to point to default.asp
    content = index_pattern.sub(index_replacement, content)

    if content != original:
        with open(filepath, "w", encoding="utf-8", newline="") as f:
            f.write(content)
        print(f"Patched: {filename}")
    else:
        print(f"No changes: {filename}")
