<!--#include file="inc/inc.asp"--><%
dim timeServer, isoUTC


startTime = timer()
'openDB "arabicSandbox"
openDbLogger "arabicSandbox","O","TEST.time.asp","single",""

mySQL = "SELECT now()"
res.open mySQL, con
    timeServer = res(0)
res.close

' mySQL = "SELECT isoUTC FROM timez WHERE id=7"
' res.open mySQL, con
'     isoUTC = res(0)
' res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSandbox","C","TEST.time.asp","single",durationMs,""


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

    <div>
    <br/>השעה כעת בשרת באריזונה / או בשרת המקומי במחשב
    <br/><%=timeServer%>
    <br/>
    <br/>תוספת 3 שעות
    <br/><%=DateAdd("h",3,timeServer)%>
    <br/>
    <br/>הזמן ברשומה מסוימת
    <br/><%=isoUTC%>
    <br/>
    <br/>הפרש זמנים במילים בין הזמן בשרת+3 לזמן ברשומה
    <br/>
    </div>

</div>
<!--#include file="inc/trailer.asp"-->