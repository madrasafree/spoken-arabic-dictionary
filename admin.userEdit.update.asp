<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp"


function getString (f)
	getString = "'" &replace(request(f),"'","&#39;")&"'"
end function

dim name,eMail,about,username,password,role,gender,picture,maxLists
dim msg,userId

userId = CLng(Request("id"))
name = getString("name")
eMail = getString("eMail")
about = getString("about")
username = getString("username")
password = getString("password")
if password = "''" then password = "[password]"
role = replace(Request("role"), ",", "+")
gender = getString("gender")
picture = Request("picture")
maxLists = CLng(request("maxLists"))


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.userEdit.update.asp","single",""


set cmd=Server.CreateObject("adodb.command")
mySQL = "UPDATE [users] SET [name]="&name&",[eMail]="&eMail&",[about]="&about&",[username]="& _
    username&",[password]="&password&",[gender]="&gender&",[maxLists]="&maxLists&",[picture]="&picture&",[role]="&role&"+1 WHERE id="&userId
cmd.CommandType=1
cmd.CommandText=mySQL
set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.userEdit.update.asp","single",durationMs,""

Session("msg") = ""&username&" profile updated"

Response.Redirect "admin.asp"
%>