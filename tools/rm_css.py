import subprocess

files = [
    "assets/css/normalize.css",
    "assets/css/nav.css",
    "assets/css/arabic_constant.css",
    "assets/css/arabic_upto499wide.css",
    "assets/css/arabic_from500wide.css",
    "assets/css/arabic_upto499high.css",
    "assets/css/arabic_from500high.css",
]

subprocess.run(["git", "rm"] + files)
