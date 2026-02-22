On Error Resume Next
Set cat = CreateObject("ADOX.Catalog")
cat.ActiveConnection = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"

If Err.Number <> 0 Then
    WScript.Echo "Connection Error: " & Err.Description
    WScript.Quit 1
End If

cat.Tables.Delete "users_orig"
Err.Clear

cat.Tables("users").Name = "users_orig"
If Err.Number <> 0 Then
    WScript.Echo "Error renaming users to users_orig: " & Err.Description
    WScript.Quit 1
End If

cat.Tables("users_demo").Name = "users"
If Err.Number <> 0 Then
    WScript.Echo "Error renaming users_demo to users: " & Err.Description
    WScript.Quit 1
End If

WScript.Echo "Successfully replaced users table with the demo table."
