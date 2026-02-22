import win32com.client
import os
import re

app_data = r"c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data"

dbs_files = [
    "arabicLogs.mdb",
    "arabicManager.mdb",
    "arabicSearch.mdb",
    "arabicUsers.mdb",
    "arabicWords.mdb",
]

date_col_patterns = ["time", "date", "utc", "action", "creation"]

results = []

for db_file in dbs_files:
    db_path = os.path.join(app_data, db_file)
    if not os.path.exists(db_path):
        continue

    try:
        conn = win32com.client.Dispatch("ADODB.Connection")
        conn.Open(f"Provider=Microsoft.Jet.OLEDB.4.0;Data Source={db_path}")

        # Get all tables
        rs_schema = conn.OpenSchema(20)  # adSchemaTables = 20
        tables = []
        while not rs_schema.EOF:
            if rs_schema.Fields.Item("TABLE_TYPE").Value == "TABLE":
                tables.append(rs_schema.Fields.Item("TABLE_NAME").Value)
            rs_schema.MoveNext()

        for table in tables:
            most_recent_val = "Empty or Error"

            try:
                # Find date or id column
                rs = conn.Execute(f"SELECT TOP 1 * FROM [{table}]")
                date_col = None
                id_col = None
                for i in range(rs[0].Fields.Count):
                    col_name = rs[0].Fields.Item(i).Name
                    col_name_lower = col_name.lower()
                    if any(p in col_name_lower for p in date_col_patterns):
                        date_col = col_name
                        break
                    if col_name_lower == "id" or col_name_lower.endswith("id"):
                        id_col = col_name

                sort_col = date_col if date_col else id_col

                if sort_col:
                    rs_val = conn.Execute(
                        f"SELECT TOP 1 [{sort_col}] FROM [{table}] ORDER BY [{sort_col}] DESC"
                    )
                    if not rs_val[0].EOF:
                        most_recent_val = (
                            f"{sort_col}: {rs_val[0].Fields.Item(0).Value}"
                        )
                    else:
                        most_recent_val = "Table is empty"
                else:
                    most_recent_val = "No ID or Date column found to sort"
            except Exception as e:
                most_recent_val = f"Err: {e}"

            results.append(f"{db_file} -> {table}: {most_recent_val}")

        conn.Close()
    except Exception as e:
        results.append(f"Could not open {db_file}: {e}")

print("=== RECENT ACTIVITY CHECK ===")
for r in results:
    print(r)
