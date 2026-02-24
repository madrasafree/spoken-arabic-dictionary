import os
import re

admin_dir = "admin"
files = [f for f in os.listdir(admin_dir) if f.endswith(".asp")]

for filename in files:
    filepath = os.path.join(admin_dir, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace ../assets/ with <%=baseA%>assets/
    new_content = content.replace("../assets/", "<%=baseA%>assets/")

    # Also handle team login redirect back link if it was broken
    # Actually, redirects with ../ should work fine as long as the browser handles them,
    # but baseA is safer for resource loading.

    if new_content != content:
        with open(filepath, "w", encoding="utf-8", newline="") as f:
            f.write(new_content)
        print(f"Updated: {filename}")
    else:
        print(f"No changes: {filename}")
