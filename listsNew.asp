<!--#include file="inc/inc.asp"--><%
If (session("role")<2) then 
    session("msg") = "על מנת לערוך רשימות, עליך להיות מחובר"
    Response.Redirect "team/login.asp"
end if

openDB "arabicUsers"
    'Checks if READ ONLY mode is Enabled
    mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readonly'"
    res.open mySQL, con
    if res(0) = true then
        session("msg") = "אין כרגע אפשרות ליצור רשימות חדשות. אנא נסו שנית מאוחר יותר"
        response.Redirect "."
    end if
    res.close
closeDB


dim maxLists

'openDB "arabicUsers"
openDbLogger "arabicUsers","O","listsNew.asp","max user list",""

    mySQL = "SELECT maxLists FROM users WHERE id="&session("userID")
    res.open mySQL, con
    maxLists = res(0)
    res.close

'closeDB
closeDbLogger "arabicUsers","C","listsNew.asp","max user list",durationMs,""



'openDB "arabicWords"
openDbLogger "arabicWords","O","listsNew.asp","main",""


'limit number of lists - 10 per user'
mySQL = "SELECT count(id) FROM lists WHERE creator="&session("userID")
res.open mySQL, con
if res(0)>maxLists then
    session("msg") = "הגעת למספר הרשימות המקסימלי ("&maxLists&").</br>לא ניתן ליצור רשימה נוספת בשלב זה. מוזמן לפנות למנהל האתר לפרטים נוספים."
    Response.Redirect "lists.asp"
end if
res.close %>

<!DOCTYPE html>
<html>
<head>
	<title>יצירת רשימה חדשה</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
    <style>
        .formList {
            background:#d4eaff33;
            border:1px solid #90beeaa8;
            padding:10px;
            position:relative;
            margin:0 auto;
            max-width:400px;
        }

        input[type=text], textarea {
            border-width:1px;
            border-radius:5px;
            display:block;
            margin-bottom:15px;
            padding:3px;
            width: 90%;
        }
        input[type=radio] {
            margin:.4rem;
        }
        button[type=submit] {
            bottom:10px;
            left:10px;
            position:absolute;
        }
        .tooltip < div {
            position:relative;
        }
        .tooltip {
            background: yellow;
            border: 1px solid blue;
            border-radius:10px;
            color: blue;
            padding: 4px 8px;
            position:absolute;
            visibility: hidden;

        }
        .material-icons:hover ~ .tooltip {
            visibility: visible;
        }
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="dashboard">
    <div style="text-align:center; margin-bottom: 10px; text-decoration:underline;"><%
        mySQL = "SELECT count(id) FROM lists WHERE creator="&session("userID")
        res.open mySQL, con %>
            יש לך כרגע <%=res(0)%> רשימות מתוך <%=maxLists%><%
        res.close %>
    </div>
    <h1 class="pTitle">יצירת רשימה חדשה</h1>

    <form class="formList" action="listsNew.insert.asp">
        <label><b>שם הרשימה</b></label>
        <input type="text" name="lTitle" required autofocus />
        <label><b>תיאור</b></label>
        <textarea name="lDesc" cols="40" rows="5"></textarea>
        <br>
        <b>דרגת פרטיות</b>
        <div>
            <input type="radio" name="lPrivacy" value="public">
            <label>פומבי</label>
            <span class="material-icons" style="font-size:1rem;">help_outline</span>
            <span class="tooltip">יופיע באינדקס של הרשימות</span>
        </div>
        <div>
            <input type="radio" name="lPrivacy" value="unlisted" checked>
            <label>לבעלי קישור</label>
            <span class="material-icons" style="font-size:1rem;">help_outline</span>
            <span class="tooltip">לא יופיע באינדקס, אך עדיין נגיש עם קישור</span>
        </div><%
        if (session("userID")=1 or session("userID")=73 or session("userID")=76) then 
        'RONEN YANIV ITAY %>
        <div>
            <input type="radio" name="lPrivacy" value="0">
            <label>פרטי</label> (יניב, רונן, איתי)
        </div>
        <div>
            <input type="radio" name="lPrivacy" value="3">
            <label>משותף</label> (יניב, רונן, איתי)
        </div><%
        end if%>
        
        <button type="submit">יאללה</button>
    </form>

</div><%
'closeDB
closeDbLogger "arabicWords","C","listsNew.asp","main",durationMs,""
%>
<!--#include file="inc/trailer.asp"-->