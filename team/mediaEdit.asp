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

'openDB "arabicWords"
openDbLogger "arabicWords","O","mediaEdit.asp","media details",""


dim mediaID
mediaID = request("id")
mySQL = "SELECT * FROM media WHERE id = "&mediaID
res.open mySQL, con %>
<!DOCTYPE html>
<html>
<head>
	<title>עריכת מדיה קיימת</title>
    <meta name="robots" content="none">
<!--#include virtual="/inc/header.asp"-->
    <style>
        .mediaTable > div {margin-bottom: 10px;}
    </style>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include file="inc/topTeam.asp"-->
<div id="dashboard">
    <div id="pTitle"><h1>עריכת מדיה קיימת</h1></div>

    <form action="mediaEdit.update.asp">
    <input name="mID" value="<%=res("id")%>" style="display:none;" />
    <div class="mediaTable">
        <div>סוג המדיה
            <div>
                <select dir="ltr" name="mType" autofocus>
                    <option value="empty"> - </option>
                    <option value="1" <%if res("mType")=1 then%>SELECTED<%end if%>>YouTube</option>
                    <option value="21" <%if res("mType")=21 then%>SELECTED<%end if%>>clip.it</option>
                    <option value="22" <%if res("mType")=22 then%>SELECTED<%end if%>>soundcloud</option>
                    <option value="23" <%if res("mType")=23 then%>SELECTED<%end if%>>local ogg</option>
                </select>
            </div>
        </div>
        <div>הקוד הייחודי של המדיה
            <div style="font-size:small;">לדוגמא: https://www.youtube.com/watch?v=<span style="font-size:medium; font-weight: bold;">fhfIpUgxgm8</span></div>
            <div><input type="text" name="mLink" value="<%=res("mLink")%>" required /></div>
        </div>
        <div>תעתיק של מה שנאמר (Description)
            <div><input type="text" name="mDesc" value="<%=res("Description")%>" required/></div>
        </div>
        <div>של מי הזכויות (Credit)
            <div><input type="text" name="credit" value="<%=res("credit")%>" required/></div>
        </div>
        <div>קישור אליו נגיע בלחיצה על השדה הקודם (Credit Link)
            <div><input type="text" name="creditLink" value="<%=res("creditLink")%>" /></div>
        </div><%
dim speakerID
speakerID = res("speaker")
res.close


'closeDB
closeDbLogger "arabicWords","C","mediaEdit.asp","media details",durationMs,""

%>
        <div>אם הדובר קיים כמשתמש, קשרו אליו (Speaker)
            <div>
                <select name="speaker">
                    <option value=""> - </option><%

                'openDB "arabicUsers"
                openDbLogger "arabicUsers","O","mediaEdit.asp","speaker",""

                mySQL = "SELECT id,username FROM users ORDER BY [username]"
                res.open mySQL, con 
                do until res.EOF %>
                   <option <%if res("id")=speakerID then%>SELECTED<%end if%> value="<%=res("id")%>"><%=res("username")%></option><%
                    res.movenext
                loop
                res.close 

                'closeDB
                closeDbLogger "arabicUsers","C","mediaEdit.asp","speaker",durationMs,""

                %>
                </select>
            </div>
        </div>
        <button type="submit" style="margin-top:20px;">יאללה</button>
    </div>
    </form>

</div>
<!--#include virtual="/inc/trailer.asp"-->