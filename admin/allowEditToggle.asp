<!--#include virtual="/includes/inc.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה לשינוי מצב מסד נתונים. פנה למנהל האתר"
	Response.Redirect "../login.asp"
end if

dim toggleTo


'openDB "arabicUsers"
openDbLogger "arabicUsers","O","allowEditToggle.asp","single",""

mySQL = "SELECT allowed FROM allowEdit WHERE siteName='arabic'"
res.open mySQL, con
	'response.write "res0 = "& res(0)
	if res(0)=true then toggleTo = false else toggleTo = true
res.close


set cmd=Server.CreateObject("adodb.command")
mySQL = "UPDATE [allowEdit] SET [allowed]="&toggleTo&" WHERE siteName='arabic'"
cmd.CommandType=1
cmd.CommandText=mySQL
'Response.Write "<br/>"&mySQL
'Response.End
set cmd.ActiveConnection=con
cmd.execute ,,128


'closeDB
closeDbLogger "arabicUsers","C","allowEditToggle.asp","single",durationMs,""


Session("msg") = "הרשאות עריכה עודכנו!"

Response.Redirect "index.asp" %>
