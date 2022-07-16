<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/soundex.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"--><%
if session("role") < 7 then
	session("msg") = "בעיית הרשאה בעת עריכת משפט קיים. ייתכן וחיכית יותר מדי זמן בדף העריכה והמערכת ניתקה אותך. אם הבעיה חוזרת על עצמה, אנא פנה למנהל האתר"
    response.redirect "login.asp" 
end if %>
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head>
<!--#include file="inc/top.asp"-->
<%
dim q,qFix 'TEMP from inc/top.asp'

Dim sID,msg,i
Dim cTime,cTimeFix,action,explain

Dim show,sStatus,info,merge
Dim arabic,arabicHeb,hebrew
Dim arabicClean,arabicHebClean,hebrewClean

Dim showOld,sStatusOld,infoOld
Dim arabicOld,arabicHebOld,hebrewOld
Dim arabicCleanOld,arabicHebCleanOld,hebrewCleanOld


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","sentenceEdit.update.asp","single",""

sID = request("sID")
response.write "sID = "&sID

mySQL = "SELECT * FROM sentences WHERE id="&sID
res.open mySQL, con
if res.EOF then
	session("msg") = "res.EOF on mySQL query: "&mySQL
else
	showOld = res("show")
	sStatusOld = res("status")
	if len(res("info"))>=0 then	infoOld = gereshFix(res("info")) else infoOld = "''"

	arabicOld = res("arabic")
	arabicHebOld = gereshFix(res("arabicHeb"))
	hebrewOld = gereshFix(res("hebrew"))
		
	arabicCleanOld = res("arabicClean")
	arabicHebCleanOld = gereshFix(res("arabicHebClean"))
	hebrewCleanOld = gereshFix(res("hebrewClean"))

end if
res.close

show = true
sStatus = request("status")
	if len(sStatus)<1 then sStatus = sStatusOld
info = gereshFix(request("info"))

arabic = gereshFix(Request("arabic"))
arabicHeb = gereshFix(Request("arabicHeb"))
hebrew = gereshFix(Request("hebrew"))

arabicClean = onlyLetters(arabic)
arabicHebClean =  onlyLetters(arabicHeb)
hebrewClean = onlyLetters(hebrew)


'Response.End

Set cmd=Server.CreateObject("adodb.command")


'DELETE CURRENT words' connections to this sentence
mySQL = "DELETE FROM wordsSentences WHERE sentence="&sID
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


'RECIEVE and CREATE NEW CONNECTION IDS by LOCATIONS
for i=0 to 20
	if len(request(i))>0 then 
		response.write "<br/>"&i&" = "&request(i)
		mySQL = "INSERT into wordsSentences (word,sentence,location,merge) VALUES ("&request(i)&","&sID&","&i&","&request("merge"&cstr(i))&")"
		'Response.Write "<br/><br/>"& mySQL
		'Response.End
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	end if
next


'MISSING HISTORY/LOG'


mySQL = "UPDATE sentences SET show="&show&",status="&sStatus&",arabic='"&arabic&"',arabicHeb='"&arabicHeb&"',hebrew='"& hebrew&"',info='"&info&"',hebrewClean='"& hebrewClean&"',arabicClean='"&arabicClean&"',arabicHebClean='"&arabicHebClean&"' WHERE id="&sID

cmd.CommandType=1
cmd.CommandText=mySQL
'Response.Write "<br/><br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128



endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","sentenceEdit.update.asp","single",durationMs,""


'MISSING UPDATE BY EMAIL'


session("msg") = "משפט מספר " &sID& " נערך בהצלחה"


response.redirect "sentence.asp?sID="&sID  %>