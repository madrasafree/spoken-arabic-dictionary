import win32com.client

try:
    conn = win32com.client.Dispatch("ADODB.Connection")
    try:
        conn.Open(
            r"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"
        )
    except:
        conn.Open(
            r"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"
        )

    try:
        conn.Execute("DROP TABLE users_demo")
    except:
        pass

    conn.Execute("SELECT * INTO [users_demo] FROM [users] WHERE 1=0")

    conn.Execute(
        "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'מנהל מערכת','admin@example.com','מנהל גנרי','admin','admin',15,1)"
    )
    conn.Execute(
        "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'עורך מילים','editor@example.com','עורך גנרי','editor','editor',3,1)"
    )
    conn.Execute(
        "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'בקר מילים','reviewer@example.com','בקר גנרי','reviewer','reviewer',5,1)"
    )

    print("SUCCESS")
except Exception as e:
    print(f"ERROR: {e}")
