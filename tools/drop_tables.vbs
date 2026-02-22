Option Explicit

Dim conn, dbPath
Dim projectDir

projectDir = "c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\"

Sub DropTableIfExist(dbName, tableName)
    dbPath = projectDir & dbName
    WScript.Echo "Opening DB: " & dbName
    
    Set conn = CreateObject("ADODB.Connection")
    conn.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbPath
    
    On Error Resume Next
    conn.Open
    If Err.Number <> 0 Then
        WScript.Echo "  Error opening DB: " & Err.Description
        Err.Clear
    Else
        conn.Execute "DROP TABLE [" & tableName & "]"
        If Err.Number <> 0 Then
            WScript.Echo "  Error dropping table " & tableName & ": " & Err.Description
            Err.Clear
        Else
            WScript.Echo "  Successfully dropped table " & tableName
        End If
        conn.Close
    End If
    On Error GoTo 0
    Set conn = Nothing
End Sub

DropTableIfExist "arabicLogs.mdb", "durations"
DropTableIfExist "arabicManager.mdb", "goals"
DropTableIfExist "arabicManager.mdb", "projects"
DropTableIfExist "arabicSandbox.mdb", "timez"
DropTableIfExist "arabicUsers.mdb", "usersWordsFollow"

WScript.Echo "Done!"
