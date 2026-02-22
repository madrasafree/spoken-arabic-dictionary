<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" %>
<!DOCTYPE html>
<html>
<head>
	<title>ניהול נושאים</title>
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
    <a href="admin.asp">חזרה לדף ניהול ראשי</a>
    <h2>ניהול נושאים</h2><%


'openDB "arabicWords"
openDbLogger "arabicWords","O","admin.labelControl.asp","single",""

    mySQL = "SELECT * FROM labels ORDER BY labelName"
    res.open mySQL, con %>
    <div style="display:table; text-align:right; border:2px solid gray; padding: 10px; margin:0 auto; min-width: 300px;">
        <div class="trow">
            <div></div>
            <div style="text-align:center;">מס"ד</div>
            <div>נושא</div>
        </div><%
        do until res.EOF %>
    	    <div class="trow">
                <div class="edit"><a href="admin.labelEdit.asp?id=<%=res("id")%>">ערוך</a></div>
    	        <div style="text-align:center;"><%=res("id")%></div>
    	        <div>
                    <%=res("labelName")%>
                </div>
    	    </div><%
    	    res.movenext
    	loop %>
    </div><%
    res.close

'closeDB
closeDbLogger "arabicWords","C","admin.labelControl.asp","single",durationMs,""


%>
<form action="admin.labelNew.insert.asp">
    <div style="margin:10px auto 10px auto; border: 1px solid gray; border-radius: 3px; max-width: 300px; font-size:larger; padding: 10px;">
    <input type="text" name="labelNew">
    <button type="submit">הוסף נושא</button>
    </div>
</form>
</div>
</body>