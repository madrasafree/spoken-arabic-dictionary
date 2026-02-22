<!--#include file="inc/inc.asp"--><%
if (session("role")<2) then 
    session("msg") = "יש להתחבר על מנת להצביע"
    Response.Redirect "team/login.asp"
end if %>
<!--#include file="team/inc/functions/string.asp"-->
<!DOCTYPE html>
<html>
<head>
	<title>משימות - עדכון הצבעה</title>
    <meta name="robots" content="none">
    <!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="css/devMode.css">
</head>
<body>
<ol id="fix">
    <h2>לטיפול בדף זה:</h2>
</ol>
<div id="code">
<!--#include file="inc/time.asp"--><%

dim tID,vote,userID,voteCnt

tID = request("tID")
vote = request("vote")
userID = session("userID")

'openDB "arabicManager"
openDbLogger "arabicManager","O","team.task.vote.asp","single",""

mySQL = "SELECT COUNT(taskID) FROM tasksVoting WHERE userID = "&userID
res.open mySQL, con
    voteCnt = res(0)
res.close

response.write "<br/>tID = "&tID&", vote = "&vote&", userID = "&userID&", voteCNT = "&voteCNT

if vote="up" then
    if voteCNT >= 3 then
        session("msg") = "לא ניתן לבחור בשלב זה יותר מ-3 משימות"
        response.Redirect "team.tasks.asp"
    else
        mySQL = "INSERT INTO tasksVoting (taskID,userID) VALUES ("&tID&","&userID&")"
    end if
else
    mySQL = "DELETE FROM tasksVoting WHERE taskID="&tID&" AND userID="&userID
end if
%><div class="mySQL"><%=mySQL%></div><%
'RESPONSE.END
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


'closeDB
closeDbLogger "arabicManager","C","team.task.vote.asp","single",durationMs,""



if vote="up" then
    session("msg") = "בחרת במשימה " + tID + ". תודה!"
else
    session("msg") = "הסרנו את בחירתך ממשימה " + tID + "."
end if

Response.Redirect "team.tasks.asp" %>
</div>
</body>
</html>