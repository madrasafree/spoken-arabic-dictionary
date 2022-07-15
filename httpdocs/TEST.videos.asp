<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <title>ארגז חול - סרטונים של המילון</title>
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
    <style>
        h2 {
            margin:0;
        }
        label {
            display:none;
        }
        ol {
            padding:0;
        }
        ol img {
            max-width:45%;
        }
        ol li {
            display:inline;
        }
        section {
            background:#ffffff80;
            border:1px dotted gray;
            border-radius:10px;
            margin:10px auto;
            padding:10px;
            text-align:center;
            }
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<main style="max-width:800px; margin:0 auto;">

<nav id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ארגז חול</a> / 
	<h1>סרטונים של המילון</h1>
</nav>

<div style="text-align:center;font-size:2em; font-weight:bold; margin-top:10px;">סרטוני תוכן מקוריים</div>
<div style="max-width:600px; margin:0 auto;">
    <p style="text-align:center;">מטרת הסרטונים שלפניכם היא לאפשר לקהילת לומדי הערבית המדוברת בישראל לשמוע ערביות וערבים מרחבי הארץ, מדברים בשפה יום יומית מול המצלמה.</p>
    <p style="text-align:center;">לכל סרטון 4 רצועות של כתוביות: ערבית, תעתיק, עברית ואנגלית. העזרו בהם בהתאם לרמתכם.</p>
</div>

<section>
    <h2>
        <span class="arb harm">أكمّ سؤال</span> .
        <span class="arb keter">אַכַּם סֻאַאל</span> .
        <span class="heb">כמה שאלות</span>
    </h2>
    <p>אוסף של שאלות אקראיות וקלילות</p>
    <ol>
        <li>
            <img src="img/youtube/2019-01.png" title="במקור מרמאללה" />
        </li>
        <li>
            <img src="img/youtube/2019-02.png" title="במקור מג'לג'וליה" />
        </li>
        <li>
            <img src="img/youtube/2019-03.png" title="במקור מנצרת" />
        </li>
        <li>
            <img src="img/youtube/2019-04.png" title="במקור מאום אל פחם" />
        </li>
        <li>
            <a href="TEST.video.asp"><img src="img/youtube/2020-09.png" title="במקור מסחנין" /></a>
        </li>
    </ol>
</section>

<section>
    <h2>
        <span class="arb harm">في أَيَّام الكورونا</span> .
        <span class="arb keter">פי אַיַאם אלקורונא</span> .
        <span class="heb">ימי קורונה</span>
    </h2>
    <p>חברי המילון מספרים כיצד הם מעבירים את הזמן בימים טרופים אלה
    </p>
    <ol>
        <li>
            <img src="img/youtube/2020-01.png" />
        </li>
        <li>
            <img src="img/youtube/2020-02.png" />
        </li>
        <li>
            <img src="img/youtube/2020-03.png" />
        </li>
    </ol>
</section>

<div style="font-size:small; width:300px; text-align:center; margin:10px auto 40px auto;">
    <p>אהבתם? רוצים עוד? הרשמו לערוץ היו טיוב שלנו כדי שנדע שאתם רוצים עוד סרטונים, וכדי שאתם תדעו מתי הם יוצאים</p>
    <script src="https://apis.google.com/js/platform.js"></script>
    <div class="g-ytsubscribe" data-channelid="UCHnLvw-TCwckLXmjYozv9tw" data-layout="default" data-count="default">
    </div>
</div>


</main>
<!--#include file="inc/trailer.asp"-->