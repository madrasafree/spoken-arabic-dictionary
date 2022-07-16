<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"
response.end %>
<!DOCTYPE html>
<html>
<head>
	<title>FIX</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body>
<div class="view" dir="ltr"><%
dim geresh, newFIX
geresh = "&#39;"
response.write "<br/>GERESH FIX"
response.write "<br/><br/>WORDS:"
'response.end
openDB "arabicWords"

mySQL = "SELECT arabicWord,ID FROM words WHERE arabicWord LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>arabicWord FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE words SET arabicWord = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT hebrewTranslation,ID FROM words WHERE hebrewTranslation LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>hebrewTranslation FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE words SET hebrewTranslation = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT pronunciation,ID FROM words WHERE pronunciation LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>pronunciation FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE words SET pronunciation = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT searchString,ID FROM words WHERE searchString LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>searchString FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE words SET searchString = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT info,ID FROM words WHERE info LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>info FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE words SET info = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT example,ID FROM words WHERE example LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>example FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE words SET example = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

response.write "<br/><br/>HISTORY"

mySQL = "SELECT explain,ID FROM history WHERE explain LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>explain FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET explain = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT hebrewOld,ID FROM history WHERE hebrewOld LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>hebrewOld FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET hebrewOld = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT hebrewNew,ID FROM history WHERE hebrewNew LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>hebrewNew FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET hebrewNew = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT arabicOld,ID FROM history WHERE arabicOld LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>arabicOld FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET arabicOld = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT arabicNew,ID FROM history WHERE arabicNew LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>arabicNew FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET arabicNew = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT pronunciationOld,ID FROM history WHERE pronunciationOld LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>pronunciationOld FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET pronunciationOld = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT pronunciationNew,ID FROM history WHERE pronunciationNew LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>pronunciationNew FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET pronunciationNew = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT searchStringOld,ID FROM history WHERE searchStringOld LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>searchStringOld FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET searchStringOld = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT searchStringNew,ID FROM history WHERE searchStringNew LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>searchStringNew FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET searchStringNew = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT infoOld,ID FROM history WHERE infoOld LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>infoOld FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET infoOld = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT infoNew,ID FROM history WHERE infoNew LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>infoNew FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET infoNew = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT exampleOld,ID FROM history WHERE exampleOld LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>exampleOld FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET exampleOld = '"&newFIX&"' WHERE ID="&res(1)
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	res.movenext
wend
res.close

mySQL = "SELECT exampleNew,ID FROM history WHERE exampleNew LIKE ""%"&geresh&"%"""
res.open mySQL, con
if res.EOF then response.write "<br/>exampleNew FIXED"
while not res.EOF
	response.write "<br/> "& res(0)
	newFIX = replace(res(0),geresh,"''")
	mySQL = "UPDATE history SET exampleNew = '"&newFIX&"' WHERE ID="&res(1)
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