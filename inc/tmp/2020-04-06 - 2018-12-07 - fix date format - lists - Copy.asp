<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"

'DISABLED BOTH HERE AND AT THE END'
response.end
'DISABLED' %>



<!DOCTYPE html>
<html>
<head>
	<title>CHANGE STRING DATE FORMAT FROM DD/MM/YYYY.. to YYYY-MM-DD...</title>
    <meta name="robots" content="none">
</head>
<body>
<div class="view" dir="ltr"><%

dim newCTime,newETime

openDB "arabicWords"

mySQL = "SELECT * FROM lists"
res.open mySQL, con
	do until res.EOF
	response.write inStr(res("creationTIME"),"/")
		if inStr(res("creationTIME"),"/")>0 then
			newCTime = dateToStr(res("creationTIME"))
		else
			newCTime = res("creationTIME")
		end if
		if inStr(res("lastUpdate"),"/")>0 then
			newETime = dateToStr(res("lastUpdate"))
		else
			newETime = res("lastUpdate")
		end if
		mySQL = "UPDATE lists SET creationTIME='"&newCTime&"', lastUpdate='"&newETime&"' WHERE ID="&res("ID")
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Response.Write "<div style='font-size:small;'>"&mySQL&"</div>"
		'DISABLED
		Response.End
		set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.moveNext
	loop
res.close


response.write "<br/><br/>THE END"
'response.end
closeDB
%>
</div>
</body>