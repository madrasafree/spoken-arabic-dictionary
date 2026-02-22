<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" %>
<!DOCTYPE html>
<html>
<head>
	<title>מעקב כניסות</title>
    <meta name="robots" content="none">
    <!--#include file="inc/header.asp"-->
    <style>
    .loginLog {display:table-row;}
    .loginLog > span {display:table-cell; padding:5px 10px;}
    .loginLog:nth-child(odd) {background-color:#eee;}
    .loginLog:nth-child(even) {background-color:#fff;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div class="table">
	<a href="admin.asp">חזרה לדף ניהול ראשי</a>
	<h1>מעקב כניסות</h1>
	מציג 250 כניסות משתמשים רשומים לאתר 
	<div style="margin:50px auto;"><%


	'openDB "arabicUsers"
	openDbLogger "arabicUsers","O","admin.loginHistory.asp","single",""

		mySQL = "SELECT TOP 250 loginLog.*,users.username, users.name FROM loginLog LEFT JOIN users ON users.id = loginLog.userID ORDER BY loginTimeUTC DESC"
		res.open mySQL, con
			do until res.EOF %>
			<div class="loginLog">
				
				<span><%=res("username")%> <span style="display:block;font-size: small;"><%=res("name")%></span></span>
				<span dir="ltr"><%=res("loginTimeUTC")%></span>
			</div><%
			res.movenext
			loop
		res.close


	'closeDB
	closeDbLogger "arabicUsers","C","admin.loginHistory.asp","single",durationMs,""
	%>
	</div>
</div>
</body>
</html>