On Error Resume Next
Set conn = CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicWords.mdb"

WScript.Echo "--- lists ---"
Set rs = conn.Execute("SELECT TOP 5 id, creator FROM lists")
Do Until rs.EOF
    WScript.Echo "list_id: " & rs("id") & " creator: " & rs("creator")
    rs.MoveNext
Loop

WScript.Echo "--- listsUsers ---"
Set rs = conn.Execute("SELECT TOP 5 list, userID FROM listsUsers")
Do Until rs.EOF
    WScript.Echo "list: " & rs("list") & " userID: " & rs("userID")
    rs.MoveNext
Loop

conn.Close
