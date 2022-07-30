<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <title>ארגז חול</title>
	<meta name="Description" content="כל הדברים שאנחנו מנסים במילון, לפני שהם רשמית נכנסים" />
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
</head>
<body>
<!--#include file="inc/top.asp"-->


<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
    <h1>ארגז חול</h1>
</div>

<div class="message informative">
    ארגז חול הוא המקום שלנו לשחק ולנסות דברים חדשים
</div>

<ul style="max-width:600px; margin:0 auto;">
    <h2>זמין לכולם</h2>
    <li><a href="TEST.audioPlayer.asp">השמעת סאונד</a></li>
    <li><a href="sentence.asp?sID=1">משפט</a></li>
    <li><a href="sentences.asp">משפטים</a></li>
    <li><a href="dashboard.asp">דף שליטה</a></li>
    <li><a href="TEST.relations.asp">רשימת קשרים בין מילים</a></li>
    <li><a href="TEST.ruby.asp">Ruby RT RP (HTML TAGS)</a></li>
    <li><a href="TEST.video.asp">וידאו</a></li>
    <li><a href="TEST.time.asp">time</a></li>
    <li><a href="TEST.time.OLD.asp">time OLD</a></li>
    <li><a href="TEST.time.server.asp">time.server</a></li>
    <li><a href="TEST.stats.monthly.asp">סטטיסטיקה חודשית</li>
    <li><a href="TEST.design.asp">עיצוב</a></li>
    <li><a href="TEST.list.auto.asp">רשימות אוטומטיות</a></li>
</ul>

<ul style="max-width:600px; margin:0 auto;">
    <h2>מוגבל לבעלי הרשאה מתאימה</h2>
    <li><a href="test.api.asp">api</a></li>
    <li><a href="defaultBetaRun.asp">דף ראשי - שיפור ביצועים</a></li>
    <li><a href="admin.searchHistory.asp">ניתוח היסטורית חיפושים</a></li>
    <li><a href="TEST.stats.monthly.asp">מידע חודשי</a></li>
    <li><a href="TEST.stats.yearly.asp">מידע שנתי</a></li>
    <li><a href="TEST.feedback.asp">פידבק</a></li>
    <li><a href="TEST.fblogin.asp">הרשמה / לוג-אין עם פייסבוק</a></li>
    <li><a href="TEST.list.pics.asp">תצוגת כל התמונות</a></li>
    <li><a href="TEST.songs.asp">שירים</a></li>
    <li><a href="TEST.songs.TUNA.asp">שירים - tuna</a></li>
    <li><a href="TEST.db4devs.asp">db4dev</a></li>
    <li><a href="TEST.ssl.asp">ssl</a></li>
    <li><a href="TEST.sql.asp">sql [stopped]</a></li>
    <li><a href="TEST.comments.asp">Comments: Disqus, Facebook</a></li>
    <li><a href="TEST.emailTimer.asp">מייל מתוזמן</a></li>
</ul>


<!--#include file="inc/trailer.asp"-->