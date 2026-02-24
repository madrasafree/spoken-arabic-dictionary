import os
import re

admin_dir = "admin"
files = [f for f in os.listdir(admin_dir) if f.endswith(".asp")]

print(f"Processing {len(files)} files in {admin_dir}")

for filename in files:
    filepath = os.path.join(admin_dir, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    original_content = content

    # 1. Fix includes (ensure virtual)
    content = re.sub(
        r'<!--#include\s+file="\.\./includes/([^"]+)"-->',
        r'<!--#include virtual="/includes/\1"-->',
        content,
    )

    # 2. Fix asset links (relative to baseA)
    # Match both href and src that point to ../assets/ or ../img/ or ../assets/
    # Actually, let's just match any ../ that points to common asset dirs
    content = re.sub(r'(href|src)="\.\./assets/', r'\1="<%=baseA%>assets/', content)
    content = re.sub(r'(href|src)="\.\./img/', r'\1="<%=baseA%>img/', content)

    # 3. Fix Redirection to login with returnTo
    # Look for Response.Redirect "../login.asp" or similar
    # Using regex to handle variations in quotes and spacing
    redirect_pattern = r'Response\.Redirect\s+"\.\./(team/)?login\.asp"'
    replacement = 'Response.Redirect "../login.asp?returnTo=" & Server.URLEncode(Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING"))'
    content = re.sub(redirect_pattern, replacement, content, flags=re.IGNORECASE)

    # Special case for index.asp -> default.asp links inside admin
    content = content.replace('href="index.asp"', 'href="default.asp"')
    content = content.replace("href='index.asp'", "href='default.asp'")
    content = content.replace('action="index.asp"', 'action="default.asp"')
    content = content.replace('"index.asp"', '"default.asp"')

    if content != original_content:
        with open(filepath, "w", encoding="utf-8", newline="") as f:
            f.write(content)
        print(f"Updated: {filename}")
    else:
        print(f"No changes: {filename}")
