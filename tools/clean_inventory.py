import csv
import os

filepath = "docs/file-inventory.csv"
lines = []
deleted = 0

with open(filepath, "r", encoding="utf-8") as f:
    reader = csv.reader(f)
    header = next(reader)
    lines.append(header)
    for row in reader:
        if not row:
            continue
        path = row[0]
        # Keep directories or existing files or specifically required files
        if (
            path.endswith("/")
            or os.path.exists(path)
            or path
            in (
                "README.md",
                "robots.txt",
                "web.config",
                "web.config.local",
                "web.config.prod",
                "",
            )
        ):
            lines.append(row)
        else:
            print(f"Removing: {path}")
            deleted += 1

with open(filepath, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerows(lines)

print(f"Deleted {deleted} entries from file-inventory.csv.")
