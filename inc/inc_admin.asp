<%@ Language="VBScript" CodePage="65001" LCID="1037" %>
<%
Option Explicit
dim res, res2, res3, con, mySQL, cmd, baseA, baseT, baseM

'baseA = "http://ronen.rothfarb.info/arabic/"
'baseA = "http://10.0.0.3:8080/" 'pcWhite'
baseA = "http://127.0.0.1:8080/" 'Lenovo x220'
baseT = "http://127.0.0.1/" 'Lenovo x220'
baseM = "http://127.0.0.1:4000/" 'Lenovo x220'


sub OpenDB(db)
	set con = Server.CreateObject("adodb.connection")
	set res = Server.CreateObject("adodb.recordset")
	set res2 = Server.CreateObject("adodb.recordset")
	set res3 = Server.CreateObject("adodb.recordset")
	set cmd = Server.CreateObject("adodb.command")
	con.provider = "microsoft.jet.oledb.4.0"
	con.Open Server.MapPath("App_Data/"&db&".mdb")
end sub

sub closeDB
	set res = nothing
	set res2 = nothing
	set res3 = nothing
	set con = nothing
end sub

Sub Go(url)
	If con.State=1 Then	con.Close
	CloseDB
	Response.Redirect url
End Sub %>