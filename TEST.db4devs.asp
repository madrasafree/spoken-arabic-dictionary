<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<!DOCTYPE html>
<html>
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
    <title>קובץ מילים לקהל הרחב</title>
	<meta name="Description" content="קובץ מילים לקהל הרחב" />
    <!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="pTitle">
    <h1 style="font-size:1.2em;">קובץ מילים לקהל הרחב</h1>
</div>
<div class="table">
    <p>לאורך השנים קיבלנו פניות בבקשה לקבל את מסד הנתונים שלנו, בין אם מתוכניתנים שמעוניינים לבנות אפליקציות ואתרים, ובין אם ממשתמשי קצה שרוצים גישה למילון ללא צורך בכניסה לאתר. 
    </p>
    <p>אנו מצרפים לכם כאן את מסד הנתונים של המילון להורדה בגרסה מצומצמת.
    </p>
    <p>אנו מברכים יוזמות חדשות להנגשת השפה הערבית המדוברת, ולכן משתפים קובץ זה ברבים. יחד עם זאת, חשוב לזכור:
    </p>
    <ul>
        <li>השימוש בקובץ ובמידע על אחריותכם בלבד.</li>
        <li>אין למתג או לשייך את השירות / אפליקציה שלכם לפרויקט 'מילון ערבית מדוברת' ללא אישור ותיאום מראש.</li>
        <li>הקובץ מכיל אלפי מילים, אך לא מתעדכן באופן תדיר.</li>
        <li>הקובץ מכיל רק את העמודות הבסיסיות של המילון.</li>
    </ul>
    <p style="padding:10px; border:1px solid gray;text-align:center;">
        <a href="team/db4devs.zip">db4devs.zip</a>
    </p>
    <p>
    נשמח לראות אילו דברים יפים יצרתם, ובמידה ויהיה רלוונטי, נשמח גם לשיתופי פעולה.
    </p>
    <p>לשאלות - arabic4hebs@gmail.com</p>


</div>

<!--#include file="inc/trailer.asp"-->