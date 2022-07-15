<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"
'DISABLED'
'response.end
'DISABLED' 



'FIND DUPLICS'
'DELETE THEM'

%>



<!DOCTYPE html>
<html>
<head>
	<title>GERESH and GERSHAIM FIX (2018-04-23)</title>
    <meta name="robots" content="none">
    <meta charset="UTF-8">
</head>
<body>
<div class="view" dir="ltr"><%
dim oldStr,newStr





'response.end

dim cntr, skip, prevTyped, prevID, prevCnt, newCnt, ids, psik
cntr = 0
prevTyped = ""
'skip = true
'psik = ""
prevID = ""
prevCnt = ""

response.write "<h1>HEY</h1><table>"
openDB "arabicSearch"
mySQL = "SELECT * FROM wordsSearched ORDER BY typed"
'mySQL = "SELECT * FROM wordsSearched"
res.open mySQL, con
	do until res.EOF
		if res("typed") = prevTyped then
			cntr = cntr + 1
			newCnt = res("searchCount") + prevCnt
			response.write "<tr><td>"&res("id")&"</td><td>"&res("typed")&_
			"</td><td>"&res("searchCount")&"</td><td> + </td><td>"&prevCnt&"</td><td> = </td><td>"&newCnt&"</td>"

			mySQL = "UPDATE wordsSearched SET searchCount="&newCnt&" WHERE id="&res("id")
			response.write "<td>"&mySQL&"</td>"
			cmd.CommandType=1
			cmd.CommandText=mySQL
			set cmd.ActiveConnection=con
			cmd.execute ,,128


			mySQL = "DELETE FROM wordsSearched WHERE id="&prevID
			response.write "<td>"&mySQL&"</td></tr>"
			cmd.CommandType=1
			cmd.CommandText=mySQL
			set cmd.ActiveConnection=con
			cmd.execute ,,128


			'ids = ids & psik & prevID
			'psik = ","
		end if
		prevTyped = res("typed")
		prevID = res("id")
		prevCnt = res("searchCount")
		res.moveNext
	loop
response.write "</table><h2>YOU</h2>"
response.write "<br/>counter = "& cntr
'response.write "<br/>ids (for delete) = "& ids
'response.end


response.write "<br/>ALL DONE!! :)"
response.end
closeDB
%>
</div>
</body>