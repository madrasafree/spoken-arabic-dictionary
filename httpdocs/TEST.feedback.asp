<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
	<title>ארגז חול - פידבק</title>
	<meta name="Description" content="עזרו לנו להשתפר. תנו פידבקים על השימוש והחוויה שלכם במילון" />
	<!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
	<style>
	.fbackTbl {
		border:1px solid #ddd;
		direction:ltr;
		line-height:2em;
		margin:10px auto;
		width:100%;
	}
	.fbackTbl th {
		background:#ddd;
		font-weight:initial;
		padding-left:5px;
		text-align:left;
		}
	.fbackTbl td {
		padding:0 5px;
		border-right:1px dotted gray;
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
	<h1>פידבק</h1>
</div>


<div class="message warning">
	דף בבנייה
</div>

<ol style="line-height:1.4em">
	<li>זיהוי משתמש. הצעה לענות באנונימיות<br><%
		if len(session("username"))>0 then %>
			שלום לך <%=session("username")%>
			<br><button type="button" onclick="alert('feedback.asp?anonymous=false')">פידבק בתור <%=session("username")%></button><%
		else %>
			שלום לך גולש/ת אנונימי<br>
			<button type="button" onclick="document.location='team/login.asp'">התחבר/י</button><%
		end if %>
		<br><button type="button" onclick="alert('feedback.asp?anonymous=true')">פידבק אנונימי</button>
	</li>
	<li>מאיזה דף בחר לעשות פידבק</li>
	<li>תאריך/שעה ונתוני גלישה</li>
	<li>בחירת עד 3 שידרוגים מתוך 10</li>
	<li>דירוג שביעות רצון
		<ol>
			<li>מהירות גלישה מהמחשב<br>
				<input type="radio" id="5" name="speedPC" value="5">
				<label for="5">מרוצה מאוד</label>
				<input type="radio" id="3" name="speedPC" value="3">
				<label for="3">מרוצה</label>
				<input type="radio" id="0" name="speedPC" value="0">
				<label for="0">אין לי דעה בנושא / לא נוטה לכיוון מסוים</label>
				<input type="radio" id="-3" name="speedPC" value="-3">
				<label for="-3">לא מרוצה</label>
				<input type="radio" id="-5" name="speedPC" value="-5">
				<label for="-5">מאוד לא מרוצה</label>
			</li>
			<li>מהירות גלישה מהטלפון</li>
			<li>שביעות רצון כללית מהמילון</li>
		</ol>
	</li>
	<li>שאלות
		<ol>
			<li></li>
		</ol>
	</li>
	<li>הודעת סיום - תודה</li>
<ol>


<table class="fbackTbl">
	<tr>
		<th>fbID</th>
		<th>fbTimeUTC</th>
		<th title="0 = anonymous">uID</th>
		<th>uRole</th>
		<th>rfrPage</th>
		<th>tasksVote</th>
		<th>textFB</th>
		<th>HTTP_USER_AGENT</th>
		<th>HTTP_ACCEPT_LANGUAGE</th>
	</tr>
	<tr>
		<td>1</td>
		<td style="font-size:small;">2020-10-08T10:35:00Z</td>
		<td>0</td>
		<td>0</td>
		<td style="font-size:small;"><%=Request.ServerVariables("HTTP_REFERER")%></td>
		<td>13,432,66</td>
		<td dir="rtl">אני חושב שבלה בלה בלה</td>
		<td style="font-size:small;"><%=Request.ServerVariables("HTTP_USER_AGENT")%></td>
		<td style="font-size:small;"><%=Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")%></td>
	</tr>
</table>

<!--#include file="inc/trailer.asp"-->