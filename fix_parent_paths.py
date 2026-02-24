import os

base_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"
team_dir = os.path.join(base_dir, "team")

for root, dirs, files in os.walk(team_dir):
    for file in files:
        if file.endswith(".asp"):
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()

            original = content

            # Replace file="../includes/ with virtual="/includes/
            # This fixes the ASP 0131 Disallowed Parent Path error
            content = content.replace('file="../includes/', 'virtual="/includes/')

            if content != original:
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Fixed parent path in {filepath}")
