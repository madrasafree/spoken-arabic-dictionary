<!--#include file="inc/inc.asp"--><%
dim timeServer


startTime = timer()
'openDB "arabicSandbox"
openDbLogger "arabicSandbox","O","TEST.time.OLD.asp","now",""

mySQL = "SELECT now()"
res.open mySQL, con
    timeServer=res(0)
    response.write timeServer
    'response.end
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSandbox","C","TEST.time.OLD.asp","now",durationMs,""

%>
<!DOCTYPE html>
<html>
<head>
    <title>Time Issues - TESTING PAGE</title>
    <meta name="robots" content="noindex" />
    <script type = "text/JavaScript" src ="https://MomentJS.com/downloads/moment-with-locales.js"></script>
    <!--#include file="inc/header.asp"-->
    <script>
        $(document).ready(function(){
            var d = new Date();
            document.getElementById("Date").innerHTML = "Date() = " + d;
            document.getElementById("getTime").innerHTML = "getTime() = " + d.getTime();
            document.getElementById("getTimezoneOffset").innerHTML = "getTimezoneOffset() = " + d.getTimezoneOffset();
            document.getElementById("toString").innerHTML = "toString() = " + d.toString();
            document.getElementById("toISOString").innerHTML = "toISOString() = " + d.toISOString();
            document.getElementById("toUTCString").innerHTML = "toUTCString() = " + d.toUTCString();

            // get current UTC time and display
            var nowUTC = d.toISOString().split('.')[0]+"Z"
           $(".nowUTC").html(nowUTC);

            var dateUTC = new Date(nowUTC);
            $(".inputUTC").each(function(index, element){
                var d2 =   new Date($(element).html());
                var m1 = moment(dateUTC), m2 = moment(d2);
                var diff = dateUTC-d2;
                var diffWords = diffUTC(diff, m1, m2);


                $(element).next().next().html(diff);
                // show time passed in words using moments.js

                $(element).next().next().next().html(diffWords);


            });

            function diffUTC(diff, m1, m2){

            if (diff > 259200000) {
                diffWords = "תאריך";
            } else {
                if (diff > 172800000) {
                    diffWords = "שלשום";
                } else {
                    if (diff > 86400000) {
                        diffWords = "אתמול";
                    } else {
                        if (diff > 10800000) {
                            diffWords = "לפני " + m1.diff(m2,'hours') + " שעות";
                        } else {
                            if (diff > 7200000) {
                                diffWords = "לפני שעתיים";
                            } else {
                                if (diff > 3600000) {
                                    diffWords = "לפני שעה";
                                } else {
                                    if (diff > 120000) {
                                        diffWords = "לפני " + m1.diff(m2,'minutes') + " דקות";
                                    } else {
                                        if (diff > 60000) {
                                            diffWords = "לפני דקה";
                                        } else {
                                            diffWords = "לפני " + m1.diff(m2,'seconds') + " שניות";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return diffWords;
            }

           

        });
    </script>
    <style>
    td,th {border:1px solid gray; padding:3px;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div style="max-width:800px;margin:0 auto;">
    <h1>תאריכים ושעות</h1>
    <p style="font-size:small;">
    מכיוון שישנם הפרשי השעות (שאינם קבועים) בין השרת בארה"ב לשעון המקומי בישראל או היכן שנמצא המשתמש,
    עושה רושם שהפתרון הוא לשמור תאריכים ב-UTC
    וכאשר רוצים להציג הפרש שעות, להציג את ההפרש בין השעה ששולפים ממסד הנתונים, מול השעה הנוכחית ב-UTC
    ולא השעה אצל הלקוח.
    </p>

    <div>השעה בשרת כעת (אריזונה) - 
    <br/><br/>
    </div>

    <table style="border:1px solid gray; font-size:small;">
        <tr>
            <th>שעה שנשלפה - UTC</th>
            <th>שעה נוכחית - UTC</th>
            <th>זמן שחלף - מילי-שניות</th>
            <th>זמן שחלף - במילים</th>
        </tr><%


    startTime = timer()
    'openDB "arabicSandbox"
    openDbLogger "arabicSandbox","O","TEST.time.OLD.asp","timez",""


    mySQL = "SELECT * FROM timez"
    res.open mySQL, con
    do until res.EOF %>
        <tr>
            <td class="inputUTC"><%=res("inputTimeUTC")%></td>
            <td class="nowUTC"></td>
            <td class="timePassed"></td>
            <td class="timePassedRelative"></td>
        </tr><%
        res.moveNext
    loop
    res.close

    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicSandbox","C","TEST.time.OLD.asp","timez",durationMs,""


    %></table>


    <div style="max-width:800px;margin:0 auto; color:red;">
        <ul><u>משימות</u>
            <li>עובד על שורה אחת. לאפשר על רצף שורות</li>
            <li>לעדכן מסד נתונים וקוד ולהתחיל לשמור תאריכים/שעות רק ב-UTC</li>
            <li>לבדוק עם אדם אם אפשר להחליף את התלות ב'מומנטס' בקוד של ג'אווה סקריפט</li>
            <li>אם לא, להוסיף לקוד במילון קישור בהתאם - https://momentjs.com/guides/</li>
        <ul>
    </div>

    <br/>קישור למידע על - <u><a href="https://en.wikipedia.org/wiki/ISO_8601">ISO 8601</a></u>

    <h2>JS</h2>

    <div id="Date">Date</div>
    <sub>JavaScript stores dates as number of milliseconds since January 01, 1970, 00:00:00 UTC (Universal Time Coordinated).</sub>
    <div id="getTime">getTime</div>
    <div id="getTimezoneOffset">getTimezoneOffset</div>
    <div id="toString">toString</div>
    <div id="toISOString">toISOString</div>
    <div id="toUTCString">toUTCString</div>
</div>



<script type ="text/javascript">
    function checkTime(i) {
        if (i < 10) {
            i = "0" + i;
        }
        return i;
        }

        function startTime() {
            var today = new Date();
            var h = today.getHours();
            var m = today.getMinutes();
            var s = today.getSeconds();
            // add a zero in front of numbers<10
            m = checkTime(m);
            s = checkTime(s);
            document.getElementById('time').innerHTML = h + ":" + m + ":" + s;
            t = setTimeout(function() {
                startTime()
            }, 500);
        }

        startTime();
</script>
<!--#include file="inc/trailer.asp"-->