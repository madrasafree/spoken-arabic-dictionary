import os
import shutil
import subprocess

# Create targets
os.makedirs("assets/images/team", exist_ok=True)
os.makedirs("assets/js", exist_ok=True)
os.makedirs("assets/css", exist_ok=True)

subprocess.run(
    ["git", "mv", "team/img/teamFavicon.ico", "assets/images/team/teamFavicon.ico"]
)
subprocess.run(
    [
        "git",
        "mv",
        "team/img/teamLogo-let1-60px.png",
        "assets/images/team/teamLogo-let1-60px.png",
    ]
)
subprocess.run(
    [
        "git",
        "mv",
        "team/img/teamLogo-let2-60px.png",
        "assets/images/team/teamLogo-let2-60px.png",
    ]
)
subprocess.run(
    [
        "git",
        "mv",
        "team/img/teamLogo-let3-60px.png",
        "assets/images/team/teamLogo-let3-60px.png",
    ]
)
subprocess.run(
    [
        "git",
        "mv",
        "team/img/teamLogo-let4-60px.png",
        "assets/images/team/teamLogo-let4-60px.png",
    ]
)
subprocess.run(
    ["git", "mv", "team/img/teamLogo.png", "assets/images/team/teamLogo.png"]
)

print("Finished team image moves.")
