<!--#include file="inc/inc.asp"--><%
    '1=ronen ; 73=yaniv ; 77=hadar ; 103 = ran ; 118 = noam ; 129 = sharon'
    if not (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=103 or session("userID")=118 or session("userID")=129) then Response.Redirect "login.asp" 
    

openDB "arabicUsers"
    'Checks if READ ONLY mode is Enabled
    mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readonly'"
    res.open mySQL, con
    if res(0) = true then
        session("msg") = "אין כרגע אפשרות לערוך מידע במסד הנתונים. אנא נסו שנית מאוחר יותר"
        Response.Redirect Request.ServerVariables("HTTP_REFERER")
    end if
    res.close
closeDB    
    
    %>

<!DOCTYPE html>
<html>
<head>
	<title>הוספת מדיה חדשה</title>
    <meta name="robots" content="none">
<!--#include file="../inc/header.asp"-->
    <style>
        .mediaTable > div {margin-bottom: 10px;}
    </style>
</head>
<body>
<!--#include file="../inc/top.asp"-->
<!--#include file="inc/topTeam.asp"-->
<div id="dashboard">
    <div id="pTitle"><h1>הוספת מדיה חדשה</h1></div>

    <form action="mediaNew.insert.asp">
    <div class="mediaTable">
        <div>סוג המדיה
            <div>
                <select dir="ltr" name="mType" autofocus>
                    <option value="empty"> - </option>
                    <option value="1">YouTube</option>
                    <option value="21">clip.it</option>
                    <option value="22">soundcloud</option>
                </select>
            </div>
        </div>
        <div>הקוד הייחודי של המדיה
            <div style="font-size:small;">לדוגמא: https://www.youtube.com/watch?v=<span style="font-size:medium; font-weight: bold;">fhfIpUgxgm8</span></div>
            <div><input type="text" name="mLink" required /></div>
        </div>
        <div>תעתיק של מה שנאמר (Description)
            <div><input type="text" name="mDesc" required/></div>
        </div>
        <div>של מי הזכויות (Credit)
            <div><input type="text" name="credit" required/></div>
        </div>
        <div>קישור אליו נגיע בלחיצה על השדה הקודם (Credit Link)
            <div><input type="text" name="creditLink" /></div>
        </div>
        <div>אם הדובר קיים כמשתמש, קשרו אליו (Speaker)
            <div>
                <select name="speaker">
                    <option value=""> - </option><%

                'openDB "arabicUsers"
                openDbLogger "arabicUsers","O","mediaNew.asp","single",""
                
                mySQL = "SELECT id,username FROM users ORDER BY [username]"
                res.open mySQL, con 
                do until res.EOF %>
                    <option value="<%=res("id")%>"><%=res("username")%></option><%
                    res.movenext
                loop
                res.close 
                
                'closeDB
                closeDbLogger "arabicUsers","C","mediaNew.asp","single",durationMs,""

                %>
                </select>
            </div>
        </div>
        <button type="submit" style="margin-top:20px;">יאללה</button>
    </div>
    </form>

</div>
<!--#include file="inc/trailer.asp"-->
</body>
</html>