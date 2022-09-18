<%@ Language="VBScript" CodePage="65001" LCID="1037" %>
<%
Option Explicit
dim res, res2, con, mySQL, cmd
dim baseA, baseT

baseA = "https://milon.madrasafree.com/" 'online'
'baseA = "http://127.0.0.1:8080/" 'local'
baseT = baseA + "Team/" 'online'


sub OpenDB(db)
	set con = Server.CreateObject("adodb.connection")
	set res = Server.CreateObject("adodb.recordset")
	set res2 = Server.CreateObject("adodb.recordset")
	set cmd = Server.CreateObject("adodb.command")
	con.provider = "microsoft.jet.oledb.4.0"
	con.Open Server.MapPath("App_Data/"&db&".mdb")
end sub

sub closeDB
	set res = nothing
	set res2 = nothing
	set con = nothing
end sub

Sub Go(url)
	If con.State=1 Then	con.Close
	CloseDB
	Response.Redirect url
End Sub %>
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->