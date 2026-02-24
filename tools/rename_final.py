import os

src = "admin/index.asp"
dst = "admin/default.asp"

if os.path.exists(src):
    if os.path.exists(dst):
        os.remove(dst)
    os.rename(src, dst)
    print(f"Successfully renamed {src} to {dst}")
else:
    print(f"Source file {src} not found")
