import os

base_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"
team_dir = os.path.join(base_dir, "team")

# Only process files inside "team" directory that are .asp
for root, dirs, files in os.walk(team_dir):
    for file in files:
        if file.endswith(".asp"):
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()

            original = content

            # Since my previous script replaced file="inc/ with file="includes/,
            # Now these files say file="includes/...
            #
            # But inside "team/", file="includes/inc.asp" should be file="../includes/inc_team.asp"
            # And file="includes/time.asp" -> file="../includes/time.asp"
            # file="includes/" -> file="../includes/"

            # First, fix the inc.asp specific case:
            content = content.replace(
                'file="includes/inc.asp"', 'file="../includes/inc_team.asp"'
            )

            # Now fix any remaining file="includes/... that should be file="../includes/...
            content = content.replace('file="includes/', 'file="../includes/')

            if content != original:
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Fixed {filepath}")

# Also fix root files just in case they have file="includes/inc_team.asp" which was produced from file="team/inc/inc.asp" (wait, I replaced file="team/inc/inc.asp" with file="includes/inc_team.asp" which is correct for root files)
