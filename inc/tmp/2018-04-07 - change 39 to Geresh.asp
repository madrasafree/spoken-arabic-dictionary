<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"

'DISABLED'
response.end
'DISABLED' %>

<!DOCTYPE html>
<html>
<head>
	<title>REMOVE NIKUD - update: REPLACE &#39; to GERESH (2018-04-07)</title>
    <meta name="robots" content="none">
    <meta charset="UTF-8">
    <script src="inc/functions/soundex.js"></script>
</head>
<body>
<div class="view" dir="rtl"><%
dim hebOld,hebNew,arbOld,arbNew

response.write "<br/>SEARCH FOR ALL GERESH IN DB"
response.write "<br/>REPLACE WITH GERESH (regular one, not the &#39;)"

Function gereshIT (f)
    gereshIT = replace(f,"&#39;","'")
End function 

Function getString (f)
	getString = "'" &replace(f,"'","''")&"'"
End function 

openDB "arabicWords"
mySQL = "SELECT * FROM words"
res.open mySQL, con 
	do until res.EOF

		hebNew = getString(gereshIT(res("hebrewTranslation")))
		arbNew = getString(gereshIT(res("arabicWord")))

		mySQL = "UPDATE words SET hebrewTranslation="& hebNew &", arabicWord="& arbNew &" WHERE id="&res("id")
		cmd.CommandType=1
		cmd.CommandText=mySQL
		set cmd.ActiveConnection=con
		cmd.execute ,,128

		res.moveNext
	loop
res.close

response.write "<br/>ALL DONE!! :)"
closeDB %>
</div>
</body>