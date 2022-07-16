<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html>
<head>
	<title>ניהול משתמשים - גרסא מינימלית</title>
    <META NAME="ROBOTS" CONTENT="NONE">
	<style>
		.role1 td {background:#80808030;}
		.role7 td {background:#fffc92;}
		.role15 td {background:#ffd392;}
		.userRow td {border-bottom:1px dotted gray;}
	</style>
<!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"-->
<div><%

dim userId, userName, d,gen

gen=""
userId = request("id")


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.userControl.asp","single",""


mySQL = "SELECT * FROM users ORDER BY name"
res.open mySQL, con %>

<div style="margin:20px auto; text-align:center;">
	<h2>ניהול משתמשים</h2>
	<a href="admin.userNew.asp" style="background:#eeddcc;width:150px;border:solid 1px gray; padding:3px;">הוספת משתמש חדש</a>
</div>

<table class="table" style="width:600px;">
    <tr style="background:#edc;">
        <td>שם אמיתי</a></td>
		<td dir="ltr">Username</td>
		<td dir="ltr">eMail</td>
        <td dir="ltr">R</td>
        <td></td>
    </tr><%
    do until res.EOF %>
	    <tr class="userRow role<%=res("role")%>">
			
	        <td style="vertical-align:top; text-align:right;">
	            <a href="profile.asp?id=<%=res("id")%>" target="profile<%=res("id")%>">
					<%=res("name")%> <small>(<%if res("gender")=1 then %>M<% else %>F<%end if%>)</small>
				</a></td>
			<td dir="ltr"><%=res("userName")%></td>
			<td dir="ltr"><%=res("eMail")%></td>
			<td style="text-align:center;"><%=res("role")%></td>
	        <td dir="ltr"><a href="admin.userEdit.asp?id=<%=res("id")%>"><div>עריכה</div></a></td>
	    </tr><%
	    res.movenext
	loop %>
</table><%
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.userControl.asp","single",durationMs,""
%>
</div>
</body>