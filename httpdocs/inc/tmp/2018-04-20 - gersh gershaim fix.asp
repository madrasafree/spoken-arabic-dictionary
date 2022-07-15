<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"
'DISABLED'
response.end
'DISABLED' 



'GO THROUGH ENTIRE DATABASE, AND REPLACE VARIOUS GERESH & GERSHAIM TO HEBREW ONES'

%>



<!DOCTYPE html>
<html>
<head>
	<title>UPDATE GERESH and GERSHAIM (2018-04-20)</title>
    <meta name="robots" content="none">
    <meta charset="UTF-8">
</head>
<body>
<div class="view" dir="ltr"><%
dim oldStr,newStr


function gereshFix(str)
    dim i,crnt
    for i=1 to len(str)
        crnt = Mid(str,i,1)
        SELECT CASE crnt
            case "'","`","‘","’","‚","′","‵","＇"
                gereshFix = gereshFix + "׳"
            case """","“","”","„","‟","″"
                gereshFix = gereshFix + "״"
            case else
                gereshFix = gereshFix + crnt
        END SELECT
    next
end function

function intToStr (num, length)
	'NUM to STRING
	'Add 0 before single characters
	'info: helps keep date in one format [yyyy-mm-dd hh:mm:ss]

    dim x
    x = right(string(length,"0") + cStr(num),length)
    intToStr = x
end function


function isGeresh (str)
	dim b
	b = false
	if inStr(str,"'") then b = true
	if inStr(str,"`") then b = true
	if inStr(str,"‘") then b = true
	if inStr(str,"’") then b = true
	if inStr(str,"‚") then b = true
	if inStr(str,"′") then b = true
	if inStr(str,"‵") then b = true
	if inStr(str,"＇") then b = true
	if inStr(str,"׳") then b = true
	if inStr(str,"""") then b = true
	if inStr(str,"“") then b = true
	if inStr(str,"”") then b = true
	if inStr(str,"„") then b = true
	if inStr(str,"‟") then b = true
	if inStr(str,"″") then b = true
	if inStr(str,"״") then b = true

	isGeresh = b
end function




response.write "server:" + (Server.MapPath("\") & "<br>")
'response.end

	dim fs,f,sep,skip
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	set f=fs.OpenTextFile(Server.MapPath("2018-GereshFix.csv"),2,true,-1)


openDB "arabicWords"
mySQL = "SELECT * FROM words"
res.open mySQL, con
	do until res.EOF
		skip = true
		mySQL = "UPDATE words SET "
		sep = ""
		dim field
		for each field in res.fields
			'response.write "<br/>fieldName = "&field.name&", type = "&TypeName(field.value)
			if TypeName(field.value) = "String" then
				mySQL = mySQL + sep +"["+field.name+"]=" + "'" + gereshFix(field.value) + "'" 
				sep = ", "
				'response.write "<br/>isGeresh = "&isGeresh(field.value)
				if isGeresh(field.value) then skip = false
			end if
		next
 		mySQL = mySQL + " WHERE id="&res("id")

 		if skip=false then 
 			f.WriteLine(intToStr(res("id"),4) +_
 			",""" +  res("hebrewTranslation") +_
 			""",""" + gereshFix(res("hebrewTranslation")) +_
 			""",""" + res("arabicWord") +_
 			""",""" + gereshFix(res("arabicWord")) + vbcrlf) + """"
 			'Response.Write "<br/>"&mySQL
 		end if

		cmd.CommandType=1
		cmd.CommandText=mySQL
		'Response.Write "<br/>"&mySQL
		'Response.End
		set cmd.ActiveConnection=con
		cmd.execute ,,128
		
		res.moveNext
	loop
res.close

f.Close
set f=Nothing
set fs=Nothing



response.write "<br/>ALL DONE!! :)"
response.end
closeDB
%>
</div>
</body>