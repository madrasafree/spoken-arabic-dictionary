import win32com.client

try:
    conn = win32com.client.Dispatch("ADODB.Connection")
    conn.Open(
        r"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"
    )

    rs = conn.Execute("SELECT id, username FROM users")
    while not rs[0].EOF:
        print(
            f"ID: {rs[0].Fields('id').Value}, Username: {rs[0].Fields('username').Value}"
        )
        rs[0].MoveNext()

    conn.Close()
except Exception as e:
    print(f"ERROR: {e}")
