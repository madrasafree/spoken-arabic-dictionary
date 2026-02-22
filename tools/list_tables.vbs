Set conn = CreateObject("ADODB.Connection")
dataSource = "c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dataSource

Set fso = CreateObject("Scripting.FileSystemObject")
Set outFile = fso.CreateTextFile("c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\tools\tables_out.txt", True)

Set rs = conn.OpenSchema(20)
Do Until rs.EOF
    If rs("TABLE_TYPE") = "TABLE" Then
        outFile.WriteLine rs("TABLE_NAME")
    End If
    rs.MoveNext
Loop

outFile.Close
conn.Close
