<!--#include file="includes/inc.asp"--><%
if (session("role") and 2) = 0 then Response.Redirect "login.asp?returnTo=users.landingPage.asp" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="ROBOTS" content="NONE">
	<title>דף נחיתה משתמשים רשומים</title>
<!--#include file="includes/header.asp"-->
    <style>
        h2 {
            margin-bottom:0;
        }

        .userMenu {
            max-width:400px;
            margin:0 auto;
            border:0px solid gray;
        }

        .userMenu ul {
            list-style-type: none;
            padding: 4px;
            background: #cff0ff6b;
            margin: 4px 0;
            border: 1px solid #4191c261;
            border-radius: 10px 0;
        }

        .userMenu li {
            background:#ffffff88;
            border:1px solid #cccccc;
            border-radius:10px;
            display:inline-block;
            margin:5px;
            padding:5px 8px;
            width:fit-content;
        }

        .userMenu li:hover {
            background:#4191c2;
            color:white;
        }
    </style>
</head>
<body>
<!--#include file="includes/top.asp"-->
<h1 id="pTitle">תפריט משתמשים רשומים</h1>

<div class="table userMenu">


    <h2>האזור שלי</h2>
    <ul>
        <a href="profile.asp?id=<%=session("userID")%>"><li>הפרופיל שלי</li></a>
        <a href="login.asp?exit=1"><li style="background-color:#ffdada88; float:left;">יציאה</li></a>
    </ul>

    <h2>מדריכי שימוש</h2>
    <ul>
        <a href="welcome.asp"><li>ברוכים הבאים למילון</li></a>
        <a href="guideTeam.asp"><li>הוספת ועריכת מילים</li></a>
    </ul>

    <h2>תוכן</h2>
    <ul>
        <a href="dashboard.asp"><li>דף שליטה</li></a>
        <a href="activity.asp"><li>פעולות אחרונות</li></a>
        <a href="team/mediaControl.asp"><li>בנק מדיה</li></a>
    </ul>



</div>
<!--#include file="includes/trailer.asp"-->
</body>
</html>