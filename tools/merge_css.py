import os
import re


def main():
    base_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"
    css_dir = os.path.join(base_dir, "assets", "css")

    # Files to merge
    core_files = ["normalize.css", "nav.css", "arabic_constant.css"]
    media_files = [
        ("arabic_upto499wide.css", "(max-width:499px)"),
        ("arabic_from500wide.css", "(min-width:500px)"),
        ("arabic_upto499high.css", "(max-height:499px)"),
        ("arabic_from500high.css", "(min-height:500px)"),
    ]

    merged_css = "/* COMBINED MILON CSS */\n"

    for fname in core_files:
        path = os.path.join(css_dir, fname)
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            merged_css += f"/* === {fname} === */\n"
            merged_css += f.read() + "\n\n"

    for fname, media_qry in media_files:
        path = os.path.join(css_dir, fname)
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            merged_css += f"/* === {fname} === */\n"
            merged_css += f"@media {media_qry} {{\n"
            merged_css += f.read() + "\n"
            merged_css += "}\n\n"

    with open(os.path.join(css_dir, "milon_main.css"), "w", encoding="utf-8") as f:
        f.write(merged_css)

    print("milon_main.css created successfully.")

    # Now replace references in HTML/ASP files
    exts = (".asp", ".html", ".php")

    # Regexes to find any of these CSS links
    css_pattern = re.compile(
        r'<link\s+rel="stylesheet"\s+href="[^"]*(normalize|nav|arabic_constant|arabic_upto499wide|arabic_from500wide|arabic_upto499high|arabic_from500high)\.css.*?>\s*',
        re.IGNORECASE,
    )

    for root, dirs, files in os.walk(base_dir):
        if ".git" in root or "tools" in root or ".github" in root:
            continue

        for fname in files:
            if not fname.lower().endswith(exts):
                continue

            filepath = os.path.join(root, fname)
            try:
                with open(filepath, "r", encoding="utf-8") as f:
                    content = f.read()
            except UnicodeDecodeError:
                with open(filepath, "r", encoding="windows-1255") as f:
                    content = f.read()

            orig = content

            # Check if it has any of these
            if css_pattern.search(content):
                team_inc = (
                    "baseA" in content
                    and "<%=baseA%>"
                    in re.findall(
                        r'href="([^"]+)"', css_pattern.search(content).group(0)
                    )[0]
                    if css_pattern.search(content)
                    else False
                )

                # We need to insert the unified link BEFORE the first occurrence, then remove all occurrences
                first_match = css_pattern.search(content)
                if first_match:
                    href_str = first_match.group(0)
                    base_prefix = "<%=baseA%>" if "<%=baseA%>" in href_str else ""
                    # For team folder vs root folder logic if there is no baseA
                    if not base_prefix and "../assets/css/" in href_str:
                        link_val = "../assets/css/milon_main.css"
                    else:
                        link_val = f"{base_prefix}assets/css/milon_main.css"

                    new_link = f'<link rel="stylesheet" href="{link_val}" />\n\t'

                    # Remove all individual links
                    content = css_pattern.sub("", content)

                    # Insert the unified link where the first one used to be
                    pos = first_match.start()
                    content = content[:pos] + new_link + content[pos:]

            if orig != content:
                print(f"Modifying {os.path.relpath(filepath, base_dir)}")
                try:
                    with open(filepath, "w", encoding="utf-8") as f:
                        f.write(content)
                except Exception:
                    with open(filepath, "w", encoding="windows-1255") as f:
                        f.write(content)


if __name__ == "__main__":
    main()
