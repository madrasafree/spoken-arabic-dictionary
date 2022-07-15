<!--#include file="inc/inc.asp"--><%
If (session("role") and 2) = 0 then
	session("msg") = "אין לך הרשאה להסתרת מילה. אם זו טעות, פנה למנהל המילון."
	Response.Redirect "login.asp"
end If

dim msg,wordId,action,showOld,show,explain,cTime,cTimeFix

wordId = CLng(Request("id"))
explain = Request("explain")



startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","word.hide.asp","single",""


mySQL = "SELECT show FROM words WHERE id="&wordID
res.open mySQL, con
	showOld = res(0)
res.close	    

if showOld="True" then
	show="False"
	action=5 'Hide'
	session("msg") = "המילה הוסתרה מהגולשים"
else
	show="True"
	action=6 'unHide'
	session("msg") = "המילה מוצגת לגולשים"
end if
response.write "<br/>showOld="&showOld
response.write "<br/>show="&show


if Request.Servervariables("HTTP_HOST") = "ronen.rothfarb.info" then 
	cTime = DateAdd("h",9,now()) 'ADDING 9 Hours to sync GoDaddy's serever with Israel's Timezone'
else 
	cTime = now() 'for when working on localhost - PC clock'
end if
cTimeFix = year(cTime) &"-"& month(ctime) &"-"& day(ctime) &" "& hour(cTime) &":"& minute(cTime) &":"& second(cTime)
'GoDaddy is american style date while Israel is not - this makes the month and day mix-up when day is less than 13


'response.end

'insert to history'
set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO history (word,actionDate,[action],[user],showOld,showNew,explain) VALUES ("&wordID&",'"&cTimeFix&"',"&action&","&session("userID")&","&showOld&","&show&",'"&explain&"')"
cmd.CommandType=1
cmd.CommandText=mySQL
'Response.Write mySQL
'Response.End
set cmd.ActiveConnection=con
cmd.execute ,,128


mySQL = "UPDATE [words] SET show=not show WHERE id="&wordId
cmd.CommandType=1
cmd.CommandText=mySQL
'Response.Write mySQL
'Response.End
set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","word.hide.asp","single",durationMs,""




Response.Redirect "../word.asp?id="&wordId
%>