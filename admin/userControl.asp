<!--#include virtual="/includes/inc.asp"-->
<!--#include virtual="/includes/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "/login.asp?returnTo=" & Server.URLEncode(Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING"))
end if %>
<!DOCTYPE html>
<html>
<head>
	<title>ניהול משתמשים - גרסא מינימלית</title>
    <META NAME="ROBOTS" CONTENT="NONE">
	<style>
		.role1 {background:#80808030;} /*guest*/
		.role7 {background:#fffc92;} /*editor*/
		.role15 {background:#ffd392;} /*admin*/
		.userRow td {border-bottom:1px dotted gray;}
		.userStatus77 {background:#a9f5ff; color:#1a8995;} /*frozen*/
		.userStatus88 {background:lightgray;} /*suspended*/
		.userStatus99 {background:gray; color:white;} /*deleted*/
	</style>
<!--#include virtual="/includes/header.asp"-->
</head>
<body>
<!--#include virtual="/includes/top.asp"-->
<div><%

dim userId, userName, d,gen

gen=""
userId = request("id")


'openDB "arabicUsers"
openDbLogger "arabicUsers","O","userControl.asp","single",""


mySQL = "SELECT * FROM users ORDER BY name"
res.open mySQL, con %>

<div style="margin:20px auto; text-align:center;">
	<h2>ניהול משתמשים</h2>
	<a href="userNew.asp" style="background:#eeddcc;width:150px;border:solid 1px gray; padding:3px;">הוספת משתמש חדש</a>
</div>

<table class="table" style="width:600px;">
    <tr style="background:#edc;">
		<td>userStatus</td>
        <td>שם אמיתי</td>
		<td dir="ltr">Username</td>
		<td dir="ltr">eMail</td>
        <td dir="ltr">R</td>
        <td></td>
    </tr><%
    do until res.EOF %>
	    <tr class="userRow">
			<td class="userStatus<%=res("userStatus")%>"><%
				Select Case res("userStatus")
					case 1 'active
					response.write "פעיל"
					case 77 'frozen
					response.write "מוקפא"
					case 88 'suspended
					response.write "מושהה"
					case 99 'deleted
					response.write "מחוק"
					case else 'error
					response.write "שגיאה"
				End Select
			%></td>
	        <td class="role<%=res("role")%>" style="vertical-align:top; text-align:right;">
	            <a href="../profile.asp?id=<%=res("id")%>" target="profile<%=res("id")%>">
					<%=res("name")%> <small>(<%if res("gender")=1 then %>M<% else %>F<%end if%>)</small>
				</a></td>
			<td dir="ltr"><%=res("userName")%></td>
			<td dir="ltr"><%=res("eMail")%></td>
			<td class="role<%=res("role")%>" style="text-align:center;"><%=res("role")%></td>
	        <td dir="ltr"><a href="userEdit.asp?id=<%=res("id")%>"><div>עריכה</div></a></td>
	    </tr><%
	    res.movenext
	loop %>
</table><%
'closeDB
closeDbLogger "arabicUsers","C","userControl.asp","single",durationMs,""
%>
</div>
</body>
</html>
