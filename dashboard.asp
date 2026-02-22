<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <meta name="ROBOTS" content="NONE">
	<title>דף שליטה (תוכן)</title>
<!--#include file="inc/header.asp"-->
    <style>
        h1 {font-size:1em; margin:0;}
        h2 {font-size:1em;}
        #dashboard  { width:500px; margin:0 auto; }
        .new {background-color: white; text-align: center; font-size: 3em; cursor: pointer;border: rgb(186, 218, 246) 1px solid; border-radius: 30px; margin: 0 auto; width: 98%;}
        .new a:visited, .new a:link {color: rgb(65, 145, 194);}

        .stats20 {
            width:100%;
        }
        .stats20 a:link,a:visited {
            color: #4191c2;
            text-decoration: underline;
        }
        .stats20 a:hover {
            background:yellow;
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
<!--#include file="inc/top.asp"--><%

dim total,totalLocal,totalShow,x

'openDB "arabicWords" 
openDbLogger "arabicWords","O","dashboard.asp","single",""

%>
<div id="dashboard">
    <div id="pTitle"><h1>דף שליטה (תוכן)</h1></div>

    <br>
    <table class="stats20">
        <tr>
            <th><h2>מילים</h2></th>
            <th>מוצגות</th>
            <th>מוסתרות</th>
            <th>סה"כ</th>
        </tr>
        <tr>
            <td>סה"כ</td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE show"
                res.open mySQL, con
                    totalShow = res(0)
                    response.write formatNumber(res(0),0)
                res.close %>
                <br><span>100%</span>
            </td>
            <td><a href="dashboard.lists.asp?listID=3"><%
                mySQL="SELECT COUNT(*) FROM words WHERE show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
                </a>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words"
                res.open mySQL, con
                    total = formatNumber(res(0),0)
                    response.write total
                res.close %>
            </td>
        </tr>
        
        <tr>
            <td>תקינות</td>
            <td style="background-color: rgba(0, 128, 0, 0.13); color: green;"><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=1 AND show"
                res.open mySQL, con
                     x = formatNumber(res(0),0)
                     response.write x
                res.close %>
                <br><span>(<%=round((x/totalShow)*100,1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=1 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=1"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=1">טרם נבדקו</a></td>
            <td style="background-color: rgba(255, 255, 0, 0.31); color:#5f5f07;"><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=0 AND show"
                res.open mySQL, con
                    x =  formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=round((x/totalShow)*100,2)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=0 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=0"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>    

        <tr>
            <td><a href="dashboard.lists.asp?listID=2">חשד לטעות</a></td>
            <td style="background-color: rgba(255, 0, 0, 0.2); color: rgb(164, 22, 22);"><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=-1 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span> 
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=-1 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=-1"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=4">ללא ערבית</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(arabic)=0 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(arabic)=0 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(arabic)=0"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=5">עברית עם תו בעייתי</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE ((hebrewTranslation LIKE '%/%') OR (hebrewTranslation LIKE '%\%') OR (hebrewTranslation LIKE '%)%') OR (hebrewTranslation LIKE '%(%')) AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE ((hebrewTranslation LIKE '%/%') OR (hebrewTranslation LIKE '%\%') OR (hebrewTranslation LIKE '%)%') OR (hebrewTranslation LIKE '%(%')) AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE ((hebrewTranslation LIKE '%/%') OR (hebrewTranslation LIKE '%\%') OR (hebrewTranslation LIKE '%)%') OR (hebrewTranslation LIKE '%(%'))"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>
        <tr>
            <td><a href="dashboard.lists.asp?listID=6">ללא סוג מילה</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=0 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=0 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=0"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>
        <tr>
            <td><a href="dashboard.lists.asp?listID=7">ללא מספר</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE number=4 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE number=4 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE number=4"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=8">ללא מגדר</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE gender=3 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE gender=3 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE gender=3"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=9">משפט לדוגמא בפורמט הישן</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(example)>0 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(example)>0 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(example)>0"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=10">מילות חיפוש בפורמט הישן</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(searchString)>0 AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
                <br><span>(<%=formatNumber((x/totalShow)*100,2,-1)%>%)</span>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(searchString)>0 AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE len(searchString)>0"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>

        <tr>
            <td><a href="dashboard.lists.asp?listID=11">תמונה עם קישור לא מאובטח</a></td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE imgLink LIKE '%http:%' AND show"
                res.open mySQL, con
                    x = formatNumber(res(0),0)
                    response.write x
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE imgLink LIKE '%http:%' AND show=false"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
            <td><% 
                mySQL="SELECT COUNT(*) FROM words WHERE imgLink LIKE '%http:%'"
                res.open mySQL, con
                    response.write formatNumber(res(0),0)
                res.close %>
            </td>
        </tr>
    </table>
    
    <br>

    <table class="stats20">
        <tr><% 
            mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=1 AND number=1 AND show"
            res.open mySQL, con
                total = res(0)
            res.close 
            mySQL="SELECT COUNT(*) FROM words INNER JOIN taskNoPlural ON words.id = taskNoPlural.word1 WHERE words.partOfSpeach=1 AND show"
            res.open mySQL, con
                x = res(0)
            res.close %>
            <td>
                <a href="dashboard.lists.asp?listID=13">ש.עצם יחיד ללא רבים</a>
            </td>
            <td><%=FormatNumber(x,0)%> מתוך <%=FormatNumber(total,0)%>
                <span>(<%=(round((x/total)*100,1))%>%)</span>
            </td>
        </tr>

        <tr><% 
            mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=2 AND number=1 AND show"
            res.open mySQL, con
                total = res(0)
            res.close 
            mySQL="SELECT COUNT(*) FROM words INNER JOIN taskNoPlural ON words.id = taskNoPlural.word1 WHERE words.partOfSpeach=2 AND show"
            res.open mySQL, con
                x = res(0)
            res.close %>
            <td>
                <a href="dashboard.lists.asp?listID=14">ש.תואר יחיד ללא רבים</a>
            </td>
            <td><%=FormatNumber(x,0)%> מתוך <%=FormatNumber(total,0)%>
                <span>(<%=(round((x/total)*100,1))%>%)</span>
            </td>
        </tr>

        <tr><% 
            mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=3 AND show=true"
            res.open mySQL, con
                total = res(0)
            res.close 
            mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=3 AND binyan>0"
            res.open mySQL, con
                x = res(0)
            res.close %>
            <td>
                <a href="dashboard.lists.asp?listID=12">פעלים ללא בניין</a></span>
            </td>
            <td><%=FormatNumber(total-x,0)%> מתוך <%=FormatNumber(total,0)%>
                <span>(<%=FormatNumber(100-(round((x/total)*100,1)),0)%>%)</span>
            </td>
        </tr>
    </table>
        
    <ul style="line-height:1.5em;"><u><label>רשימות בתכנון:</label></u>
        <li>חיפושים פופלארים ללא משפט לדוגמא</li>
        <li>חיפושים פופלארים ללא תוצאה מדויקת</li>
        <li>כפילויות</li>
        <li>חיפושים פופלארים ללא אודיו</li>
        <li>משפטים שאינם משויכים למילים</li>
    </ul>

</div><%

'closeDB
closeDbLogger "arabicWords","C","dashboard.asp","single",durationMs,""


%>
<!--#include file="inc/trailer.asp"-->
</body>
</html>