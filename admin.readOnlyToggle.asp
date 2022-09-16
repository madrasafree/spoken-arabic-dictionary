<!--#include file="inc/inc.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה לשינוי מצב מסד נתונים. פנה למנהל האתר"
	Response.Redirect "login.asp"
end if

dim toggleTo


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.readOnlyToggle.asp","single",""

mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readOnly'"
res.open mySQL, con
	response.write "res0 = "& res(0)
	if res(0)=true then toggleTo = false else toggleTo = true
res.close


set cmd=Server.CreateObject("adodb.command")
mySQL = "UPDATE [allowEdit] SET [allowed]="&toggleTo&" WHERE siteName='readOnly'"
cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write "<br/>"&mySQL
'Response.End
set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.readOnlyToggle.asp","single",durationMs,""


Session("msg") = "הפעולה בוצעה בהצלחה!"

Response.Redirect "admin.asp" %>