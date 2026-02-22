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

            if not filepath.endswith(".css"):
                # Handle team/img/ which were left behind
                content = re.sub(r'([\'"])team/img/', r"\1assets/images/team/", content)
                content = re.sub(
                    r'([\'"])\.\./team/img/', r"\1../assets/images/team/", content
                )

                # Handle url(img/...) and url(../img/...) inside HTML/ASP style tags
                content = content.replace("url(img/", "url(assets/images/")
                content = content.replace("url(../img/", "url(../assets/images/")

                # if there is url(<%=baseA%>img/...)
                content = content.replace(
                    "url(<%=baseA%>img/", "url(<%=baseA%>assets/images/"
                )

            if orig != content:
                print(f"Modifying {os.path.relpath(filepath, base_dir)} for final pass")
                try:
                    with open(filepath, "w", encoding="utf-8") as file_out:
                        file_out.write(content)
                except Exception as e:
                    with open(filepath, "w", encoding="windows-1255") as file_out:
                        file_out.write(content)


if __name__ == "__main__":
    main()
