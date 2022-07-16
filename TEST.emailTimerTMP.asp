<!--#include file="inc/inc.asp"--><%
if session("userID") <> 1 then
	session("msg") = "דף זה זמין כרגע רק למנהלי האתר"
	response.redirect Request.ServerVariables("HTTP_REFERER")
end if

startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","TEST.emailTimerTMP.asp","single",""

mySQL = "INSERT INTO usersWordsFollow (userID,wordID) VALUES (1,8328)"
cmd.CommandType=1
cmd.CommandText=mySQL
'Response.Write "<br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","TEST.emailTimerTMP.asp","single",durationMs,""




session("msg") = "משתמש מספר 1 עוקב אחרי מילה מספר 8328"
response.Redirect "TEST.emailTimer.asp"


%>
