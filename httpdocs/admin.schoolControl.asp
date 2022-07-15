<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" %>
<!DOCTYPE html>
<html>
<head>
	<title>ניהול בתי ספר</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
    <style>
        .edit {opacity:0; padding: 0 5px;}
        .trow:hover .edit {opacity: 1;}
        .trow {display: table-row; line-height: 1.4em;}
        .trow > div {display: table-cell; border-bottom:1px solid gray;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div class="view">
    <a href="admin.asp">חזרה לדף ניהול הראשי</a>
	<h2>ניהול בתי ספר</h2>
    <div style="margin:0 auto 10px auto; border: 1px solid gray; border-radius: 3px; max-width: 300px; font-size:larger; padding: 10px;">
        <a href="admin.schoolNew.asp">הוסף בית ספר לרשימה</a>
    </div><%


startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","admin.schoolControl.asp","single",""

mySQL = "SELECT * FROM schools ORDER BY type,school"
res.open mySQL, con %>

    <div style="display:table; text-align:right; border:2px solid gray; padding: 10px; margin:0 auto;">
        <div class="trow">
            <div></div>
            <div>שם בית הספר</div>
            <div>תגליין</div>
            <div style="padding:0 5px; text-align:center;">סוג</div>
            <div style="padding:0 5px;">נציג</div>
        </div><%
        do until res.EOF %>
    	    <div class="trow">
                <div class="edit"><a href="admin.schoolEdit.asp?id=<%=res("id")%>">ערוך</a></div>
    	        <div style="padding-left: 15px;font-size:large;"><%=res("school")%></div>
    	        <div style="padding-left: 5px;"><%=res("tagline")%></div>
    	        <div style="padding:0 5px; text-align:center; border-right: 1px dotted gray;"><%
                    SELECT CASE res("type")
                        case 1
                            response.write "רגיל"
                        case 2
                            response.write "אינטרנטי"
                        case 3
                            response.write "מורה פרטי/ת"
                        case 99
                            response.write "אחר"
                        case else
                            response.write "error"
                    END SELECT %></div>
    	        <div style="text-align:center; border-right: 1px dotted gray;">
                    <%=res("adminID")%>
                </div>
    	    </div><%
    	    res.movenext
    	loop %>
    </div><%
    res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSchools","C","admin.schoolControl.asp","single",durationMs,""

%>
</div>
</body>