﻿<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>כניסה / התחברות</title>
    <meta name="ROBOTS" content="NONE">
<!--#include file="inc/header.asp"-->
    <style>
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
<!--#include file="inc/top.asp"--><%

dim allowEdit,backTo,error,ref,ref2

ref = request.ServerVariables("HTTP_REFERER") 'PREVIOUS PAGE : word.asp / login.asp'
if request("ref")<>"" then ref=request("ref")

if ref="" then ref="../users.landingPage.asp"

if right(Request("ref"),9)="login.asp" or right(Request("ref"),7)="arabic/" then 
    backTo=baseT 
else 
    backTo=ref
end if

if backTo="" then backTo="../users.landingPage.asp"

ref2 = request("ref2")

if ref2 = "lPage" then 
    backTo="../users.landingPage.asp"
end if

startTime = timer()
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
            <br><button onclick="location.href='<%=backTo%>'">חזרה לדף הקודם</button>
        </div><%
    end if
res.close


if Len(Request("username"))>0 then

	res.Open "SELECT id,name,role,email FROM users WHERE username="""&Request("username")&""" AND password="""&Request("password")&"""",con,1
	if res.eof then 
		error="טעות בשם המשתמש או הסיסמא"
        session("role")=0
	else
        if allowEdit = false then
            if request("username")<>"kanija" then
                session("msg") = "מתבצעת כרגע עבודה על מסד הנתונים.<br>נסו להתחבר שוב עוד כרבע שעה."
                response.redirect backTo
            end if
        end if
        session("userID")=res("id")
        session("userName")=Request("username")
        session("email")=res("email")
        session("role")=res("role")
        session("name")=res("name")

        'TEMPORARY DISABLED DUE TO ERROR ON GODADDY 2021-11-24 'INSERT userID & now() TO loginLog'

        ' mySQL = "INSERT INTO loginLog (userID,loginTimeUTC) VALUES ("&res("id")&",'"&AR2UTC(now())&"')"
        ' cmd.CommandType=1
        ' cmd.CommandText=mySQL
        ' Set cmd.ActiveConnection=con
        ' cmd.execute ,,128

        response.redirect backTo
	end if
	res.Close


    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicUsers","C","login.asp","single",durationMs,""



End if %>
<div class="table teamLogo" dir="ltr">
    <div><img src="img/teamLogo-let1-60px.png" alt="t" /></div>
    <div><img src="img/teamLogo-let2-60px.png" alt="E" /></div>
    <div><img src="img/teamLogo-let3-60px.png" alt="A" /></div>
    <div><img src="img/teamLogo-let4-60px.png" alt="M" /></div>
    <div><img src="<%=baseA%>img/site/logo-60px.png" alt="ע" /></div>
</div>
<div id="pTitle">כניסה למשתמשי המילון</div>
<form method="post" id="Form1" action="login.asp?ref2=<%=ref2%>">
<div class="table divStats">
    <input type="hidden" name="ref" value="<%=ref%>" id="ref"/>
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
	רוצים גם להוסיף מילים ולאסוף רשימות?
    <br/>כתבו לנו מייל עם הנושא - הרשמה למילון
    <br/>arabic4hebs@gmail.com
</div>
</form>
<div class="table" style="max-width:290px; text-align:center; margin-top:40px;">
    <a href="<%=baseA%>"><u>חזרה למילון</u></a>
</div>
<!--#include file="inc/trailer.asp"-->
</body>
</html>