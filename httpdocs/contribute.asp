<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>תמיכה בפרויקט המילון</title>
	<meta name="Description" content="איך אתם יכולים לעזור לנו לצמוח ולהשתפר" />
<!--#include file="inc/header.asp"-->
    <style>
        h1 {
            display:inline-block;
            font-size:large;
        }
        .month {max-width:90%; width:600px; margin:20px auto; background:white; box-shadow: grey 1px 1px 3px; padding:10px;}
        .month table {margin:0 auto; font-size:small; margin-top:20px;}
        .month p {font-size:small;}
        .monthTitle {font-size:2em; font-weight:bold;}
        .income {font-size:1.5em;}
        #pTitle {
            font-size:large;
        }
        .prcnt {font-size:small;}
        .incomeTable {width:100%; text-align:center; }
        .incomeTable td {
            background:#e7f3ef;
            border:1px solid gray;
            padding:5px;
            }

        .w3-light-grey {color:#000!important;background-color:#f1f1f1!important;}
        .w3-round-xlarge {border-radius:16px;}
        .xw3-container {padding:0.01em 16px;}
        .w3-container:after,.w3-container:before {content:"";display:table;clear:both;} 
        .w3-blue {color:#fff!important;background-color:#2196F3!important;}

        @media (min-width:1000px) {
            .flex-container {
                display:flex;
                border:0px solid black;
                justify-content: center;
            }

            .sctRight,.sctLeft {
                flex: 1;
                max-width:500px;
            }
        }
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">
    <h1>תמיכה בפרויקט המילון</h1>
    // <a href="contribute.english.asp">English</a>
</div>
<main class="flex-container">
    <section class="sctRight">
        <div class="table divStats" style="text-align:right;padding:15px 15px; max-width:460px;">
            <h2>דרכים להעברת כסף</h2>
            <ol>
                <li>
                    <u><b>תרומה חודשית קבועה</b></u>
                    <br>לתרומה חודשית קטנה מוזמנים להכנס לדף ה"פטראון" שלנו:
                    <br><br>
                    <button onclick="window.open('https://www.patreon.com/arabic4hebs','patreon')">לדף המילון באתר Patreon</button>
                    <br><br>
                </li>
                <li>
                    <u><b>תרומה חד פעמית</b></u>
                    <br>פתחתי חשבון בנק יעודי לטובת הפרויקט.
                    <br>כל סכום יתקבל בברכה, אך שימו לב כי לרוב עמלת ההעברה זהה, כך שאין טעם להעביר סכומים נמוכים מאוד.
                    <br>
                    <br><i>בנק הפועלים</i>
                    <br><i>מספר בנק: 12</i>
                    <br><i>מספר סניף: 559</i>
                    <br><i>מספר חשבון: 362609</i> 
                    <br><i>חשבון על שם רונן רוטפרב</i>
                    <br>
                    <br>קוד IBAN למעבירים מחוץ לישראל:
                    <br><i>IL220125590000000362609</i>
                    <br><br>
                </li>
                <li>
                    <u><b>פירסום באתר</b></u>
                    <br>הפרסום מיועד בעיקר לבתי ספר ומורים פרטיים לערבית.
                    <br>אתם מרוויחים פרסום ממוקד לקהילת לומדי הערבית בארץ
                    <br>והמילון מרוויח הכנסה לטובת המשך הפעילות
                    <br><br>
                    <button onclick="window.location.assign('advertise.asp','advertise')">למחירון ופרטים נוספים</button>
                    <br>* לצפייה מהמחשב
                </li>
            </ol>
            <h2>מדוע אני מבקש תמיכה כלכלית</h2>
            <p>מאז 2006 השתדלתי לא להכניס כסף לתמונה. בשלב מסוים הכנסתי פרסומת גוגל בודדת, וכך כיסיתי את עלויות האתר הבסיסיות.
            כעת, 14 שנים לתוך הפרויקט (2020), עם גרעין מתנדבים שלהוט לתרום, ועם מצבור ענק של רעיונות לשיפור המילון וכלים חדשים נוספים,
            החלטתי לנסות ולהפוך את ניהול, תחזוקה והפקת התכנים למילון לעיסוק העיקרי שלי.
            </p>

            <button onclick="window.location.href='team.tasks.asp'">משימות ורעיונות</button>

            <p>מטרתי הנוכחית היא לגייס מספיק תומכים קבועים, כדי שאוכל להתפרנס בכבוד ולעבוד בראש שקט על הפרויקט.</p>

            <br>
            <h2>מהו הפרויקט?</h2>
            <p>בשנת 2006 נוסד <b>'מילון ערבית מדוברת - לדוברי עברית'</b>, שהיה המילון המקוון החינמי הראשון לערבית מדוברת שהציג את המילים הערביות בתעתיק עברי.
            </p>

            <p>כיום נדיר למצוא בישראל לומדי ערבית מדוברת שלא מכירים את המילון. 
            <span style="font-size:small;">במהלך 2019 היו 614,000 כניסות למילון ו-3,000,000 צפיות בדפים שונים.</span>
            </p>

            <h3>קהילה יוצרת</h3>
            <ul>
                <li>כל אחד יכול להצטרף כמשתמש ולהוסיף מילים חסרות</li>
                <li>משתמשים מנוסים מאשרים את המילים החדשות</li>
                <li>דוברי ערבית שפת אם מקליטים מילים ומשפטים לדוגמא</li>
                <li>וכן הלאה...</li>
            </ul>

            <img style="width:100%;" src="https://rothfarb.info/ronen/arabic/img/patreon/2018-07-23%20-%20CANVA%20Timeline%20Infographic.png" title="דברים שעשינו"/>
        </div>
    </section>
    <br>
    <section class="sctLeft">
        <div class="table divStats" style="text-align:right;padding:15px; max-width:460px;">
            <h2>סטטוס הכנסות</h2>
            
            <div style="margin:0 auto;padding:5px; max-width:460px; text-align:center;">
                <div style="background:#ffff0080; padding:8px; border-radius:8px; color:black;">ההכנסות לפני עמלות האתרים, הבנקים ומסים בהתאם לחוק</div>
                <br>עדכון אחרון - 15 בפברואר 2022
            </div><%
            dim goal,income,prcnt,prcntBar,monthInfo,monthsArr
            dim monthsArray(),monthsCNT
            goal = 5300
            monthsCNT = 25 'CHANGE MANUALLY EACH MONTH!
            redim monthInfo(5) 'number of elemnts in each month (YYYY-MM,total income,patreon,bank Transfers,Ads(google and direct))
            redim monthsArray(monthsCNT) 'Number of months

            'ADD MANUALLY EACH MONTH!
            'monthsExample(x) = "YYYY-MM,total(nis),patreon($),bank(nis),ads(nis)"

            monthsArray(25) = "2022-01,1450,92,350,800"

            monthsArray(24) = "2021-12,844,80,50,546"
            monthsArray(23) = "2021-11,1400,81,350,800"
            monthsArray(22) = "2021-10,760,90,300,180"
            monthsArray(21) = "2021-09,708,67,0,500"
            monthsArray(20) = "2021-08,1508,65,0,1300"
            monthsArray(19) = "2021-07,1701,63,0,1500"
            monthsArray(18) = "2021-06,1160,50,0,1000"
            monthsArray(17) = "2021-05,1671,38,0,1550"
            monthsArray(16) = "2021-04,599,60,100,304"
            monthsArray(15) = "2021-03,600,62,0,400"
            monthsArray(14) = "2021-02,1820,60,1250,372"
            monthsArray(13) = "2021-01,1247,31,710,435"

            monthsArray(12) = "2020-12,1555,28,1000,465"
            monthsArray(11) = "2020-11,995,16,500,442"
            monthsArray(10) = "2020-10,7671,16,7175,442"
            monthsArray(9) = "2020-09,522,13,0,477"
            monthsArray(8) = "2020-08,701,16,290,357"
            monthsArray(7) = "2020-07,808,15,300,458"
            monthsArray(6) = "2020-06,388,15,10,327"
            monthsArray(5) = "2020-05,722,25,310,326"
            monthsArray(4) = "2020-04,493,25,120,285"
            monthsArray(3) = "2020-03,473,25,60,313"
            monthsArray(2) = "2020-02,695,16,260,380"
            monthsArray(1) = "2020-01,449,3,40,399" 

            dim i
            'for i = monthsCNT to 1 Step -1
            for i = monthsCNT to monthsCNT-9 Step -1
                monthsArr = monthsArray(i)
                monthInfo = Split(monthsArr,",")

                income = monthInfo(1)
                prcnt = round((income*100)/goal)
                if prcnt>100 then prcntBar=100 else prcntBar=prcnt %>
                <div class="month">
                    <p><span class="monthTitle"><%=monthName(month(monthInfo(0)))%></span><span class="income"> - <%=formatNumber(income,0)%> ש"ח</span> [<span class="prcnt"><%=prcnt%>% משכר המינימום]</span></p>
                    <div class="w3-light-grey w3-round-xlarge">
                        <div class="w3-container w3-blue w3-round-xlarge" style="width:<%=prcntBar%>%"><span style="padding-right:8px;"><%=prcnt%>%</span></div>
                    </div>
                    <table class="incomeTable">
                        <tr>
                            <td><a href="https://www.patreon.com/arabic4hebs" target="patreon">תמיכת קהילה <br>Patreon<br><%=monthInfo(2)%>$</a></td>
                            <td>תמיכת קהילה<br>העברות בנקאיות<br><%=formatNumber(monthInfo(3),0)%> ש"ח</td>
                            <td><a href="advertise.asp">פירסום<br><%=monthInfo(4)%> ש"ח</a></td>
                        </tr>
                    </table>
                </div><%
            next %>
        </div>
    </section>
</main>
<br>
<div style="text-align:center;padding:15px; max-width:920px; margin:0 auto;">
    <p style="text-align:center; margin:50px 0px;">
        אם יש לכם שאלות כלשהן, מוזמנים לפנות אלי במייל
        <br>arabic4hebs@gmail.com
        <br>
        <br>תודה רבה על זמנכם!
        <br>רונן רוטפרב
        <br>
        <br><img src="img/site/ronen.jpg" title="רונן" style="max-width:260px; border-radius:10px;"  />
    </p>
</div>
<!--#include file="inc/trailer.asp"-->