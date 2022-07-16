<!--#include file="inc/inc.asp"--><%
if (session("role")=15) then 
else
    session("msg") = "כדי להוסיף משימות, עליך לקבל הרשאה מתאימה ממנהל האתר"
    Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html>
<head>
	<title>יצירת משימה חדשה</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
    <style>
        h1 {padding:0; margin:0 0 10px 0; font-size:x-large;}
        .radio {background: #fff; border:1px solid #ccc; padding: 3px 5px; color:#ccc; }
        #newTask > div {background:#fde6a54f; border-bottom:1px solid #d6c498; padding:10px;}
        label {font-weight:bold;}
        span {color:red;}
        button { border:0; color:white;}
        button:hover {border-left:4px solid black;}

        button[type=submit] {background:#4d6bfd; padding:20px 80px; font-size:xx-large;}
        #cancel {background:#fd4d4d; padding:10px 40px;}

        #subTasks th {font-weight:100;}
        input::placeholder {color:#b9b8b8;}        
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="dashboard">
    <div class="table">
        <h1>הוספת משימה חדשה</h1>
        <form id="newTask" action="team.task.new.insert.asp">
        <input style="display:NONE;" name="timeUTC" />
        <div>
            <label for="title">המשימה</label>
            <div><input style="width:100%;" type="text" name="title" required autofocus /></div>
        </div>
        <div>
            <label for="status">סטטוס</label>
            <select id="status" name="status" form="newTask" required>
                <option value="1">בטיפול</option>
                <option value="2">לפני הפרויקט הבא</option>
                <option value="3">הפרויקט הבא</option>
                <option value="9">עתידי</option>
                <option value="15">הצעות ורעיונות</option>
                <option value="42">בוצע</option>
                <option value="99">בוטל</option>
            </select>
        </div>
        <div>
            <label for="priority">דחיפות</label>
            <select id="priority" name="priority" form="newTask">
                <option value="1">דחוף</option>
                <option value="2">חשוב</option>
                <option value="3" selected>רגיל</option>
                <option value="5">נמוך</option>
                <option value="99">ללא</option>
            </select>
        </div>
        <div>
            <label for="type">סוג</label>
            <select id="type" name="type" form="newTask">
                <option value="1">מנהלה</option>
                <option value="10">קוד - פיצ'ר חדש</option>
                <option value="11">קוד - שיפורים</option>
                <option value="12">קוד - באגים</option>
                <option value="20">תוכן - ערכים במילון</option>
                <option value="21">תוכן - מולטימדיה</option>
                <option value="29">תוכן - אחר</option>
                <option value="0">לא משויך</option>
            </select>
        </div>
         <div>
            <label for="section">חלק באתר</label>
            <select id="section" name="section" form="newTask">
                <option value="0">אחר</option>
                <option value="1">מנוע חיפוש</option>
                <option value="2">דף מילה</option>
                <option value="3">רשימות אישיות</option>
                <option value="4">רשימות קבועות</option>
                <option value="5">משחקים</option>
                <option value="6">משפטים</option>
            </select>
        </div>
        <div>
            <label for="private">משימה פרטית</label>
            <input type="checkbox" id="private" name="private">
        </div>
        <div>
            <label for="notes">הערות</label>
            <br/><textarea id="notes" maxlength="1000" name="notes" rows="4" style="width:100%;"></textarea>
        </div>
        <div>
            <label for="img">יש צילומסך?</label>
            <input type="checkbox" id="img" name="img">
        </div>
        <div>
            <label>שיוך לפרויקט/ים</label>
            <div>לא מוצג בדף משימות</div>
        </div>
        <div>
            <label for="subTasks">תת משימות</label>
            <table id="subTasks" style="width:100%;">
                <tr>
                    <th>מיקום</th>
                    <th style="text-align:right;">משימה</th>
                    <th>בוצע</th>
                </tr>
                <tr>
                    <td style="text-align:center;">
                        <input name="newSubPos" type="number" style="width:40px; text-align:center;" />
                    </td>
                    <td>
                        <input name="newSubTitle" id="newSubTitle" type="text" placeholder="הוספת תת משימה חדשה" style="width:100%;" />
                    </td>
                    <td style="text-align:center;">
                        <input name="newSubDone" type="checkbox" style="width:40px; text-align:center;" />
                    </td>
                </tr>
            </table>
        </div>
        <button type="submit" style="margin-top:20px;">הוסף</button>
        <br/><br/>
        <button type="button" id="cancel" onclick="window.location.href='team.tasks.asp'">
            חזרה לדף משימות
            <br/>(ללא שמירה)
        </button>
    </div>
    </form>
</div>

<!--#include file="inc/trailer.asp"-->
</body>
</html>