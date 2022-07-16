<!--#include file="inc/inc.asp"--><%
if (session("role")=15) then 
else
    session("msg") = "כדי לערוך משימות, עליך לקבל הרשאה מתאימה ממנהל האתר"
    Response.Redirect "team/login.asp"
end if %>
<!--#include file="team/inc/functions/string.asp"-->
<!DOCTYPE html>
<html>
<head>
	<title>עדכון משימה במסד נתונים</title>
    <meta name="robots" content="none">
    <!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="css/devMode.css">
</head>
<body>
<ol id="fix">
    <h2>לטיפול בדף זה:</h2>

    <li>תת-משימה חדשה</li>
    <li>לשייך משימה לפרויקט/ים</li>
</ol>
<div id="code">
<!--#include file="inc/time.asp"--><%

dim tID,tTitle,project,tStatus,priority,tType,tSection,tPrivate,tNotes,tImg,dateStart,dateEdit,dateEnd

tID = request("tID")
tTitle = gereshFix(request("title"))
response.write "<br/>tTitle = "&tTitle&"<br/>"
project = "1" 'STATIC'
tStatus = request("status")
priority = request("priority")
tType = request("type")
tSection = request("section")
if request("private") = "on" then tPrivate = "on" else tPrivate = "off"
if request("img") = "on" then tImg = "on" else tImg = "off"
tNotes = gereshFix(request("notes"))
dateStart = gereshFix(request("dateStart")) 'Make sure UTC'
dateEnd = gereshFix(request("dateEnd"))


startTime = timer()
'openDB "arabicManager"
openDbLogger "arabicManager","O","team.task.edit.update.asp","single",""



'UPDATE CURRENT SUBTASKS'
dim subID,subPos,subTitle,subDone
mySQL = "SELECT * FROM subTasks WHERE task = "&tID
res.open mySQL, con
if res.EOF then
    response.write "<br/>No current subTasks"
else
    do until res.EOF
        subID = res("id")
        subPos = request("subPos"&subID)
        subTitle = gereshFix(request("subTitle"&subID))
        if subPos = "" then subPos = "99"
        if request("subDone"&subID) = "on" then subDone = "on" else subDone = "off"
        if len(subTitle)>0 then
            mySQL = "UPDATE subTasks SET title = '"&subTitle&"', place = "&subPos&", isDone = "&subDone&" WHERE id = "&subID
        else
            mySQL = "DELETE FROM subTasks WHERE id="&subID
        end if
%><div class="mySQL"><%=mySQL%></div><%
'RESPONSE.END
        cmd.CommandType=1
        cmd.CommandText=mySQL
        Set cmd.ActiveConnection=con
        cmd.execute ,,128
        res.moveNext
    loop
end if
res.close

'INSERT NEW SUBTASK
if len(request("newSubTitle"))>0 then
    dim newSubDone,newSubPos
    if Request("newSubPos") = "" then newSubPos = "99" else newSubPos = request("newSubPos")
    if request("newSubDone")="on" then newSubDone = "on" else newSubDone = "off"
    mySQL = "INSERT INTO subTasks (place,title,isDone,task) VALUES ("&newSubPos&",'"&gereshFix(request("newSubTitle"))&"',"&newSubDone&","&tID&")"
%><div class="mySQL"><%=mySQL%></div><%
'RESPONSE.END    cmd.CommandType=1
    cmd.CommandText=mySQL
    Set cmd.ActiveConnection=con
    cmd.execute ,,128
end if


mySQL = "SELECT now()"
res.open mySQL, con
    response.write mySQL &"<br/>res 0 = "&res(0)
    dateEdit = AR2UTC(res(0)) 'UTC (Arizona+7) - ADD FUNCTION TO TIME.ASP'
res.close
response.write "<br/>dateStart = "&dateStart

if ((dateEnd = "") And (tStatus=42)) then dateEnd = dateEdit 

'UPDATE TASK
mySQL = "UPDATE tasks SET title = '"&tTitle&"',project = "&project&",status = "&tStatus&",priority = "&priority&_
        ",[type] = "&tType&",[section] = "&tSection&",private = "&tPrivate&",notes = '"&tNotes&"', img = "&tImg&_
        ",dateStart = '"&dateStart&"',dateEdit = '"&dateEdit&"',dateEnd = '"&dateEnd&"' WHERE id="&tID

%><div class="mySQL"><%=mySQL%></div><%
'RESPONSE.END
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicManager","C","team.task.edit.update.asp","single",durationMs,""



session("msg") = "משימה " + tID + " עודכנה בהצלחה"
Response.Redirect "team.tasks.asp" %>
</div>
</body>
</html>