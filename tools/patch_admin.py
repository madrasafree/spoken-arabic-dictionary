import os
import urllib.parse

base_path = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"
admin_dir = os.path.join(base_path, "admin")

files = [f for f in os.listdir(admin_dir) if f.endswith(".asp")]

for filename in files:
    filepath = os.path.join(admin_dir, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    original = content

    # Redirection fix
    # Match Response.Redirect "../team/login.asp" or Response.Redirect "../login.asp"
    redirect_target = '/login.asp?returnTo=" & Server.URLEncode(Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING"))'
    content = content.replace(
        'Response.Redirect "../team/login.asp"', 'Response.Redirect "' + redirect_target
    )
    content = content.replace(
        'Response.Redirect "../login.asp"', 'Response.Redirect "' + redirect_target
    )

    # Asset fix
    content = content.replace('href="../assets/', 'href="/assets/')
    content = content.replace('src="../assets/', 'src="/assets/')
    content = content.replace('href="../img/', 'href="/img/')
    content = content.replace('src="../img/', 'src="/img/')

    # index.asp -> default.asp
    # (Be careful not to replace parts of other words, but .asp is safe)
    content = content.replace("index.asp", "default.asp")

    if content != original:
        with open(filepath, "w", encoding="utf-8", newline="") as f:
            f.write(content)
        print(f"Patched: {filename}")
    else:
        print(f"No changes for {filename}")
