<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>התחברות למערכת המילון</title>
    <META NAME="ROBOTS" CONTENT="NONE">
<!--#include file="inc/header.asp"-->
    <style>
        .teamLogo {text-align: center;  margin-bottom: 25px;}
        .teamLogo > div {display: inline-block;}
        
        @media (max-width:330px) {
            
            .teamLogo img {width: 50px;}
        }
    </style>
</head>
<body><%
dim error,backTo,ref,a,x,cTime,allowEdit
ref = Request.ServerVariables("HTTP_REFERER") 'PREVIOUS PAGE : word.asp / login.asp'
'Response.write "<br/>ref = "&ref
'response.write "<br/>Request(ref) = "&Request("ref")
if Request("ref")<>"" then
    ref = Request("ref")
else
    ref = "team.asp"
end if
'Response.write "<br/>ref="&ref
'Response.write "<br/>backTo="&backTo

' if right(Request("ref"),9)="login.asp" then 
'     backTo=baseT 
' else 
'     backTo=ref
' end if

'Response.write "<br/>backTo="&backTo
if backTo="" then backTo="team.asp"
'Response.write "<br/>backTo="&backTo



if Request("exit")=1 then
    session.abandon
    session("role") = 0
    session("msg") = "התנתקת בהצלחה"
    response.write "<br/>MSG = "&session("msg")
    'response.end
    response.Redirect ref
end if

openDB "arabicUsers"
mySQL = "SELECT allowed FROM allowEdit WHERE siteName='arabic'"
res.open mySQL, con
    if res(0)=true then
        allowEdit = true
    else
        allowEdit = false
        session("msg") = "מתבצעת כרגע עבודה על מסד הנתונים. <br/>נסו להתחבר שוב עוד כרבע שעה."
        response.Redirect "."
    end if
res.close


If Len(Request("username"))>0 and allowEdit=true then

	res.Open "select id,name,role,email from users where username="""&Request("username")&""" and password="""&Request("password")&"""",con,1
	if res.eof then 
		error="טעות בשם המשתמש או הסיסמא"
        session("role")=0
	else
		session("userID")=res("id")
		session("userName")=Request("username")
		session("email")=res("email")
		session("role")=res("role")
		session("name")=res("name")


        'INSERT userID & now() TO loginLog'
        mySQL = "INSERT INTO loginLog (userID,loginTimeUTC) VALUES ("&res("id")&",'"&AR2UTC(now())&"')"
        cmd.CommandType=1
        cmd.CommandText=mySQL
        response.write "<div dir='ltr'>"&mySQL&"</div>"
        'response.end
        Set cmd.ActiveConnection=con
        cmd.execute ,,128

		Response.Redirect backTo
	end if
	res.Close
	CloseDB
End if %>
<div class="table teamLogo" dir="ltr">
    <div><img src="img/site/team/teamLogo-let1-60px.png" alt="t" /></div>
    <div><img src="img/site/team/teamLogo-let2-60px.png" alt="E" /></div>
    <div><img src="img/site/team/teamLogo-let3-60px.png" alt="A" /></div>
    <div><img src="img/site/team/teamLogo-let4-60px.png" alt="M" /></div>
    <div><img src="<%=baseA%>img/site/logo-60px.png" alt="ע" /></div>
</div>
<div id="pTitle">התחברות למערכת המילון</div>
<form method="post" id="Form1" action="login.asp" >
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
</div>

<br />

<%if error<>"" then %><div class="tableH" style="border:dashed 2px red;"><%=error%></div><%end if%>

<div class="table divStats" style="max-width:290px;">
	רוצים גם להוסיף ערכים למילון?
	<br /><a href="<%=baseA%>team.asp"><u>לחצו כאן</u></a>
</div>
</form>
<div class="table" style="max-width:290px; text-align:center; margin-top:40px;">
    <a href="<%=baseA%>"><u>חזרה למילון</u></a>
</div>
<!--#include file="inc/trailer.asp"-->
</body>
</html>