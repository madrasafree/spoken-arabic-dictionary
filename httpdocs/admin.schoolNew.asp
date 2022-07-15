<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" %>
<!DOCTYPE html>
<html>
<head>
	<title>הוספת בית ספר חדש</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body>
<div style="width:600px;margin:0px auto; text-align:center;">
<h1>הוספת בית ספר חדש</h1>
<form action="admin.schoolNew.insert.asp" method="post" >
    <table class="tableA">
	    <tr>
	    	<td>שם בית הספר:</td>
	    	<td><input name="school" autofocus required /></td>
    	</tr>
	    <tr>
	    	<td>תאגליין / סלוגן:</td>
	    	<td><input name="tagline" /></td>
    	</tr>
	    <tr>
	    	<td>סוג:</td>
	    	<td>
                <select name="type">
                    <option value="1">בית ספר רגיל</option>
                    <option value="2">אינטרנטי</option>
                    <option value="3">מורה פרטי</option>
                    <option value="99">אחר (ארגון / מוסד)</option>
                </select>
	    	</td>
    	</tr>
	    <tr>
	    	<td>נציג:</td>
	    	<td>
                <select dir="ltr" name="schoolAdmin">
                <option value="0"> - </option><%

				startTime = timer()
				'openDB "arabicUsers"
				openDbLogger "arabicUsers","O","admin.schoolNew.asp","single",""

                mySQL = "SELECT id, username FROM users ORDER BY username"
                res.open mySQL, con
                do until res.EOF %>
                    <option value="<%=res("id")%>" style="font-size:large;"><%=res("username")%></option><%
                    res.movenext
                loop
                res.close

				endTime = timer()
				durationMs = Int((endTime - startTime)*1000)
				'closeDB
				closeDbLogger "arabicUsers","C","admin.schoolNew.asp","single",durationMs,""

				%>
                </select>
            </td>
    	</tr>
	    <tr>
	    	<td>אתר אינטרנט</td>
	    	<td><input name="website" /></td>
		</tr>
	    <tr>
	    	<td>פייסבוק</td>
	    	<td><input name="facebook" /></td>
    	</tr>
        <tr>
        	<td>דוא"ל</td>
	    	<td><input name="email" type="email" /></td>
        </tr>
        <tr>
        	<td>טלפון</td>
	    	<td><input name="phone" /></td>
        </tr>
        <tr>
        	<td>קישור ללוגו</td>
        	<td><input name="logo" /></td>
        </tr>
    </table>
    <p style="margin-top:35px;"><input type="submit" value="הוסף" style="padding: 10px 20px; font-size:larger;" /></p>
    <p><a href="admin.schoolControl.asp">חזרה ללא שמירה</a></p>
</form>
</div>
</body>