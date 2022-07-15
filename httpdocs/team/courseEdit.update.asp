<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head><%
Response.Write "TOP of code<br/>"
If (session("role") and 2) = 0 then Response.Redirect "login.asp"

Function getString (f)
	getString = "'" &replace(f,"'","''")&"'"
End function 

Dim cID,msg,maxId,myMail,cTime,cTimeFix
Dim sDate,school,cTitle,level,meetings,hours,days,area,city,address
Dim price,tutor,info,source,sourceL,cStatus

cID = request("cID")
response.write "<Br/>cID="&cID
sDate = request("startDate")
school = CLng(request("school"))
cTitle = getString(request("cTitle"))
level = CLng(Request("level"))
meetings = Request("meetings")
if len(meetings)=0 then meetings=0
hours = Request("hours")
if len(hours)=0 then hours=0
days = replace(getString(request("days"))," ","",1,-1)
area = CLng(Request("area"))
city = getString(request("city"))
address = getString(request("address"))
price = CLng(Request("price"))
if len(price)=0 then price=0
tutor = getString(request("tutor"))
info = getString(request("info"))
source = getString(request("source"))
sourceL = getString(request("sourceL"))
cStatus = CLng(Request("cStatus"))



'REPLACE WITH AR2UTC IN TIME.ASP

if Request.Servervariables("HTTP_HOST") = "rothfarb.info" then 
	cTime = DateAdd("h",9,now()) 'ADDING 9 Hours to sync GoDaddy's server with Israel's Timezone'
else 
	cTime = now() 'for when working on localhost - PC clock'
end if
cTimeFix = year(cTime) &"-"& intToStr(month(ctime),2) &"-"& intToStr(day(ctime),2) &" "& intToStr(hour(cTime),2) &":"& intToStr(minute(cTime),2) &":"& intToStr(second(cTime),2)
'cTimeFix = year(cTime) &"-"& month(ctime) &"-"& day(ctime) &" "& hour(cTime) &":"& minute(cTime) &":"& second(cTime)
'GoDaddy is american style date while Israel is not - this makes the month and day mix-up when day is less than 13


startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","courseEdit.update.asp","single",""




mySQL = "UPDATE courses SET startDate='"&sDate&"',school='"&school&"',cTitle="&cTitle&",[level]='"&level&"',meetings='"&meetings&"',hours='"&hours&"',days="&days&",area='"&area&"',city="&city&",address="&address&",price='"&price&"',tutor="&tutor&",info="&info&",source="&source&",sourceLink="&sourceL&",cStatus='"&cStatus&"',editorID='"&session("userID")&"',editTime='"&dateToStr(now)&"' WHERE id="&cId

cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write "<br/><br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSchools","C","courseEdit.asp","single",durationMs,""



'MSG'
session("msg") = "העריכה התבצעה בהצלחה"

'SEND EMAIL / REDIRECT'
if serverName="ronen.rothfarb.info" then
	Response.Redirect "courseEdit.email.php?cID="&cId&"&cTitle="&cTitle&"&userID="&session("userID")
else
	Response.Redirect "../where2learn.asp" 
end if %>

%>