On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
appData = "c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data"

Dim dbs(4)
dbs(0) = "arabicLogs.mdb"
dbs(1) = "arabicManager.mdb"
dbs(2) = "arabicSearch.mdb"
dbs(3) = "arabicUsers.mdb"
dbs(4) = "arabicWords.mdb"

WScript.Echo "=== RECENT ACTIVITY CHECK ==="

For Each db In dbs
    dbPath = appData & "\" & db
    If fso.FileExists(dbPath) Then
        Set conn = CreateObject("ADODB.Connection")
        conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbPath
        
        If Err.Number <> 0 Then
            WScript.Echo "Could not open " & db & ": " & Err.Description
            Err.Clear
        Else
            Set rsSchema = conn.OpenSchema(20) ' adSchemaTables = 20
            Do Until rsSchema.EOF
                If rsSchema("TABLE_TYPE") = "TABLE" Then
                    tableName = rsSchema("TABLE_NAME")
                    
                    ' Find a date or id column
                    Set rsTop = conn.Execute("SELECT TOP 1 * FROM [" & tableName & "]")
                    dateCol = ""
                    idCol = ""
                    
                    If Not rsTop.EOF Then
                        For i = 0 To rsTop.Fields.Count - 1
                            colName = rsTop.Fields(i).Name
                            colNameLower = LCase(colName)
                            
                            If InStr(colNameLower, "time") > 0 Or InStr(colNameLower, "date") > 0 Or InStr(colNameLower, "utc") > 0 Or InStr(colNameLower, "action") > 0 Or InStr(colNameLower, "creation") > 0 Then
                                dateCol = colName
                                Exit For
                            End If
                            
                            If colNameLower = "id" Or Right(colNameLower, 2) = "id" Then
                                idCol = colName
                            End If
                        Next
                        
                        sortCol = ""
                        If dateCol <> "" Then 
                            sortCol = dateCol 
                        ElseIf idCol <> "" Then 
                            sortCol = idCol 
                        End If
                        
                        If sortCol <> "" Then
                            Set rsVal = conn.Execute("SELECT TOP 1 [" & sortCol & "] FROM [" & tableName & "] ORDER BY [" & sortCol & "] DESC")
                            If Not rsVal.EOF Then
                                WScript.Echo db & " -> " & tableName & ": " & sortCol & " = " & rsVal(0).Value
                            Else
                                WScript.Echo db & " -> " & tableName & ": Table is empty"
                            End If
                        Else
                            WScript.Echo db & " -> " & tableName & ": No ID or Date column found to sort"
                        End If
                    Else
                        WScript.Echo db & " -> " & tableName & ": Table is empty"
                    End If
                End If
                rsSchema.MoveNext
            Loop
            conn.Close
        End If
    End If
Next
