<!--#include file="inc/inc.asp"-->
<html>
<head>
	<meta charset="utf-8"/>
</head><%
If session("role") <> 15 then
	session("msg") = "אין הרשאה מתאימה לביצוע פעולה זו"
	Response.Redirect "admin.labelControl.asp"
end If

function getString (f)
	getString = "'" &replace(request(f),"'","&#39;")&"'"
end function

dim maxId, labelName

labelName = getString("labelNew")


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","admin.labelNew.insert.asp","single",""


'CHECK IF NAME IS ALREADY TAKEN'
mySQL = "SELECT * FROM labels WHERE labelName="&labelName
res.open mySQL, con
if NOT res.EOF then
	session("msg") = "נושא עם שם זהה כבר קיים במערכת"
	Response.Redirect "admin.labelControl.asp"
end if
res.close

'GET MAXID AND ADD 1'
mySQL = "SELECT MAX(ID) FROM labels"
res.open mySQL, con
	maxId = res(0) + 1
res.close

'INSERT NEW LABEL'
set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO [labels] ([id],[labelName]) VALUES ("&maxID&","&labelName&")"
cmd.CommandType=1
cmd.CommandText=mySQL
set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","admin.labelNew.insert.asp","single",durationMs,""




Session("msg") = "הנושא '"&labelName&"' נוסף בהצלחה!"

Response.Redirect "admin.labelControl.asp" %>
</html>