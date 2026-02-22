On Error Resume Next
Set conn = CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"

Set rs = conn.Execute("SELECT id, username FROM users")
Do Until rs.EOF
    WScript.Echo "ID: " & rs("id") & " Username: " & rs("username")
    rs.MoveNext
Loop
conn.Close
