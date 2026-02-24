import os
import glob
import re

admin_files = [
    "admin.allowEditToggle.asp",
    "admin.asp",
    "admin.labelControl.asp",
    "admin.labelNew.insert.asp",
    "admin.locked.asp",
    "admin.readOnlyToggle.asp",
    "admin.userControl.asp",
    "admin.userControl.full.asp",
    "admin.userEdit.asp",
    "admin.userEdit.update.asp",
    "admin.userNew.asp",
    "admin.userNew.insert.asp",
    "admin.wordsShort.asp",
]

os.makedirs("admin", exist_ok=True)

# 1. Process files going inside admin/
for base_file in admin_files:
    if not os.path.exists(base_file):
        continue

    with open(base_file, "r", encoding="utf-8") as f:
        content = f.read()

    # includes/ -> ../includes/
    content = content.replace('"includes/inc.asp"', '"../includes/inc.asp"')
    # assets/ -> ../assets/
    content = content.replace('"assets/', '"../assets/')

    # login.asp and index.asp
    for link in ["login.asp", "index.asp"]:
        content = re.sub(rf"\"{link}\"", f'"../{link}"', content)
        content = re.sub(rf"href=\s*\"{link}\"", f'href="../{link}"', content)
        content = re.sub(
            rf"Response\.Redirect\s+\"{link}\"",
            f'Response.Redirect "../{link}"',
            content,
        )

    # other links backwards
    for root_link in [
        "word.edit.asp",
        "word.asp",
        "words.asp",
        "sentence.asp",
        "sentences.asp",
        "label.asp",
        "labels.asp",
        "dashboard.asp",
        "tools/",
        "team/",
        "profile.asp",
    ]:
        content = content.replace(f'"{root_link}"', f'"../{root_link}"')
        content = content.replace(
            f"={root_link}", f"=../{root_link}"
        )  # e.g. action=word.edit.update.asp

    # internal links rename
    content = content.replace("admin.asp", "index.asp")
    content = content.replace("admin.userControl.asp", "userControl.asp")
    content = content.replace("admin.userControl.full.asp", "userControl.full.asp")
    content = content.replace("admin.userEdit.asp", "userEdit.asp")
    content = content.replace("admin.userEdit.update.asp", "userEdit.update.asp")
    content = content.replace("admin.userNew.asp", "userNew.asp")
    content = content.replace("admin.userNew.insert.asp", "userNew.insert.asp")
    content = content.replace("admin.wordsShort.asp", "wordsShort.asp")
    content = content.replace("admin.readOnlyToggle.asp", "readOnlyToggle.asp")
    content = content.replace("admin.locked.asp", "locked.asp")
    content = content.replace("admin.allowEditToggle.asp", "allowEditToggle.asp")
    content = content.replace("admin.labelControl.asp", "labelControl.asp")
    content = content.replace("admin.labelNew.insert.asp", "labelNew.insert.asp")

    new_file_name = base_file.replace("admin.", "")
    if new_file_name == "asp":
        new_file_name = "index.asp"

    new_path = os.path.join("admin", new_file_name)
    with open(new_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Moved and updated {base_file} to {new_path}")

    # Create root proxy redirect
    redirect_code = f"""<%@ Language=VBScript %>
<%
Dim qs
qs = Request.ServerVariables("QUERY_STRING")
If qs <> "" Then
    qs = "?" & qs
End If
Response.Status="301 Moved Permanently"
Response.AddHeader "Location", "admin/{new_file_name}" & qs
Response.End
%>"""
    with open(base_file, "w", encoding="utf-8") as f:
        f.write(redirect_code)


# 2. Update OTHER files in the root folder that point to admin.*.asp
# we must replace "admin.asp" -> "admin/" etc.
all_other_asp = [f for f in glob.glob("*.asp") if f not in admin_files]
# and in team folder
all_other_asp += glob.glob("team/*.asp")

for f in all_other_asp:
    with open(f, "r", encoding="utf-8") as file:
        content = file.read()

    original_content = content
    content = content.replace("admin.asp", "admin/")
    content = content.replace("admin.userControl.asp", "admin/userControl.asp")
    content = content.replace(
        "admin.userControl.full.asp", "admin/userControl.full.asp"
    )
    content = content.replace("admin.userEdit.asp", "admin/userEdit.asp")
    content = content.replace("admin.userEdit.update.asp", "admin/userEdit.update.asp")
    content = content.replace("admin.userNew.asp", "admin/userNew.asp")
    content = content.replace("admin.userNew.insert.asp", "admin/userNew.insert.asp")
    content = content.replace("admin.wordsShort.asp", "admin/wordsShort.asp")
    content = content.replace("admin.readOnlyToggle.asp", "admin/readOnlyToggle.asp")
    content = content.replace("admin.locked.asp", "admin/locked.asp")
    content = content.replace("admin.allowEditToggle.asp", "admin/allowEditToggle.asp")
    content = content.replace("admin.labelControl.asp", "admin/labelControl.asp")
    content = content.replace("admin.labelNew.insert.asp", "admin/labelNew.insert.asp")

    if content != original_content:
        with open(f, "w", encoding="utf-8") as file:
            file.write(content)
        print(f"Updated internal links in {f}")

print("Migration script completed correctly.")
