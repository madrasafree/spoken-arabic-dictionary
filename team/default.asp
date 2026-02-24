<!--#include file="inc/inc.asp"--><%
if (session("role") and 2) = 0 then Response.Redirect "login.asp" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="ROBOTS" content="NONE">
	<title>דף צוות ראשי (זמני)</title>
<!--#include virtual="/inc/header.asp"-->
    <style>
        h1 {font-size:1em; margin:0;}
        h2 {font-size:1em;}
        #dashboard  { width:500px; margin:0 auto; }
        .new {background-color: white; text-align: center; font-size: 3em; cursor: pointer;border: rgb(186, 218, 246) 1px solid; border-radius: 30px; margin: 0 auto; width: 98%;}
        .new a:visited, .new a:link {color: rgb(65, 145, 194);}

        .stats20 {
            width:100%;
        }
        .stats20 td {
            border:darkgray 1px solid;
            padding:3px;
            text-align:center;
        }
        .stats20 td:nth-of-type(2) {
            background:white;
            color:#4a4848;
        }
        .stats20 tr:nth-of-type(3n) td {
            border-top:2px darkgray solid;
        }
        .stats20 span {
            color:gray;
            font-size:small;
        }

        @media (max-width:520px) {
            #dashboard {width: 320px;}
            #stats > div > span:first-of-type {width: auto;}
        }
    </style>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include file="inc/topTeam.asp"-->
<div id="dashboard">
    <div id="pTitle"><h1>תפריט משתמשים רשומים</h1></div>

    <ul>
        <li><a href="../profile.asp?id=<%=session("userID")%>">הפרופיל שלי</a></li>
        <li><a href=""></a></li>
        <li><a href="../welcome.asp">מדריך - ברוכים הבאים</a></li>
        <li><a href="../guideTeam.asp">מדריך - הוספת ועריכת מילים</a></li>
        <li><a href=""></a></li>
        <li><a href="../dashboard.asp">תוכן - דף שליטה</a></li>
        <li><a href="../activity.asp">תוכן - פעולות אחרונות</a></li>
        <li><a href="mediaControl.asp">תוכן - בנק מדיה</a></li>

    </ul>

</div>
<!--#include virtual="/inc/trailer.asp"-->