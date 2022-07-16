﻿<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"

'DISABLED'
response.end
'DISABLED' %>



<!DOCTYPE html>
<html>
<head>
	<title>FIX GERESH (2018-04-07)</title>
    <meta name="robots" content="none">
    <meta charset="UTF-8">
</head>
<body>
<div class="view" dir="ltr"><%
dim heb,hebClean,arb,arbClean,taatik,taatikClean

response.write "<br/>CLEAN HEBREW"
response.write "<br/>CLEAN ARABIC"
response.write "<br/>CLEAN TAATIK"
'response.end

Function onlyLetters(str)
    Dim regEx,ltrs,i,crnt
    Set regEx = New RegExp
    regEx.Pattern = "[^\א-ת,ؠ-يٱ-ٳٶ-ە'`׳‘’]"
    regEx.Global = True
    ltrs = regEx.Replace(str, "")
    for i=1 to len(ltrs)
    	crnt = Mid(ltrs,i,1)
    	SELECT CASE crnt
    		case "`","׳","‘","’","'"
    			onlyLetters = onlyLetters + "'"
    		case else
    			onlyLetters = onlyLetters + crnt
		END SELECT
	next
End Function

Function gettString (f)
    gettString = replace(f,"'","''")
End function 

openDB "arabicWords"
mySQL = "SELECT * FROM words WHERE id=4411"
res.open mySQL, con 
	do until res.EOF
		response.write "<br/>hebrewTranslation = "&res("hebrewTranslation")
		hebClean = gettString(onlyLetters(res("hebrewTranslation")))
		response.write "<br/>hebClean = " + hebClean
		response.write "<br/>arabic = "&res("arabic")
		if len(res("arabic"))>0 then 
			arbClean = gettString(onlyLetters(res("arabic")))
		else
			arbClean = ""
		end if
		response.write "<br/>arbClean = " + arbClean
		response.write "<br/>arabicWord = "&res("arabicWord")
		taatikClean = gettString(onlyLetters(res("arabicWord")))
		response.write "<br/>taatikClean = " + taatikClean
		'response.end

		mySQL = "UPDATE words SET hebrewClean='"+ hebClean + "',arabicClean='"+ arbClean +"', arabicHebClean='"+ taatikClean +"' WHERE id="&res("id")
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Response.Write "<br/>"&mySQL
		Response.End
		set cmd.ActiveConnection=con
		cmd.execute ,,128

		res.moveNext
	loop
res.close

response.write "<br/>ALL DONE!! :)"
response.end
closeDB
%>
</div>
</body>