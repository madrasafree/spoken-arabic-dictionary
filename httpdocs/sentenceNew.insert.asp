<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!--#include file="inc/functions/soundex.asp"-->
<!--#include file="inc/functions/string.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head>
<!--#include file="inc/top.asp"-->
<%
dim q,qFix 'TEMP from inc/top.asp'

Response.Write "TOP of code"
if (session("role") and 2) = 0 then 
	session("msg") = "בעיית הרשאה בעת הוספת משפט חדש. ייתכן וחיכית יותר מדי זמן בדף העריכה והמערכת ניתקה אותך. אם הבעיה חוזרת על עצמה, אנא פנה למנהל האתר"
	response.Redirect "login.asp"
end if

Dim query,msg,maxId,myMail,nowUTC
Dim arabic,hebrew,arabicHeb,info
Dim status,i
Dim hebrewClean,arabicClean,arabicHebClean

hebrew = gereshFix(request("hebrew"))
arabic = gereshFix(request("arabic"))
arabicHeb = gereshFix(request("arabicHeb"))
info = gereshFix(request("info"))

if (session("role") And 4)>0 then status=1 else status=0
if session("userID") = 1 then status=0

Response.Write "<br/>WHERE AM II?"

hebrewClean = onlyLetters(hebrew)
arabicClean = onlyLetters(arabic)
arabicHebClean = onlyLetters(arabicHeb)

nowUTC = AR2UTC(now())


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","sentenceNew.insert.asp","single",""

Set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO sentences (hebrew,hebrewClean,arabic,arabicClean,arabicHeb,arabicHebClean,info,creator,creationTimeUTC) VALUES ('"& hebrew&"','"& hebrewClean&"','"&arabic&"','"&arabicClean&"','"&arabicHeb&"','"&arabicHebClean&"','"&info&"',"&session("userID")&",'"&nowUTC&"')"
cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write "<br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","sentenceNew.insert.asp","single",durationMs,""



session("msg") = "המשפט <span class=""nikud"">" & arabic & "</span></a> נוסף למילון בהצלחה"

response.write "<br/>END OF INSERT"
response.Redirect "sentences.asp"
%>
</html>