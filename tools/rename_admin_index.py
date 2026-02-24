import os
import time

src = "admin/index.asp"
dst = "admin/default.asp"

if os.path.exists(src):
    try:
        if os.path.exists(dst):
            os.remove(dst)
        os.rename(src, dst)
        print(f"Renamed {src} to {dst}")
    except Exception as e:
        print(f"Error: {e}")
else:
    print(f"{src} does not exist")
