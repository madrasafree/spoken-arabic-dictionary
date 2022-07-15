<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" %>
<!DOCTYPE html>
<html>
<head>
	<title>ניהול קורסים</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"-->
<div class="view">
    <a href="admin.asp">חזרה לדף ניהול הראשי</a>
	<h2>ניהול קורסים</h2><%


startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","admin.courseControl.asp","single",""

    mySQL = "SELECT * FROM courses LEFT JOIN schools ON courses.school=schools.id ORDER BY startDate DESC"
    res.open mySQL, con %>

<div style="text-align:left; font-size:large; text-decoration:underline; margin-bottom:10px;"><a href="courseNew.asp">הוספת קורס</a></div>
<table border="1" style="font-size:small;">
    <tr>
        <td>ID</td>
        <td>Start Date</td>
        <td>details</td>
        <td>edit</td>
    </tr><%
    do until res.EOF %>
	    <tr>
	        <td><%=res("courses.id")%></td>
	        <td><%=res("startDate")%></td>
            <td style="text-align:right;"><%=res(3)%>
                <br/>source : <%=res("source")%>
                <br/>sourceLink :
                <br/><%=res("sourceLink")%>
            </td>
	        <td>
        		<span style="float:left;"><a href="courseEdit.asp?id=<%=res("courses.id")%>">edit</a>
        		</span>
	        </td>
	    </tr><%
	    res.movenext
	loop %>
</table> <%
    res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSchools","C","admin.courseControl.asp","single",durationMs,""
 %>
</div>
</body>