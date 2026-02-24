import os

admin_dir = "admin"
for filename in os.listdir(admin_dir):
    if filename.endswith(".asp"):
        filepath = os.path.join(admin_dir, filename)
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()

            new_content = content.replace('file="../includes/', 'virtual="/includes/')

            if new_content != content:
                with open(filepath, "w", encoding="utf-8", newline="") as f:
                    f.write(new_content)
                print(f"Updated {filename}")
            else:
                print(f"No changes for {filename}")
        except Exception as e:
            print(f"Error processing {filename}: {e}")
