﻿<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if

function getString (f)
	getString = "'" &replace(request(f),"'","&#39;")&"'"
end function

dim name,eMail,about,username,password,role,gender,joinDate
dim msg,maxId

name = getString("name")
eMail = getString("eMail")
about = getString("about")
username = getString("username")
password = getString("password")
role = replace(Request("role"), ",", "+")
gender = getString("gender")
joinDate = AR2UTC(now) 'using time.asp'


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.userNew.insert.asp","single",""

set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO [users] ([name],[eMail],[about],[username],[password],[role],[gender],joinDateUTC) VALUES ("&_
		name&","&eMail&","&about&","&username&","&password&","&role&"+1, "&gender&",'"&joinDate&"')"
response.write "<br>mySQL:<br>"&mySQL&"<br><br>"
cmd.CommandType=1
cmd.CommandText=mySQL
set cmd.ActiveConnection=con
cmd.execute ,,128

mySQL = "SELECT MAX(id) FROM users"
set res = con.Execute (mySQL)
maxId = res(0)

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.userNew.insert.asp","single",durationMs,""



Session("msg") = "המשתמש נוסף."

Response.Redirect "admin.userControl.asp"
%>