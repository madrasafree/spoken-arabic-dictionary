<!--#include file="inc/inc.asp"--><%
dim cntID, cntLBL, cntLST, cntIMG, cntVID, cntAUDIO, cntREL, cntUSR, cntSrch, sumSrch
    
openDB "arabicWords"
    mySQL = "SELECT count(ID) as cntID FROM words WHERE words.show "
    res.open mySQL, con
        cntID = FormatNumber(res("cntID"),0)
    res.close
        
    mySQL = "SELECT count(ID) as cntLBL FROM labels"
    res.open mySQL, con
        cntLBL = FormatNumber(res("cntLBL"),0)
    res.close
        
    mySQL = "SELECT count(ID) as cntLST FROM lists"
    res.open mySQL, con
        cntLST = FormatNumber(res("cntLST"),0)
    res.close

    mySQL = "SELECT count(ID) as cntIMG FROM words WHERE imgLink<>''"
    res.open mySQL, con
        cntIMG = FormatNumber(res("cntIMG"),0)
    res.close 

    mySQL = "SELECT count(id) as cntVID FROM media WHERE mType=1"
    res.open mySQL, con
        cntVID = FormatNumber(res("cntVID"),0)
    res.close

    mySQL = "SELECT count(id) as cntAUDIO FROM media WHERE mType=21"
    res.open mySQL, con
        cntAUDIO = FormatNumber(res("cntAUDIO"),0)
    res.close

    mySQL = "SELECT count(word1) as cntREL FROM wordsRelations"
    res.open mySQL, con
        cntREL = FormatNumber(res("cntREL"),0)
    res.close

closeDB
        
openDB "arabicUsers"
    mySQL = "SELECT count(ID) as cntUSR FROM users"
    res.open mySQL, con
        cntUSR = FormatNumber(res("cntUSR"),0)
    res.close
closeDB    
    
openDB "arabicSearch"
	mySQL = "SELECT count(*),sum(searchCount) FROM wordsSearched"
	res.open mySQL, con     
        cntSrch = FormatNumber(res(0),0)
        sumSrch = FormatNumber(res(1),0)
    res.close
closeDB

%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>סטטיסטיקה</title>
	<meta name="Description" content="מידע וסטטיסטיקה על המילון והגלישה לאתר" />
    <style>
        .divStats ul {list-style:none; padding:0;}
        .divStats li {
            background:white;width: 210px;
            padding: 10px 0px;
            margin: 15px auto;
            border-radius: 20px;
            }
        .divStats label {font-size:2em; display:block; margin-top:10px;}
        .grow   { display:block; color:#539425; }
    </style>
    <!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">סטטיסטיקה</div>

<br />
<div class="table divStats">
    מאז הקמת המילון ב-2006 
    <ul>
        <li><label><%=cntUSR%></label> חברי קהילת המילון</li>
    </ul>
    הוסיפו ותרמו:
    <ul>
        <li><label><%=cntID%></label> ערכים</li>
        <li><label><%=cntREL%></label> קשרים בין ערכים</li>
        <li><label><%=cntAUDIO%></label> הקלטות אודיו</li>
        <li><label><%=cntIMG%></label> תמונות</li>
        <li><label><%=cntLST%></label> רשימות אישיות</li>
        <li><label><%=cntLBL%></label> תגיות נושאים</li>
        <li><label><%=cntVID%></label> סרטונים</li>
    </ul>
</div>
<br />
<div class="table divStats">
	מאז דצמבר 2009 נעשו
    <ul>
        <li><label><%=sumSrch%></label> חיפושים</li>
    </ul>
    שהיו מורכבים מ:
    <ul>
        <li><label><%=cntSrch%></label> מילים וביטויים שונים</li>
    </ul>
</div>
<br />
<div class="table divStats" style=" max-width:280px; padding:10px 10px; border-radius:10px; ">
    >> <a href="stats.topSearch.asp">100 המילים שחיפשו הכי הרבה</a>
</div>
<br/>
<table class="tableStats">
    <tr>
        <th>שנה</th>
        <th>משתמשים באתר</th>
        <th>כניסות לאתר</th>
        <th>צפיות בדפים</th>
    </tr>
    <tr>
        <td>2021</td>
        <td>357,000
            <span class="grow" dir="ltr">+6%</span></td>
        <td>996,000
            <span class="grow" dir="ltr">+7%</span></td>
        <td>4,800,000
            <span class="grow" dir="ltr">+4%</span></td>
    </tr>
    <tr>
        <td>2020</td>
        <td>336,000
            <span class="grow" dir="ltr">+43%</span></td>
        <td>933,000
            <span class="grow" dir="ltr">+52%</span></td>
        <td>4,649,000
            <span class="grow" dir="ltr">+53%</span></td>
    </tr>
    <tr>
        <td>2019</td>
        <td>234,000
            <span class="grow" dir="ltr">+44%</span></td>
        <td>611,000
            <span class="grow" dir="ltr">+52%</span></td>
        <td>3,034,000
            <span class="grow" dir="ltr">+31%</span></td>
    </tr>
    <tr>
        <td>2018</td>
        <td>162,000
            <span class="grow" dir="ltr">+44%</span></td>
        <td>400,000
            <span class="grow" dir="ltr">+84%</span></td>
        <td>2,300,000
            <span class="grow" dir="ltr">+76%</span></td>
    </tr>
    <tr>
        <td>2017</td>
        <td>99,900
            <span class="grow" dir="ltr">+19%</span></td>
        <td>217,000
            <span class="grow" dir="ltr">+34%</span></td>
        <td>1,300,000
            <span class="grow" dir="ltr">+53%</span></td>
    </tr>
    <tr>
        <td>2016</td>
        <td>83,000
            <span class="grow" dir="ltr">+16%</span></td>
        <td>161,000
            <span class="grow" dir="ltr">+13%</span></td>
        <td>853,000
            <span class="grow" dir="ltr">+11%</span></td>
    </tr>
    <tr>
        <td>2015</td>
        <td>71,000
            <span class="grow" dir="ltr">+83%</span></td>
        <td>142,000
            <span class="grow" dir="ltr">+111%</span></td>
        <td>768,000
            <span class="grow" dir="ltr">+155%</span></td>
    </tr>
    <tr>
        <td>2014</td>
        <td>39,000
            <span class="grow" dir="ltr">+130%</span></td>
        <td>67,000
            <span class="grow" dir="ltr">+146%</span></td>
        <td>300,000
            <span class="grow" dir="ltr">+115%</span></td>
    </tr>
    <tr>
        <td>2013</td>
        <td>17,000
            <span class="grow" dir="ltr">+103%</span></td>
        <td>27,000
            <span class="grow" dir="ltr">+110%</span></td>
        <td>139,000
            <span class="grow" dir="ltr">+65%</span></td>
    </tr>
    <tr>
        <td>2012.02</td>
        <td>8,312</td>
        <td>12,896</td>
        <td>83,776</td>
    </tr>
</table>
<br/>
<div class="table divStats" style="text-align:center; line-height:20px;">
<ul>
    <li><u>2012</u>
        <br/>גוגל אנליטיקס
        <br/>מקבלים מידע על הגלישה באתר
    </li>
    <li><u>2009</u>
        <br>כולם יכולים להוסיף מילים
        <br/>מערכת ניהול משתמשים
    </li>
    <li><u>2006</u>
        <br/>אתר המילון הוקם
        <br/>וכלל כ-500 מילים
    </li>
</ul>
</div>
<!--#include file="inc/trailer.asp"-->