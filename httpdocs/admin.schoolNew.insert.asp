<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<html>
<head>
	<meta charset="utf-8"/>
</head><%
If session("role") <> 15 then Response.Redirect "login.asp"

function getString (f)
	getString = "'" &replace(request(f),"'","&#39;")&"'"
end function

dim school,tagline,sType,website,facebook,eMail,phone,logo,sAdmin
dim msg,maxId

school = getString("school")
tagline = getString("tagline")
sType = getString("type")
website = getString("website")
facebook = getString("facebook")
email = getString("email")
phone = getString("phone")
logo = getString("logo")
sAdmin = request("schoolAdmin")


startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","admin.schoolNew.insert.asp","single",""


set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO [schools] ([school],[tagline],[type],[adminID],[website],[facebook],[email],[phone],[logo]) VALUES ("&school&","&tagline&","&sType&","&sAdmin&","&website&","&facebook&","&email&","&phone&","&logo&")"
cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write mySQL
'Response.End
set cmd.ActiveConnection=con
cmd.execute ,,128

'mySQL = "SELECT MAX(id) FROM schools"
'	set res = con.Execute (mySQL)
'	maxId = res(0)


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSchools","C","admin.schoolNew.insert.asp","single",durationMs,""

Session("Message") = "בית הספר נוסף בהצלחה!"

Response.Redirect "admin.schoolControl.asp" %>
</html>