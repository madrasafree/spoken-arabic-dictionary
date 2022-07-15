<!--#include file="inc/inc.asp"--><% response.redirect "where2learn.schools.asp" %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title>קורסים קרובים - איפה ללמוד ערבית?</title>
	<meta name="Description" content="רשימת קורסים קרובים לערבית" />
    <meta name="Keywords" content="בתי ספר לערבית, איפה ללמוד ערבית, ערבית מדוברת, ערבית ספרותית, ערבית פלסטינית" />
<!--#include file="inc/header.asp"-->
    <style>
    .listDiv {padding:5px;}
    .listDiv:hover {cursor:default; background: none;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="pTitle">איפה ללמוד ערבית</div>
<!--#include file="inc/where2learn.menu.asp"-->
<div class="table"><%
    if session("role")>2 then %>
    <div style="width:100%;text-align:center;">
        <input onclick="location.href='team/courseNew.asp'" type="button" value="+" style="float:left;padding: 0px 35px; font-size:2em; font-weight:bold;" />
    </div><%
    end if %>
    <h1 id="courses">קורסים קרובים</h1><%
    openDB "arabicSchools"
    mySQL = "SELECT * FROM courses LEFT JOIN schools ON courses.school=schools.id WHERE startDate > now() AND cStatus=1 ORDER BY startDate"
    res.open mySQL, con
    if res.EOF then
        session ("msg") = "לא קיימים קורסים "
        response.redirect "where2learn.teachers.asp"
    else
        do until res.EOF %>
            <div dir="rtl" class="listDiv">
                <span style="float:left;font-size:small;text-align:left;"><%
                    SELECT case res("source")
                    case 1
                        response.write "נוסף על ידי נציג בית הספר"
                    case 2 %>
                        <a href="http://<%=res("sourceLink")%>" target="new">נאסף מאתר הבית ספר</a><%
                    case 3 %>
                        <a href="http://<%=res("sourceLink")%>" target="new">נאסף מפייסבוק</a><%
                    case else
                        response.write res("source")
                    end SELECT %>
                </span>
                <%=res("startDate")%><%if len(res("city"))>0 then%> - <%=res("city")%><%end if%>
                <div style="font-weight:bold;"><%=res("cTitle")%></div>
                <div style="font-size:small;"><%=res("schools.school")%><%

                    if len(res("tutor"))>0 then %>
                        [בהדרכת <%=res("tutor")%>]<%
                    end if %>
                </div>
                <div style="font-size:small;">
                <%
                    SELECT case res("level")
                        case 1
                        response.write "<br/>רמה : 1/5 (מתחילים)"
                        case 2
                        response.write "<br/>רמה : 2/5 (מתחילים / ממשיכים)"
                        case 3
                        response.write "<br/>רמה : 3/5 (ממשיכים)"
                        case 4
                        response.write "<br/>רמה : 4/5 (ממשיכים / מתקדמים)"
                        case 5
                        response.write "<br/>רמה : 5/5 (מתקדמים)"
                    end SELECT %>
                    <span style="display:none; background:#eeefd6; border:1px solid #d6d3b2; border-radius:50%; margin-right:5px; font-size:smaller; color:#7b7a36;" title="רמות הקורסים מיוצגים במספרים 1 עד 5, כאשר 1 מייצג את הקורס ההתחלתי ביותר ו-5 את המתקדם ביותר.">?</span><%
                    if res("meetings") then %>
                        <br/>מספר מפגשים : <%=res("meetings")%><%
                        if res("hours") then %>
                            (<%=res("hours")%> שעות כ"א)<%
                        end if 
                    end if

                    if len(res("days"))>0 then %>
                        <br/>ימי : <%
                        dim daysSP,daySP,cm
                        cm=""
                        daysSP=split(res("days"),",")
                        for each daySP in daysSP
                            response.write cm
                            cm=", "
                            SELECT case daySP
                                case 1 : response.write "ראשון"
                                case 2 : response.write "שני"
                                case 3 : response.write "שלישי"
                                case 4 : response.write "רביעי"
                                case 5 : response.write "חמישי"
                                case 6 : response.write "שישי"
                                case 7 : response.write "שבת"
                            end SELECT
                        next 
                    end if

                    
                    if len(res("city"))>0 then%>
                        <br/> כתובת : <%=res("address")%> / <%=res("city")%> <%
                        'SELECT case res("area")
                        '   case 1 : response.write "אזור המרכז"
                        '   case 2 : response.write "צפון הארץ"
                        '   case 3 : response.write "דרום הארץ"
                        'end SELECT
                    else %>
                        <br/> כתובת : לא צוינה כתובת. <%
                    end if
                    if res("price") then %>
                        <br/>עלות : <%=res("price")%> ש"ח<%
                    end if %><%

                    if len(res("info"))>0 then%>
                        <div>מידע נוסף : <%=res("info")%></div><%
                    end if 

                    if len(res("sourceLink"))>0 then %>
                        <div style="padding-top:10px;">
                            <a href="http://<%=res("sourceLink")%>" target="new">קישור למקור</a>
                        </div><%
                    end if

                    if session("role")>3 then %>
                        <div style="padding-top:10px;">
                            <a href="team/courseEdit.asp?cID=<%=res("courses.id")%>">ערוך פרטי קורס</a>
                        </div><%
                    end if
                     %>
                </div>
            </div><%
            res.movenext
        loop
        res.close
    end if %>

    <br/>
    <div class="listDiv" style="text-align:center; font-size:large;">
        רוצים להוסיף מידע לדף זה?
        <br /><a href="img/site/gmail.png" target="gmail"><span style="color:#ad1717;padding:0;">כיתבו לנו</span></a>
    </div>

</div>
<!--#include file="inc/trailer.asp"-->