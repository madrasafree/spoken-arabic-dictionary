<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") < 6 then
session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
response.redirect "test.asp"
end if

dim nowUTC,yearX,dateX
dim wordsNew,wordsEdit,listsNew,listsEdit,sentenceNew,sentenceEdit,usersNew

yearX = request("year")

if len(yearx)>0 then
    dateX = yearX
else
    dateX = "2021"
end if


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","TEST.stats.yearly.asp","words",""

    mySQL = "SELECT now() FROM words"
    res.open mySQL, con
        nowUTC = res(0)
        nowUTC = DateAdd("h",4,nowUTC)
    res.close

    mySQL = "SELECT COUNT(ID) FROM words WHERE LEFT(creationTimeUTC,4) = '"& dateX &"'"
    res.open mySQL, con
        wordsNew = res(0)
    res.close

    mySQL = "SELECT COUNT(*) FROM (SELECT DISTINCT word FROM history WHERE LEFT(actionUTC,4) = '"& dateX &"') AS cnt"
    res.open mySQL, con
        wordsEdit = res(0)
    res.close

    mySQL = "SELECT COUNT(ID) FROM lists WHERE LEFT(creationTimeUTC,4) = '"& dateX &"'"
    res.open mySQL, con
        listsNew = res(0)
    res.close

    mySQL = "SELECT COUNT(ID) FROM lists WHERE LEFT(lastUpdateUTC,4) = '"& dateX &"'"
    res.open mySQL, con
        listsEdit = res(0)
    res.close

    mySQL = "SELECT COUNT(ID) FROM sentences WHERE LEFT(creationTimeUTC,4) = '"& dateX &"'"
    res.open mySQL, con
        sentenceNew = res(0)
    res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","TEST.stats.yearly.asp","words",durationMs,""



startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","TEST.stats.yearly.asp","users",""


    mySQL = "SELECT COUNT(ID) FROM users WHERE LEFT(joinDateUTC,4) = '"& dateX &"'"
    res.open mySQL, con
        usersNew = res(0)
    res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","TEST.stats.yearly.asp","users",durationMs,""


%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>סטטיסטיקה - סיכום שנתי</title>
	<meta name="Description" content="מידע וסטטיסטיקה על המילון והגלישה לאתר" />
    <style>
        .divStats ul {
            list-style:none;
            padding:0;}
        .divStats li {
            background: white; 
            border-radius: 20px;
            margin: 15px auto;
            padding: 10px 0px;
            width: 210px;
            }
        .divStats label {font-size:2em; display:block; margin-top:10px;}
        .grow   { display:block; color:#539425; }
    </style>
    <!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="pTitle">סטטיסטיקה - סיכום שנתי</div>
<br />
<div class="table divStats" style="background:#1988cc26;">

    <form action="TEST.stats.yearly.asp" type="post">
        <select name="year">
            <option value="2022" <%if yearX="2022" then%>selected<%end if%>>2022</option>
            <option value="2021" <%if yearX="2021" then%>selected<%end if%>>2021</option>
            <option value="2020" <%if yearX="2020" then%>selected<%end if%>>2020</option>
            <option value="2019" <%if yearX="2019" then%>selected<%end if%>>2019</option>
            <option value="2018" <%if yearX="2018" then%>selected<%end if%>>2018</option>
            <option value="2017" <%if yearX="2017" then%>selected<%end if%>>2017</option>
            <option value="2016" <%if yearX="2016" then%>selected<%end if%>>2016</option>
            <option value="2015" <%if yearX="2015" then%>selected<%end if%>>2015</option>
            <option value="2014" <%if yearX="2014" then%>selected<%end if%>>2014</option>
            <option value="2013" <%if yearX="2013" then%>selected<%end if%>>2013</option>
        </select>
        <button type="sumbit">הצג</button>
    </form>
    <ul>
        <li><label><%=wordsNew%></label>מילים נוספו</li>
        <li><label><%=wordsEdit%></label>מילים נערכו</li>
        <li><label><%=listsNew%></label>רשימות נוספו</li>
        <li><label><%=listsEdit%></label>רשימות נערכו</li>
        <li><label><%=sentenceNew%></label>משפטים נוספו</li>
        <li>משפטים נערכו</li>
        <li><label><%=usersNew%></label>נרשמים חדשים</li>
    </ul>
</div>

<div><%
    dim sumMonth

    startTime = timer()
    'openDB "arabicSearch"
    openDbLogger "arabicSearch","O","TEST.stats.yearly.asp","search",""

    mySQL = "SELECT COUNT(searchTime) FROM latestSearched WHERE left(searchTime,4) = '"&dateX&"'"
    res.open mySQL, con
        sumMonth = FormatNumber(res(0),0)
    res.close %>
    <div>
        סך הכל נעשו <%=sumMonth%> חיפושים בחודש המבוקש
    </div><%
    mySQL = "SELECT TOP 10 COUNT(searchTime), typed, result FROM latestSearched INNER JOIN wordsSearched ON latestSearched.searchID = wordsSearched.id "&_
    "WHERE left(searchTime,4) = '"& dateX &"' GROUP BY typed, result ORDER BY COUNT(searchTime) DESC" %>
    <div class="tbl">
        <div>
            <span>מה חיפשו</span>
            <span>כמה פעמים חיפשו</span>
            <span>
        </div><%
    res.open mySQL, con
    do until res.EOF %>
        <div>
            <span><%=res("typed")%></span>
            <span><%=res(0)%></span><%
            SELECT CASE res("result")
                case 0 %>
                    <span style="background:gray;">לא ידוע</span><%
                case 1 %>
                    <span style="color:green;">תוצאה מדויקת</span><%
                case 2 %>
                    <span style="background:#ffa5003d;">תוצאות אחרות</span><%
                case 9 %>
                    <span style="background:#ff000052;">אין תוצאות בכלל</span><%
                case else %>
                    <span>-</span><%
            END SELECT %>
        </div><%
        res.moveNext
    loop
    res.close

    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicSearch","C","TEST.stats.yearly.asp","search",durationMs,""
    
    
    %>
    </div>
    <div dir="ltr" style="text-align:left; font-size:small;">
        <%=mySQL%>
    </div>
</div>


<!--#include file="inc/trailer.asp"-->