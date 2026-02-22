On Error Resume Next
Set conn = CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicWords.mdb"

conn.Execute "UPDATE lists SET creator = 1"
If Err.Number <> 0 Then
    WScript.Echo "Error updating creator in lists: " & Err.Description
    Err.Clear
Else
    WScript.Echo "Successfully updated creator in lists."
End If

conn.Execute "UPDATE listsUsers SET [user] = 1"
If Err.Number <> 0 Then
    conn.Execute "UPDATE listsUsers SET userID = 1"
    Err.Clear
End If
WScript.Echo "Successfully updated user in listsUsers."

conn.Close
