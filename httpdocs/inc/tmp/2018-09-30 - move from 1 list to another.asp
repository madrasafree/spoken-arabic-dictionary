<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"

'DISABLED'
response.end
'DISABLED' %>



<!DOCTYPE html>
<html>
<head>
	<title>MOVE FROM 1 LIST TO ANOTHER</title>
    <meta name="robots" content="none">
</head>
<body>
<div class="view" dir="ltr"><%
dim geresh, newFIX
geresh = "&#39;"
response.write "<br/>MOVE FROM LIST 92 TO LIST 91"
response.write "<br/><br/>WORDS:"
'response.end
openDB "arabicWords"

mySQL = "SELECT * FROM wordsLists WHERE listID=92"
res.open mySQL, con
	do until res.EOF
		'response.write "<br/>"&res(0)
		mySQL = "UPDATE wordsLists SET listID=91 WHERE listID=92"
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Response.Write mySQL
		'Response.End
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