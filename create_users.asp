<%@Language="VBScript"%>
<%
On Error Resume Next
Response.Write "Starting...<br>"
Set conn = Server.CreateObject("ADODB.Connection")
dataSource = Server.MapPath("App_Data/arabicUsers.mdb")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dataSource

If Err.Number <> 0 Then
    Response.Write "Connection Error: " & Err.Description & "<br>"
    Response.End
End If

conn.Execute "DROP TABLE users_demo"
Err.Clear

conn.Execute "SELECT * INTO [users_demo] FROM [users] WHERE 1=0"
If Err.Number <> 0 Then
    Response.Write "Error creating table: " & Err.Description & "<br>"
    Response.End
End If

insertAdmin = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'מנהל מערכת','admin@example.com','מנהל גנרי','admin','admin',15,1)"
insertEditor = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'עורך מילים','editor@example.com','עורך גנרי','editor','editor',3,1)"
insertReviewer = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'בקר מילים','reviewer@example.com','בקר גנרי','reviewer','reviewer',5,1)"

conn.Execute insertAdmin
conn.Execute insertEditor
conn.Execute insertReviewer

Response.Write "Created users_demo table with 3 generic users successfully!<br>"
conn.Close
%>
