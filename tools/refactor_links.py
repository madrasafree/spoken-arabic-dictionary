import os
import re


def main():
    base_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"

    # Files to process
    exts = (".asp", ".html", ".php", ".js", ".css", ".md")

    for root, dirs, files in os.walk(base_dir):
        if ".git" in root or "tools" in root or ".github" in root:
            continue

        for f in files:
            if not f.lower().endswith(exts):
                continue

            filepath = os.path.join(root, f)
            try:
                with open(filepath, "r", encoding="utf-8") as file_in:
                    content = file_in.read()
            except UnicodeDecodeError:
                with open(filepath, "r", encoding="windows-1255") as file_in:
                    content = file_in.read()

            orig = content

            # CSS files specifically
            if filepath.endswith(".css"):
                content = content.replace("url(../img/", "url(../images/")
                content = content.replace("url(img/", "url(../images/")
                content = content.replace('url("../inc/', 'url("../../inc/')
                content = content.replace("url('../inc/", "url('../../inc/")

            else:
                rel_path = os.path.relpath(filepath, base_dir)
                is_team = rel_path.startswith("team\\") or rel_path.startswith("team/")

                # Global replacements
                # Replace specific team assets first
                content = re.sub(
                    r'([\'"])team/inc/arabicTeam\.css',
                    r"\1assets/css/arabicTeam.css",
                    content,
                )
                content = re.sub(
                    r'([\'"])team/inc/edit\.css', r"\1assets/css/edit.css", content
                )
                content = re.sub(
                    r'([\'"])team/inc/guide\.css', r"\1assets/css/guide.css", content
                )

                content = re.sub(
                    r'([\'"])team/js/jquery\.list\.update\.js',
                    r"\1assets/js/jquery.list.update.js",
                    content,
                )
                content = re.sub(
                    r'([\'"])team/js/jquery\.new\.edit\.js',
                    r"\1assets/js/jquery.new.edit.js",
                    content,
                )
                content = re.sub(
                    r'([\'"])team/js/scripts\.js', r"\1assets/js/scripts.js", content
                )

                content = re.sub(
                    r'([\'"])inc/functions/saa3a\.js', r"\1assets/js/saa3a.js", content
                )
                content = re.sub(
                    r'([\'"])inc/youtube\.js', r"\1assets/js/youtube.js", content
                )

                if is_team:
                    # Inside team/, img/ meant team/img/ which is now assets/images/team/
                    # Note: we need to reach root/assets/images/team, so ../assets/images/team/
                    content = re.sub(
                        r'([\'"])img/', r"\1../assets/images/team/", content
                    )
                    content = re.sub(
                        r'([\'"])inc/arabicTeam\.css',
                        r"\1../assets/css/arabicTeam.css",
                        content,
                    )
                    content = re.sub(
                        r'([\'"])inc/edit\.css', r"\1../assets/css/edit.css", content
                    )
                    content = re.sub(
                        r'([\'"])inc/guide\.css', r"\1../assets/css/guide.css", content
                    )

                    content = re.sub(
                        r'([\'"])js/jquery\.list\.update\.js',
                        r"\1../assets/js/jquery.list.update.js",
                        content,
                    )
                    content = re.sub(
                        r'([\'"])js/jquery\.new\.edit\.js',
                        r"\1../assets/js/jquery.new.edit.js",
                        content,
                    )
                    content = re.sub(
                        r'([\'"])js/scripts\.js', r"\1../assets/js/scripts.js", content
                    )

                    # For cases where team files used ../img or ../css (pointing to root)
                    content = re.sub(
                        r'([\'"])\.\./img/', r"\1../assets/images/", content
                    )
                    content = re.sub(r'([\'"])\.\./css/', r"\1../assets/css/", content)
                    content = re.sub(
                        r'([\'"])\.\./inc/functions/saa3a\.js',
                        r"\1../assets/js/saa3a.js",
                        content,
                    )
                    content = re.sub(
                        r'([\'"])\.\./inc/youtube\.js',
                        r"\1../assets/js/youtube.js",
                        content,
                    )
                else:
                    # In root, img/ means assets/images/
                    content = re.sub(r'([\'"])img/', r"\1assets/images/", content)
                    content = re.sub(r'([\'"])css/', r"\1assets/css/", content)
                    # Also if anything erroneously had inc/guide.css it becomes assets/css/guide.css
                    content = re.sub(
                        r'([\'"])inc/guide\.css', r"\1assets/css/guide.css", content
                    )

            if orig != content:
                print(f"Modifying {rel_path}")
                try:
                    with open(filepath, "w", encoding="utf-8") as file_out:
                        file_out.write(content)
                except Exception as e:
                    # fallback to write in the same encoding if it was windows-1255 initially
                    with open(filepath, "w", encoding="windows-1255") as file_out:
                        file_out.write(content)


if __name__ == "__main__":
    main()
