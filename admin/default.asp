<!--#include virtual="/includes/inc.asp"-->
<!--#include virtual="/includes/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "/login.asp?returnTo=" & Server.URLEncode(Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING"))
end if
dim allowEdit, readOnly

'openDB "arabicUsers"
openDbLogger "arabicUsers","O","default.asp","allowEdit",""

mySQL = "SELECT allowed FROM allowEdit WHERE siteName='arabic'"
res.open mySQL, con
	if res(0)=true then allowEdit = true else allowEdit = false
res.close

mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readOnly'"
res.open mySQL, con
	if res(0)=true then readOnly = true else readOnly = false
res.close


'closeDB
closeDbLogger "arabicUsers","C","default.asp","allowEdit",durationMs,""

 %>
<!DOCTYPE html>
<html>
<head>
	<title>דף ניהול ראשי</title>
    <META NAME="ROBOTS" CONTENT="NONE">
  	<link rel="stylesheet" href="<%=baseA%>assets/css/arabic_admin.css" />
  	<link rel="stylesheet" href="<%=baseA%>assets/css/arabic_admin_slider.css" />
<!--#include virtual="/includes/header.asp"-->
	<style>
		.enabler {max-width:600px; margin:0 auto; border:1px solid gray; text-align: center; padding: 10px; background:#eee; }
		#container {max-width:600px; margin:0 auto;}
		.adminMenu {
			background:white;
			border: 1px solid gray;
			padding:10px 40px;
			line-height:1.4em;
			}
	</style>
</head>
<body dir="rtl">
<!--#include virtual="/includes/top.asp"-->
<div id="container">
	<h1>דף ניהול ראשי</h1>
	<h2>משתמשים</h2>
	<ul class="adminMenu">
		<li><a href="userControl.asp">ניהול משתמשים</a></li>
	</ul>
	<h2>תוכן מילון</h2>
	<ul class="adminMenu">
		<li><a href="locked.asp">ערכים נעולים</li>
		<li><a href="wordsShort.asp">ניהול חיפושים קצרים</a></li>
		<li><a href="labelControl.asp">נושאים</a></li>
	</ul>
</div>


<div class="enabler">

	<label>אפשר / מנע התחברות לאתר</label>
	<label class="switch">
	  <input type="checkbox" name="enabler" <%if allowEdit=true then%>checked<%end if%> onclick="location.href = 'allowEditToggle.asp';">
	  <span class="slider round"></span>
	</label>


	<br>
	<label>אפשר / מנע שינויים במסד נתונים</label>
	<label class="switch">
	  <input type="checkbox" name="readOnlyToggle" <%if readOnly=false then%>checked<%end if%> onclick="location.href = 'readOnlyToggle.asp';">
	  <span class="slider round"></span>
	</label>

</div>



<!--#include virtual="/includes/trailer.asp"-->

</body>
</html>
