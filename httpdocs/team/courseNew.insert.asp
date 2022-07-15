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
If (session("role") and 2) = 0 then Response.Redirect "login.asp"

Function getString (f)
	getString = "'" &replace(request(f),"'","&#39;")&"'"
End function

Dim msg,maxId,myMail,cTime,cTimeFix
Dim sDate,school,cTitle,level,meetings,hours,days,area,city,address
Dim price,tutor,info,source,sourceL

sDate = request("startDate")
school = CLng(request("school"))
cTitle = getString("cTitle")
level = CLng(Request("level"))
meetings = Request("meetings")
if len(meetings)=0 then meetings=0
hours = Request("hours")
if len(hours)=0 then hours=0
days = replace(getString("days")," ","",1,-1)
area = CLng(Request("area"))
city = getString("city")
address = getString("address")
price = Request("price")
if len(price)=0 then price=0
tutor = getString("tutor")
info = getString("info")
source = CLng(Request("source"))
sourceL = getString("sourceL")


'REPLACE WITH AR2UTC IN TIME.ASP

if Request.Servervariables("HTTP_HOST") = "ronen.rothfarb.info" then 
	cTime = DateAdd("h",9,now()) 'ADDING 9 Hours to sync GoDaddy's server with Israel's Timezone'
else 
	cTime = now() 'for when working on localhost - PC clock'
end if
cTimeFix = year(cTime) &"-"& intToStr(month(ctime),2) &"-"& intToStr(day(ctime),2) &" "& intToStr(hour(cTime),2) &":"& intToStr(minute(cTime),2) &":"& intToStr(second(cTime),2)
'cTimeFix = year(cTime) &"-"& month(ctime) &"-"& day(ctime) &" "& hour(cTime) &":"& minute(cTime) &":"& second(cTime)
'GoDaddy is american style date while Israel is not - this makes the month and day mix-up when day is less than 13



startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","courseNew.insert.asp","single",""


Set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO courses (startDate,school,cTitle,[level],meetings,hours,days,area,city,address,price,tutor,info,source,sourceLink,creatorID,createTime) VALUES ('"&sDate&"','"&school&"',"&cTitle&",'"&level&"','"&meetings&"','"&hours&"',"&days&",'"&area&"',"&city&","&address&",'"&price&"',"&tutor&","&info&",'"&source&"',"&sourceL&",'"&session("userID")&"','"&cTimeFix&"')"
'   "&session("userID")&",'"&cTimeFix&"',"&status&"
cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write "<br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128

mySQL = "SELECT MAX(id) FROM courses"
Set res = con.Execute (mySQL)
maxId = res(0)


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","courseNew.insert.asp","single",durationMs,""





session("msg") = "הקורס נוסף בהצלחה"

response.write "<br/>END OF INSERT"
'response.end
if serverName="rothfarb.info" then
	Response.Redirect "courseNew.email.php?cID="&maxId&"&cTitle="&cTitle
else
	Response.Redirect "../where2learn.asp" 
end if %>
</html>