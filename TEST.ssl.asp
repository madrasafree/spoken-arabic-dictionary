<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<html>
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">
    <meta charset="UTF-8">
    <style>
    body {font-size:large;}
    </style>
</head>

<body>
<div style="max-width:600px; margin:0 auto;">
	<h3>IS SSL?</h3><%
	dim s

	if Request.ServerVariables("HTTPS") = "on" then 
		s = "YES"
	else 
		s = "NO"
	end if %>

	<h2><%=s%></h2>



</div>
</body>
</html>