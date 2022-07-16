<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"

'DISABLED BOTH HERE AND AT THE END'
'RESPONSE.END
'DISABLED' %>



<!DOCTYPE html>
<html>
<head>
	<title>CHANGE FROM DATE TO STRING WITH ISO8601 FORMAT</title>
    <META NAME="ROBOTS" CONTENT="NONE">
</head>
<body>
<div class="view" dir="ltr"><%

dim joinDate,joinDateUTC

openDB "arabicUsers"

mySQL = "SELECT * FROM users WHERE id>1"
res.open mySQL, con
	do until res.EOF
		if len(res("joinDateUTC"))>0 then
			response.write res("ID")&" skipped ; "
		else
			if len(res("joinDate"))>0 then
				response.write res("ID")&" v ; "
				joinDateUTC = dateToStrISO8601(res("joinDate"))
				mySQL = "UPDATE users SET joinDateUTC='"&joinDateUTC&"' WHERE ID="&res("ID")
				cmd.CommandType=1
				cmd.CommandText=mySQL
				'Response.Write "<div style='font-size:small;'>"&mySQL&"</div>"
				'DISABLED
				'Response.End
				set cmd.ActiveConnection=con
				cmd.execute ,,128
			end if
		end if
	res.moveNext
	loop
res.close


response.write "<br/><br/>THE END"
'response.end
closeDB
%>
</div>
</body>