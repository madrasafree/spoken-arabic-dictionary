<!--#include file="inc/inc.asp"--><%
'IMPORTANT : this is a one time fix - DO NOT use it again!

'Goal: is to change creationDate from date format to string
'Reason: day and month get mixed up because of usa/israel date formats

If session("role") <> 15 then Response.Redirect "login.asp"
response.write "ONE TIME FIX - DO NOT RE-USE!"
response.end%>
<!DOCTYPE html>
<html>
<head>
	<title>TIME FIX</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"-->
<div class="view" dir="ltr"><%
dim newStrDate
response.write "<br/>TIME FIX"
response.write "<br/><br/>WORDS:"

'response.end

openDB "arabicWords"

mySQL = "SELECT creationDate,creationTime,ID FROM words"
res.open mySQL, con
if res.EOF then response.write "<br/>res.EOF"
while not res.EOF
	response.write "<br/>creationDate = "& res("creationDate")
	newStrDate = dateToStr(res("creationDate"))
	response.write " >> creationTime = "& newStrDate
	mySQL = "UPDATE words SET creationTime = '"&newStrDate&"' WHERE ID="&res("ID")
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

response.write "<br/><br/>THE END"
'response.end
closeDB
%>
</div>
</body>