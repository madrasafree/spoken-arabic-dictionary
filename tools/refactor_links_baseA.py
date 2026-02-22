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

            if filepath.endswith(".css"):
                continue  # css files already handled correctly

            # Replacing <%=baseA%>css/ -> <%=baseA%>assets/css/
            content = re.sub(r"(<%=baseA%>)css/", r"\1assets/css/", content)
            content = re.sub(r"(<%=baseA%>)img/", r"\1assets/images/", content)

            # For the ones that had "img/site/..." without quote right before it,
            # we also might have other missed things. Let's just catch anything like:
            # `(>|%>)img/` -> `\1assets/images/` ? But baseA replaces should be enough.

            if orig != content:
                print(
                    f"Modifying {os.path.relpath(filepath, base_dir)} for baseA replacements"
                )
                try:
                    with open(filepath, "w", encoding="utf-8") as file_out:
                        file_out.write(content)
                except Exception as e:
                    with open(filepath, "w", encoding="windows-1255") as file_out:
                        file_out.write(content)


if __name__ == "__main__":
    main()
