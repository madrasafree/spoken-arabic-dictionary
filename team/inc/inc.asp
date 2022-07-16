<%@ Language="VBScript" CodePage="65001" LCID="1037" %>
<%
Option Explicit
dim res, res2, res3, con, mySQL, cmd
dim startTime, endTime, durationMs, userIP, opTime 'logger
dim baseA, baseT

'baseA = "http://ronen.rothfarb.info/arabic/"
'baseA = "http://10.0.0.3:8080/" 'pcWhite'
'baseA = "http://127.0.0.1:8080/" 'Lenovo x220'
baseA = "../" 'test to remove bases'
baseT = baseA + "team/"

function intToStr (num, length)
	'NUM to STRING
	'Add 0 before single characters
	'info: helps keep date in ISO8601 format [yyyy-mm-ddThh:mm:ssZ]

    dim x
    x = right(string(length,"0") + cStr(num),length)
    intToStr = x
end function

function AR2UTC (date)
	'Recive date from server (in Arizona time - UTC-7)
	'Use intToStr function to Format date as STRING acording to ISO8601 + UTC : YYYY-MM-DDTHH:MM:SSZ
	dim y,u
	u = DateAdd("h",7,date) 'add 7 hours (diff between Arizona Server and UTC)
	y = year(u)&"-"&intToStr(month(u),2)&"-"&intToStr(day(u),2)&"T"&intToStr(hour(u),2)&":"&intToStr(minute(u),2)&":"&intToStr(second(u),2)&"Z"
	AR2UTC = y
end function

sub OpenDbLogger(db,opType,afPage,opNum,sStr)
	userIP = Request.Servervariables("REMOTE_HOST")
	opTime = AR2UTC(now())
	OpenDB(db)
	'mySQL = "INSERT INTO log (opType,afDB,afPage,opNum,userIP,opTimestamp,sStr) VALUES ('"&opType&"','"&db&"','"&afPage&"','"&opNum&"','"&userIP&"','"&opTime&"','"&sStr&"')"
	'con.execute mySQL
end sub

sub CloseDbLogger(db,opType,afPage,opNum,durationMs,sStr)
	userIP = Request.Servervariables("REMOTE_HOST")
	opTime = AR2UTC(now())
	'mySQL = "INSERT INTO log (opType,afDB,afPage,opNum,userIP,opTimestamp,durationMs,sStr) VALUES ("&_
	'"'"&opType&"','"&db&"','"&afPage&"','"&opNum&"','"&userIP&"','"&opTime&"','"&durationMs&"','"&sStr&"')"
	'con.execute mySQL
  closeDb
end sub


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