<%@ Language=VBScript %>
<%
Dim qs
qs = Request.ServerVariables("QUERY_STRING")
If qs <> "" Then
    qs = "?" & qs
End If
Response.Status="301 Moved Permanently"
Response.AddHeader "Location", "admin/userNew.asp" & qs
Response.End
%>