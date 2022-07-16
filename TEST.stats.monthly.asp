<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") < 6 then
session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
response.redirect "test.asp"
end if

dim nowUTC,monthX,yearX,dateX
dim wordsNew,wordsEdit,listsNew,listsEdit,sentenceNew,sentenceEdit,usersNew

monthX = request("month")
yearX = request("year")

if len(monthX)>0 and len(yearx)>0 then
    dateX = yearX + "-" + monthX
else
    yearX = "2021"
    monthX = "02"
    dateX = "2021-02"
end if



startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","TEST.stats.monthly.asp","words",""

    mySQL = "SELECT now() FROM words"
    res.open mySQL, con
        nowUTC = res(0)
        nowUTC = DateAdd("h",7,nowUTC)
    res.close

    mySQL = "SELECT COUNT(ID) FROM words WHERE LEFT(creationTimeUTC,7) = '"& dateX &"'"
    res.open mySQL, con
        wordsNew = res(0)
    res.close

    mySQL = "SELECT COUNT(*) FROM (SELECT DISTINCT word FROM history WHERE LEFT(actionUTC,7) = '"& dateX &"') AS cnt"
    res.open mySQL, con
        wordsEdit = res(0)
    res.close

    mySQL = "SELECT COUNT(ID) FROM lists WHERE LEFT(creationTimeUTC,7) = '"& dateX &"'"
    res.open mySQL, con
        listsNew = res(0)
    res.close

    mySQL = "SELECT COUNT(ID) FROM lists WHERE LEFT(lastUpdateUTC,7) = '"& dateX &"'"
    res.open mySQL, con
        listsEdit = res(0)
    res.close

    mySQL = "SELECT COUNT(ID) FROM sentences WHERE LEFT(creationTimeUTC,7) = '"& dateX &"'"
    res.open mySQL, con
        sentenceNew = res(0)
    res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","TEST.stats.monthly.asp","words",durationMs,""



startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","TEST.stats.monthly.asp","users",""

    mySQL = "SELECT COUNT(ID) FROM users WHERE LEFT(joinDateUTC,7) = '"& dateX &"'"
    res.open mySQL, con
        usersNew = res(0)
    res.close


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","TEST.stats.monthly.asp","users",durationMs,""

%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>סטטיסטיקה - סיכום חודשי</title>
	<meta name="Description" content="מידע וסטטיסטיקה על המילון והגלישה לאתר" />
    <style>
        ul {list-style:none; padding:0;}
        li {
            background:white;width: 210px;
            padding: 10px 0px;
            margin: 15px auto;
            border-radius: 20px;
            }
        label {font-size:2em; display:block; margin-top:10px;}
        .grow   { display:block; color:#539425; }

		.result0 {background:gray;}
		.result1 {background:#f9fff8; color:#63ad63;}
		.result2 {background:#ffe1ab; color: #b57a0c;}
		.result9 {background:#ffadad; color: #8c3f3f;}
		.result11 {background:#f9fff8; color:#313131;}
		.result21 {background:#ffe1ab; color:#313131;}
		.result91 {background:#ffadad; color:#313131;}


    </style>
    <!--#include file="inc/header.asp"-->
    <script>
        $(document).ready(function(){
            $("#month").val("09");
	    });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">סטטיסטיקה - סיכום חודשי</div>

<br />

<div class="table divStats" style="background:#1988cc26;">

    <form action="TEST.stats.monthly.asp" type="post">
        <select name="month">
            <option value="01" <%if monthX="01" then%>selected<%end if%>>ינואר</option>
            <option value="02" <%if monthX="02" then%>selected<%end if%>>פברואר</option>
            <option value="03" <%if monthX="03" then%>selected<%end if%>>מרץ</option>
            <option value="04" <%if monthX="04" then%>selected<%end if%>>אפריל</option>
            <option value="05" <%if monthX="05" then%>selected<%end if%>>מאי</option>
            <option value="06" <%if monthX="06" then%>selected<%end if%>>יוני</option>
            <option value="07" <%if monthX="07" then%>selected<%end if%>>יולי</option>
            <option value="08" <%if monthX="08" then%>selected<%end if%>>אוגוסט</option>
            <option value="09" <%if monthX="09" then%>selected<%end if%>>ספטמבר</option>
            <option value="10" <%if monthX="10" then%>selected<%end if%>>אוקטובר</option>
            <option value="11" <%if monthX="11" then%>selected<%end if%>>נובמבר</option>
            <option value="12" <%if monthX="12" then%>selected<%end if%>>דצמבר</option>
        </select>
        <select name="year">
            <option value="2021" <%if yearX="2020" then%>selected<%end if%>>2021</option>
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
openDbLogger "arabicSearch","O","TEST.stats.monthly.asp","search",""

    mySQL = "SELECT COUNT(searchTime) FROM latestSearched WHERE left(searchTime,7) = '"&dateX&"'"
    res.open mySQL, con
        sumMonth = FormatNumber(res(0),0)
    res.close %>
    <div>
        סך הכל נעשו <%=sumMonth%> חיפושים בחודש המבוקש
    </div><%
    mySQL = "SELECT TOP 11 COUNT(searchTime), typed, result FROM latestSearched INNER JOIN wordsSearched ON latestSearched.searchID = wordsSearched.id "&_
    "WHERE left(searchTime,7) = '"& dateX &"' GROUP BY typed, result ORDER BY COUNT(searchTime) DESC" %>
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
						<span class="result0">לא ידוע</span><%
					case 1 %>
						<span class="result1">תוצאה מדויקת ; משפט לדוגמא</span><%
					case 2 %>
						<span class="result2">תוצאות אחרות ; משפט לדוגמא</span><%
					case 9 %>
						<span class="result9">אין תוצאות בכלל ; משפט לדוגמא</span><%
					case 11 %>
						<span class="result11">תוצאה מדויקת ; אין משפט לדוגמא</span><%
					case 21 %>
						<span class="result21">תוצאות אחרות ; אין משפט לדוגמא</span><%
					case 91 %>
						<span class="result91">אין תוצאות בכלל ; אין משפט לדוגמא</span><%
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
    closeDbLogger "arabicSearch","C","TEST.stats.monthly.asp","search",durationMs,""
       
    
    %>
    </div>
    <div dir="ltr" style="text-align:left; font-size:small;">
        <%=mySQL%>
    </div>
</div>


<!--#include file="inc/trailer.asp"-->