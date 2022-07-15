<!--#include file="inc/inc_sql.asp"-->
<!--#include file="inc/time.asp"--><%
if session("userID") <> 1 then
session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
response.redirect "test.asp"
end if
%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <meta name="robots" content="noindex" />
	<title>TEST - SQL</title>
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
</head>
<body>

<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
    <a href="test.asp">ארגז חול</a> /
    <h1>SQL</h1>
</div>

<div>
    <h2>TEST LOCAL SQL</h2>
    <%
    openSqlDb "arabic"
        mySQL = "SELECT * FROM words"
        res.open mySQL, conSql
        response.write "res(0)=" & res(0)
        res.close
    closeDB %>
</div>