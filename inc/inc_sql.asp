<%@ Language="VBScript" CodePage="65001" LCID="1037" %>
<%
Option Explicit
dim res, res2, res3, conSql, mySQL, cmd
dim baseA, baseT

'baseA = "https://milon.madrasafree.com/"
'baseA = "127.0.0.1:8080/"
baseA = ""
baseT = baseA + "/team/"

sub OpenSqlDb(db)
	set conSql = Server.CreateObject("adodb.connection")
	set res = Server.CreateObject("adodb.recordset")
	set res2 = Server.CreateObject("adodb.recordset")
	set res3 = Server.CreateObject("adodb.recordset")
 	set cmd = Server.CreateObject("adodb.command")
	conSql.ConnectionString = "Provider=SQLNCLI11;" _  
					& "Server=(local);" _  
					& "Database="&db&";" _   
					& "Integrated Security=SSPI;" _  
					& "DataTypeCompatibility=80;" _  
					& "MARS Connection=True;"
	conSql.open
end sub

' sub OpenDB(db)
' 	set conSql = Server.CreateObject("adodb.connection")
' 	set res = Server.CreateObject("adodb.recordset")
' 	set res2 = Server.CreateObject("adodb.recordset")
' 	set res3 = Server.CreateObject("adodb.recordset")
' 	set cmd = Server.CreateObject("adodb.command")
' 	conSql.provider = "microsoft.jet.oledb.4.0"
' 	conSql.Open Server.MapPath("App_Data/"&db&".mdb")
' end sub

sub closeDB
	set res = nothing
	set res2 = nothing
	set res3 = nothing
	set conSql = nothing
end sub

Sub Go(url)
	If conSql.State=1 Then	conSql.Close
	CloseDB
	Response.Redirect url
End Sub %>
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->