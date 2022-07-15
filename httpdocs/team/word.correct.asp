<!--#include file="inc/inc.asp"--><%
If (session("role") and 2) = 0 then
	session("msg") = "אין לך הרשאה לאישור המילה. אם זו טעות, פנה למנהל המילון."
	Response.Redirect "login.asp"
end If

dim wordID,action,statusOld,status,cTime,cTimeFix

wordID = request ("wordID")
response.write "<br/>wordID = "& wordID
action = 3
response.write "<br/>action = "& action
statusOld = request ("status")
response.write "<br/>statusOld = "& statusOld
status = 1
response.write "<br/>status = "& status

if Request.Servervariables("HTTP_HOST") = "ronen.rothfarb.info" then 
	cTime = DateAdd("h",9,now()) 'ADDING 9 Hours to sync GoDaddy's serever with Israel's Timezone'
else 
	cTime = now() 'for when working on localhost - PC clock'
end if
cTimeFix = year(cTime) &"-"& month(ctime) &"-"& day(ctime) &" "& hour(cTime) &":"& minute(cTime) &":"& second(cTime)
'GoDaddy is american style date while Israel is not - this makes the month and day mix-up when day is less than 13


openDB "arabicWords"

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","word.correct.asp","single",""

Set cmd=Server.CreateObject("adodb.command")

'Histroy / Log'
mySQL = "INSERT into history (word,actionDate,[action],statusOld,statusNew,[user]) VALUES ("&wordID&",'"&cTimeFix&"',"&action&","&statusOld&","&status&","&session("userID")&")"

cmd.CommandType=1
cmd.CommandText=mySQL
response.write "<br/>mySQL = "& mySQL
'response.end
Set cmd.ActiveConnection=con
cmd.execute ,,128

'CHANGE STATUS in WORDS TABLE'
mySQL = "UPDATE words SET status="&status&" WHERE id="&wordId
cmd.CommandType=1
cmd.CommandText=mySQL
response.write "<br/><br/>mySQL = "& mySQL
'response.end
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","word.correct.asp","single",durationMs,""





session("msg") = "הערך סומן כתקין. תודה על עזרתך!"
Response.Redirect baseA&"word.asp?id="&wordID

%>