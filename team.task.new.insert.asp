<!--#include file="inc/inc.asp"--><%
if (session("role")=15) then 
else
    session("msg") = "כדי לערוך משימות, עליך לקבל הרשאה מתאימה ממנהל האתר"
    Response.Redirect "team/login.asp"
end if %>
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/functions/string.asp"-->
<!DOCTYPE html>
<html>
<head>
    <meta name="ROBOTS" content="NONE">
	<title>הזנת משימה חדשה במסד נתונים</title>
    <!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="css/devMode.css">
</head>
<body>
<ol id="fix">
    <h2>לטיפול בדף זה:</h2>

    <li>לעדכן תת-משימות</li>
    <li>לשייך משימה לתגיות</li>
</ol>
<div id="code">
<!--#include file="inc/time.asp"--><%

dim tID,tTitle,project,tStatus,priority,tType,tSection,tPrivate,tNotes,tImg,dateStart

tTitle = gereshFix(request("title"))
project = "1" 'STATIC'
tStatus = request("status")
priority = request("priority")
tPrivate = request("private")
if tPrivate = "" then tPrivate = "off"
tType = request("type")
tSection = request("section")
tImg = request("img")
if tImg = "" then tImg = "off"
tNotes = gereshFix(request("notes"))


'openDB "arabicManager"
openDbLogger "arabicManager","O","team.task.new.insert.asp","single",""

mySQL = "SELECT now()"
res.open mySQL, con
response.write mySQL &"<br/>res 0 = "&res(0)
dateStart = AR2UTC(res(0)) 'UTC (Arizona+7) - ADD FUNCTION TO TIME.ASP'
res.close
response.write "<br/>dateStart = "&dateStart



'INSERT TASK
mySQL = "INSERT INTO tasks (title,project,status,priority,type,[section],private,notes,img,dateStart,dateEdit) VALUES "&_
		"( '"&tTitle&"',"&project&","&tStatus&","&priority&","&tType&","&tSection&","&tPrivate&",'"&tNotes&"',"&tImg&",'"&dateStart&"','"&dateStart&"')"

%><div class="mySQL"><%=mySQL%></div><%
'response.end
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

'GET NEW TASK's ID
mySQL = "SELECT TOP 1 id FROM tasks ORDER BY id DESC"
res.open mySQL, con
tID = res(0)
res.close


'INSERT LABELS
dim lblCNT

mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
	lblCNT = res(0)
res.close
dim labelsOldStr, labelsNewArr(),labelsNewStr
redim labelsNewArr(lblCnt)

dim isFirst, isFirst2, i
labelsNewStr = ""
isFirst=true

'get new labels
for i=1 to lblCnt
	labelsNewArr(i)=request("label"&cstr(i))
	if isFirst then
		if labelsNewArr(i)="on" then
			labelsNewStr = cstr(i)
			isFirst = false
		end if
	else
		if labelsNewArr(i)="on" then labelsNewStr = labelsNewStr & "," & cstr(i)
	end if
next

'insert new labels
for i=1 to lblCnt
	if labelsNewArr(i)="on" then 
		mySQL = "INSERT INTO tasksLabels (task,Label) VALUES ("&tId&","&i&")"
		cmd.CommandText=mySQL
		cmd.execute ,,128
	end if
next


'INSERT NEW SUBTASK
if len(request("newSubTitle"))>0 then
    dim newSubDone
    if request("newSubDone")="on" then newSubDone = "on" else newSubDone = "off"
    mySQL = "INSERT INTO subTasks (place,title,isDone,task) VALUES ("&request("newSubPos")&",'"&gereshFix(request("newSubTitle"))&"',"&newSubDone&","&tID&")"
    cmd.CommandType=1
    cmd.CommandText=mySQL
    Set cmd.ActiveConnection=con
    cmd.execute ,,128
end if

'closeDB
closeDbLogger "arabicManager","C","team.task.new.insert.asp","single",durationMs,""

session("msg") = "משימה " & tID & " נוספה בהצלחה"
Response.Redirect "team.tasks.asp" %>
</div>
</body>
</html>