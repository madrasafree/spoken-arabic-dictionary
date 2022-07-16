<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("userID") <> 1 then
	session("msg") = "דף זה זמין כרגע רק למנהלי האתר"
	response.redirect Request.ServerVariables("HTTP_REFERER")
end if

dim userInt,daysPassed,send2user,lastEmail


%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<meta name="ROBOTS" content="NOINDEX" />
	<title>מייל מתוזמן</title>
	<!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
	<style>
	#users,#usersWords {
		margin:20px;
	}
	#users td,#usersWords td {
		border:1px solid gray;
		padding:2px 4px;
	}
	</style>
</head>
<body>
<!--#include file="inc/top.asp"-->


<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ארגז חול</a> / 
	<h1>מייל אוטומטי</h1>
</div>


<h2>שדות יעודיים חדשים</h2>
<table id="users">
	<tr>
		<td>id</td>
		<td>name</td>
		<td>email</td>
		<td>role</td>
		<td>emailLast</td>
		<td>emailInterval</td>
	</tr><%


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","TEST.emailTimer.asp","single",""


mySQL = "SELECT * FROM users WHERE emailInterval > 0"
res.open mySQL, con
do until res.EOF %>
	<tr>
		<td><%=res("id")%></td>
		<td><%=res("name")%></td>
		<td><%=res("email")%></td>
		<td><%=res("role")%></td>
		<td><%=res("emailLast")%></td>
		<td><%=res("emailInterval")%></td>
	</tr><%
	res.moveNext
loop
res.close %>
</table>

<h2>טבלה מקשרת - משתמשים ומילים במעקב</h2>
<table id="usersWords">
	<tr>
		<td>userID</td>
		<td>wordID</td>
	</tr><%
mySQL = "SELECT TOP 100 * FROM usersWordsFollow"
res.open mySQL, con
do until res.EOF %>
	<tr>
		<td><%=res("userID")%></td>
		<td><%=res("wordID")%></td>
	</tr><%
	res.moveNext
loop
res.close %>
</table>


<h2>משתמשים שעוקבים והגיע מועד השליחה</h2>
<table id="usersWords">
	<tr>
		<td>מס"ד</td>
		<td>משלוח אחרון</td>
		<td>אינטרוול</td>
		<td>תאריך היום</td>
		<td>הפרש בימים</td>
		<td>האם צריך לשלוח?</td>
		<td></td>
	</tr><%
mySQL = "SELECT * FROM users INNER JOIN usersWordsFollow ON users.[id] = usersWordsFollow.userID"
res.open mySQL, con
do until res.EOF
	send2user = false %>
	<tr>
		<td><%=res("id")%></td>
		<td><%
			lastEmail = res("emailLast")
			response.write lastEmail %>
		</td>
		<td><%
			userInt = res("emailInterval")
			response.write userInt %>
		</td>
		<td><%=left(dateToStrISO8601(now),10)%></td>
		<td><%
			daysPassed = dateDiff("d",res("emailLast"),left(dateToStrISO8601(now),10))
			response.write daysPassed %>
		</td>
		<td><%
		if daysPassed > userInt then send2user = true
		if len(lastEmail) = 10 then send2user = send2user else send2user = true
		if send2user = true then response.write "כן" else response.write "לא"
		%></td>
		<td><% if send2user then %>
			<a href="TEST.emailTimerSMTP.php?uID=<%=res("id")%>&wordID=8000">שליחה ידנית</a><%
			end if %>
		</td>
	</tr><%
	res.moveNext
loop
res.close 

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","TEST.emailTimer.asp","single",durationMs,""
%>

</table>



<h2>משימות</h2>
<ol>
	<li>(תיזמון במחשב לגלוש לדף יעודי בשעה קבועה בלילה. למשל 03:00)</li>
	<li>הדף היעודי בודק ומכין מיילים לשליחה
	<ol style="font-size:small;">
		<li><s>מושך משתמשים מטבלה מקשרת. מצליב עם תאריך שליחה אחרון</s></li>
		<li><b>שליחת מייל ניסיון - עדכון תאריך מועד שליחה אחרון</b></li>
		<li>(מושך מילים מטבלה מקשרת. מצליב עם תאריך עריכה שלהם)</li>
		<li>עורך הכל יחדיו לכדי מייל ושולח - לכל משתמש בנפרד</li>
	</ol>
	</li>
	<li>בעת הוספה / עריכת מילה - ברירת מחדל - להוסיף למעקב אותו המשתמש</li>
</ol> <%
 %>

<!--#include file="inc/trailer.asp"-->