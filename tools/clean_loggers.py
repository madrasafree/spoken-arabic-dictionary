import os

target_dir = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary"


def clean_file(filepath):
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except UnicodeDecodeError:
        try:
            with open(filepath, "r", encoding="windows-1255") as f:
                lines = f.readlines()
        except:
            return 0

    new_lines = []
    lines_removed = 0

    # We WILL NOT strip openDbLogger or closeDbLogger because they trigger the essential OpenDB() connection!

    for line in lines:
        stripped = line.strip()
        if (
            stripped.startswith("startTime = timer()")
            or stripped.startswith("endTime = timer()")
            or stripped.startswith("durationMs =")
            or stripped.startswith("dim startTime, endTime, durationMs")
        ):
            lines_removed += 1
            pass
        else:
            new_lines.append(line)

    if lines_removed > 0:
        try:
            with open(filepath, "w", encoding="utf-8") as f:
                f.writelines(new_lines)
        except Exception as e:
            return 0
        return lines_removed
    return 0


total_removed = 0
for root, dirs, files in os.walk(target_dir):
    for file in files:
        if file.endswith(".asp") or file.endswith(".inc"):
            filepath = os.path.join(root, file)
            removed = clean_file(filepath)
            if removed > 0:
                total_removed += removed

print(f"Total pure timer lines removed: {total_removed}")
