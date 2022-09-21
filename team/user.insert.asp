<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head><%
Response.Write "TOP of code"
'If (session("role") and 2) = 0 then Response.Redirect "login.asp"

Function getString (f)
	getString = "'" &replace(request(f),"'","&#39;")&"'"
End function

Dim msg,maxId,myMail,cTime,cTimeFix
Dim username,password,hName,fName,lName,about,gender,eMail,eMailVCode

username = getString("username")
password = getString("password")
fName = request("firstName")
lName = request("lastName")
hName = fName + " " + lName
hName = "'" &replace(hName,"'","&#39;")&"'"
about = getString("about")
eMail = getString("eMail")
Randomize
eMailVCode = Int((9999-1001+1)*Rnd+1001)
gender = request("gender")
response.write "<br/>eMailVCode = "&eMailVCode
'response.end



startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","user.insert.asp","single",""




Response.Write "<br/>opened DB"

'check if email taken'
'IN FUTURE - MAKE RESET PASSWORD FEATURE '
mySQL = "SELECT email FROM users WHERE email="&eMail
res.open mySQL,con
if not res.EOF then
	session("msg")="כתובת המייל '"&eMail&"' כבר משויכת למשתמש במילון.<br/><a href='login.asp'>התחברו</a> או אם אינכם זוכרים את הסיסמא שלכם, שילחו אלינו מייל מהכתובת שציינתם ל-admin@madrasafree.com"
	response.Redirect "joinus.asp?username="&username&"&fName="&fName&"&lName="&lName&"&gender="&gender&"&about="&about
end if
res.close

'check if username taken'
mySQL = "SELECT username FROM users WHERE username="&username
res.open mySQL,con
if not res.EOF then
	session("msg")="שם המשתמש '"&username&"' תפוס.<br/>נסו שם משתמש אחר"
	response.Redirect "joinus.asp?email="&eMail&"&fName="&fName&"&lName="&lName&"&gender="&gender&"&about="&about
end if
res.close


if Request.Servervariables("HTTP_HOST") = "rothfarb.info" then 
	cTime = DateAdd("h",9,now()) 'ADDING 9 Hours to sync GoDaddy's server with Israel's Timezone'
else 
	cTime = now() 'for when working on localhost - PC clock'
end if
'cTimeFix = year(cTime) &"-"& intToStr(month(ctime),2) &"-"& intToStr(day(ctime),2) &" "& hour(cTime) &":"& minute(cTime) &":"& second(cTime)
cTimeFix = year(cTime) &"-"& month(ctime) &"-"& day(ctime) &" "& hour(cTime) &":"& minute(cTime) &":"& second(cTime)
'GoDaddy is american style date while Israel is not - this makes the month and day mix-up when day is less than 13

Set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO users ([username],[password],[role],[name],eMail,about,gender,joinDate) VALUES ("&username&","&password&",'3',"& hName&","&eMail&","&about&",'"&gender&"','"&cTimeFix&"')"
cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write "<br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128

mySQL = "SELECT MAX(id) FROM users"
Set res = con.Execute (mySQL)
maxId = res(0)



endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","user.insert.asp","single",durationMs,""




session("msg") = "ברוכים הבאים לצוות המילון! מייל אימות נשלח לכתובת המייל שלך"
session("userID")=maxId
session("userName")=username
session("email")=eMail
session("role")=3
session("name")=fName+" "+lName

response.write "<br/>END OF INSERT"
'response.end
if Request.ServerVariables("SERVER_NAME") = "rothfarb.info" then
	Response.Redirect "send_email_verify.php?eMail="&eMail&"&eMailVCode="&eMailVCode&"&maxId="&maxId&"&hebrewName="&hName
end if
session("msg") = "ברוכים הבאים לצוות המילון!"
Response.Redirect "../profile.asp?id="&maxId %>
</html>