import os
import shutil
import subprocess

# Create directories
os.makedirs("assets/css", exist_ok=True)
os.makedirs("assets/js", exist_ok=True)
os.makedirs("assets/images", exist_ok=True)

moves = [
    # CSS
    ("css/arabic_admin.css", "assets/css/arabic_admin.css"),
    ("css/arabic_admin_slider.css", "assets/css/arabic_admin_slider.css"),
    ("css/arabic_constant.css", "assets/css/arabic_constant.css"),
    ("css/arabic_from500high.css", "assets/css/arabic_from500high.css"),
    ("css/arabic_from500wide.css", "assets/css/arabic_from500wide.css"),
    ("css/arabic_upto499high.css", "assets/css/arabic_upto499high.css"),
    ("css/arabic_upto499wide.css", "assets/css/arabic_upto499wide.css"),
    ("css/arabic_utils.css", "assets/css/arabic_utils.css"),
    ("css/devMode.css", "assets/css/devMode.css"),
    ("css/nav.css", "assets/css/nav.css"),
    ("css/normalize.css", "assets/css/normalize.css"),
    ("team/inc/arabicTeam.css", "assets/css/arabicTeam.css"),
    ("team/inc/edit.css", "assets/css/edit.css"),
    ("team/inc/guide.css", "assets/css/guide.css"),
    # JS
    ("inc/functions/saa3a.js", "assets/js/saa3a.js"),
    ("inc/youtube.js", "assets/js/youtube.js"),
    ("team/js/jquery.list.update.js", "assets/js/jquery.list.update.js"),
    ("team/js/jquery.new.edit.js", "assets/js/jquery.new.edit.js"),
    ("team/js/scripts.js", "assets/js/scripts.js"),
    # Images directory content
    ("img/labels", "assets/images/labels"),
    ("img/links", "assets/images/links"),
    ("img/lists", "assets/images/lists"),
    ("img/pics", "assets/images/pics"),
    ("img/profiles", "assets/images/profiles"),
    ("img/site", "assets/images/site"),
    ("img/tasks", "assets/images/tasks"),
]

for src, dst in moves:
    if os.path.exists(src):
        print(f"Moving {src} to {dst}")
        subprocess.run(["git", "mv", src, dst])
    else:
        print(f"Skipping {src}, does not exist")

print("Finished python script")
