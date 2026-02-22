Option Explicit

Dim fso, conn, connStr, dbFile
Dim dbs, db

Set fso = CreateObject("Scripting.FileSystemObject")

' List of databases to drop the 'log' table from
dbs = Array("arabicWords", "arabicUsers", "arabicSearch", "arabicManager", "arabicSandbox")

For Each db In dbs
    dbFile = fso.GetAbsolutePathName("App_Data\" & db & ".mdb")
    
    If fso.FileExists(dbFile) Then
        WScript.Echo "Connecting to " & dbFile & "..."
        connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbFile & ";"
        
        Set conn = CreateObject("ADODB.Connection")
        On Error Resume Next
        conn.Open connStr
        
        If Err.Number <> 0 Then
            WScript.Echo "  Failed to open: " & Err.Description
            Err.Clear
        Else
            ' Attempt to drop the table
            conn.Execute "DROP TABLE log"
            If Err.Number <> 0 Then
                WScript.Echo "  Skipped/Failed dropping 'log': " & Err.Description
                Err.Clear
            Else
                WScript.Echo "  Successfully dropped table 'log'."
            End If
            conn.Close
        End If
        On Error GoTo 0
        Set conn = Nothing
    Else
        WScript.Echo "Database not found: " & dbFile
    End If
Next

WScript.Echo "Done."
