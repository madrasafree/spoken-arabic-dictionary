<!--#include file="includes/inc.asp"-->
<!--#include file="includes/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>כניסה / התחברות</title>
    <meta name="ROBOTS" content="NONE">
<!--#include file="includes/header.asp"-->
    <style>

        .debug {
            background:#313131;
            color:#3baf3b;
            direction:ltr;
            margin:0 auto;
            max-width:600px;
            padding:10px;
        }

        .teamLogo {
            text-align: center;
            margin: 25px auto;
            }
        
        .teamLogo > div {
            display: inline-block;
            }
        
        @media (max-width:330px) {
            
            .teamLogo img {width: 50px;}
        }
    </style>
</head>
<body>
<!--#include file="includes/top.asp"--><%

dim allowEdit,error,returnTo,return2,debugMode

debugMode = FALSE
if debugMode then response.write "<div class='debug'>Debug Mode - START</div>"

if len(request("returnTo"))>0 then returnTo = replace(request("returnTo"),"'","")
if debugMode then response.write "<div class='debug'>returnTo = "&returnTo&"</div>"

if len(request("return2"))>0 then returnTo = replace(request("return2"),"'","")
if debugMode then response.write "<div class='debug'>returnTo (2) = "&returnTo&"</div>"

if len(returnTo)=0 then returnTo = "users.landingPage.asp"
if debugMode then response.write "<div class='debug'>returnTo (0) = "&returnTo&"</div>"


'openDB "arabicUsers"
openDbLogger "arabicUsers","O","login.asp","single",""


mySQL = "SELECT allowed FROM allowEdit WHERE siteName='arabic'"
res.open mySQL, con
    if res(0)=true then
        allowEdit = true
    else
        allowEdit = false %>
        <div style="max-width:400px; margin:10px auto; padding:10px; text-align:center;">
            <mark>מתבצעת כרגע עבודה על מסד הנתונים.
                <br>נסו להתחבר שוב עוד כרבע שעה.
            </mark>
            <br>
            <br><button onclick="location.href='<%=returnTo%>'">חזרה לדף הקודם</button>
        </div><%
    end if
res.close


if debugMode then response.write "<div class='debug'>request(username) = "&request("username")&"</div>"


if Len(Request("username"))>0 then

	res.Open "SELECT id,name,role,email,userStatus FROM users WHERE username="""&Request("username")&""" AND password="""&Request("password")&"""",con,1
	if res.eof then 
		error="טעות בשם המשתמש או הסיסמא"
        session("role")=0
	else
        if res("userStatus")=77 and res("ID")<380 then
            session("msg") = "ברוכים השבים! חשבונכם הוקפא עם המעבר למדרסה. על מנת להחזיר אותו לפעילות, אנא אשרו העברת הפרטים שלכם אלינו על ידי שליחת מייל ל-arabic4hebs@gmail.com"
            response.redirect returnTo
        end if
        if allowEdit = false then
            if request("username")<>"kanija" then
                if request("username")<>"yanivg" then
                    session("msg") = "מתבצעת כרגע עבודה על מסד הנתונים.<br>נסו להתחבר שוב עוד כרבע שעה."
                    if debugMode then response.end
                    response.redirect returnTo
                end if
            end if
        end if
        session("userID")=res("id")
        session("userName")=Request("username")
        session("email")=res("email")
        session("role")=res("role")
        session("name")=res("name")
        session("msg")="התחברת בהצלחה!"

        'TEMPORARY DISABLED DUE TO ERROR ON GODADDY 2021-11-24 'INSERT userID & now() TO loginLog'

        ' mySQL = "INSERT INTO loginLog (userID,loginTimeUTC) VALUES ("&res("id")&",'"&AR2UTC(now())&"')"
        ' cmd.CommandType=1
        ' cmd.CommandText=mySQL
        ' Set cmd.ActiveConnection=con
        ' cmd.execute ,,128

        if debugMode then 
            response.write "<div class='debug'>returnTo = "&returnTo&"</div>"
            response.write "<div class='debug'>Debug Mode - END </div>"
            response.end
        end if

        response.redirect returnTo
	end if
	res.Close


    'closeDB
    closeDbLogger "arabicUsers","C","login.asp","single",durationMs,""



End if %>
<div class="table teamLogo" dir="ltr">
    <div><img src="assets/images/team/teamLogo-let1-60px.png" alt="t" /></div>
    <div><img src="assets/images/team/teamLogo-let2-60px.png" alt="E" /></div>
    <div><img src="assets/images/team/teamLogo-let3-60px.png" alt="A" /></div>
    <div><img src="assets/images/team/teamLogo-let4-60px.png" alt="M" /></div>
    <div><img src="assets/images/site/logo-60px.png" alt="ע" /></div>
</div>
<div id="pTitle">כניסה למשתמשי המילון</div>

<form method="post" id="Form1" action="login.asp">
<div class="table divStats">
    <input type="hidden" name="return2" value="<%=returnTo%>" id="return2"/>
    <table style="width:100%;" lang="en" dir="ltr">
        <tr>
            <td style="width:10px;">&nbsp;</td>
            <td style="padding:5px 5px;"><input style="width:90%; max-width:250px; padding:3px 3px;" type="text" id="username" name="username" placeholder="username" autofocus required /></td>
            <td style="width:10px;">&nbsp;</td>
        </tr>
        <tr>
            <td style="width:10px;">&nbsp;</td>
            <td style="padding:5px 5px;"><input style="width:90%; max-width:250px; padding:3px 3px;" type="password" id="password" name="password" placeholder="password" required /></td>
            <td style="width:10px;">&nbsp;</td>
        </tr>
        <tr>
            <td style="width:10px;">&nbsp;</td>
            <td>
                <input type="submit" value="יאללה" id="Submit1" name="Submit1" style="padding:4px 10px; font-size:large; margin-top:5px;" />
            </td>
            <td style="width:10px;">&nbsp;</td>
        </tr>
    </table>
    <div style="font-size:small; margin-top:10px;">
        שכחתם סיסמה? כתבו לנו למייל שמופיע מטה
    </div>
</div>

<br />

<%if error<>"" then %><div class="tableH" style="border:dashed 2px red;"><%=error%></div><%end if%>

<div id="pTitle" style="margin-top:40px;">הרשמה</div>
<div class="table divStats">
    <!--
	רוצים גם להוסיף מילים ולאסוף רשימות?
    <br/>
    מלאו את הטופס
    <a style="text-decoration:underline;" href="https://forms.monday.com/forms/e1e61a471abeb0dc03e71395cf63bac0?r=use1">
    בקשת הצטרפות למילון
    </a>
	-->
	<p>
	סגורים לרגל שיפוצים (תַרְמִימַאת ترميمات) 😉, לאחר עדכון האתר יפתחו פניות להרשאות. עמכם הסליחה
	</p>
</div>
</form>
<div class="table" style="max-width:290px; text-align:center; margin-top:40px;">
    <a href="."><u>חזרה למילון</u></a>
</div>
<!--#include file="includes/trailer.asp"-->
</body>
</html>