import glob
import os

team_files = glob.glob("c:/Users/yaniv/dev/milon/spoken-arabic-dictionary/team/*.asp")

for f_path in team_files:
    if not os.path.isfile(f_path):
        continue
    with open(f_path, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()

    changed = False

    if '<!--#include virtual="/inc/trailer.asp"-->\n</body>\n</html>' in text:
        text = text.replace(
            '<!--#include virtual="/inc/trailer.asp"-->\n</body>\n</html>',
            '<!--#include virtual="/inc/trailer.asp"-->',
        )
        changed = True
    elif '<!--#include virtual="/inc/trailer.asp"-->\r\n</body>\r\n</html>' in text:
        text = text.replace(
            '<!--#include virtual="/inc/trailer.asp"-->\r\n</body>\r\n</html>',
            '<!--#include virtual="/inc/trailer.asp"-->',
        )
        changed = True

    if changed:
        with open(f_path, "w", encoding="utf-8") as f:
            f.write(text)
        print("Updated HTML tags in", f_path)

print("Team files cleaned.")
