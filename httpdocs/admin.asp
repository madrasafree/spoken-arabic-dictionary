<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if
dim allowEdit

startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.asp","allowEdit",""

mySQL = "SELECT allowed FROM allowEdit WHERE siteName='arabic'"
res.open mySQL, con
	if res(0)=true then allowEdit = true else allowEdit = false
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.asp","allowEdit",durationMs,""

 %>
<!DOCTYPE html>
<html>
<head>
	<title>דף ניהול ראשי</title>
    <META NAME="ROBOTS" CONTENT="NONE">
  	<link rel="stylesheet" href="css/arabic_admin.css" />
  	<link rel="stylesheet" href="css/arabic_admin_slider.css" />
<!--#include file="inc/header.asp"-->
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
<!--#include file="inc/top.asp"-->
<div id="container">
	<h1>דף ניהול ראשי</h1>
	<h2>משתמשים</h2>
	<ul class="adminMenu">
		<li><a href="admin.userControl.asp">ניהול משתמשים</a></li>
		<li><a href="admin.loginHistory.asp">מעקב כניסות</a> - עד נוב' 21</li>
	</ul>
	<h2>תוכן מילון</h2>
	<ul class="adminMenu">
		<li><a href="admin.locked.asp">ערכים נעולים</li>
		<li><a href="admin.mark4translate.asp">מילים לתרגום</a></li>
		<li><a href="admin.wordsShort.asp">ניהול חיפושים קצרים</a></li>
		<li><a href="admin.labelControl.asp">נושאים</a></li>
		<li><a href="admin.lists.asp">רשימות אישיות</a></li>
	</ul>
	<h2>פורטל מידע</h2>
	<ul class="adminMenu">
		<li><a href="admin.schoolControl.asp">בתי ספר</a></li>
		<li><a href="admin.courseControl.asp">קורסים - לא פעיל</a></li>
	</ul>
	<h2>אחרים</h2>
	<ul class="adminMenu">
		<li><a href="admin.monitors.asp">ניטור מידע</a></li>
		<li><a href="admin.log.duration.asp">מעקב - זמני תגובה שאילתות שרת</a></li>
	</ul>
	<h2>כבדים - להריץ מקומית בלבד</h2>
	<ul class="adminMenu">
		<li><a href="admin.select.asp">SQL SELECT</a></li>
		<li><a href="admin.listAllWords.asp">רשימת כל המילים במילון - מומלץ רק לוקאלי</a></li>
	</ul>
</div>
<div class="enabler"><p>אפשר / מנע שינויים במסד נתונים</p>
	<label class="switch">
	  <input type="checkbox" name="enabler" <%if allowEdit=true then%>checked<%end if%> onclick="location.href = 'admin.allowEditToggle.asp';">
	  <span class="slider round"></span>
	</label>
	  <div><%
	startTime = timer()
	'openDB "arabicUsers" 
	openDbLogger "arabicUsers","O","admin.asp","users",""
		mySQL = "SELECT loginLog.*,users.username, users.name FROM loginLog LEFT JOIN users ON users.id = loginLog.userID WHERE userID<>1 ORDER BY loginTimeUTC DESC"
		res.open mySQL, con
			 %><p>חיבור אחרון ב- <%=res("loginTimeUTC")%> ע"י <%=res("username")%>
			 	<br><small>הפסקנו לוג בנובמבר 2021</small>
			 </p><%
			
		res.close
	endTime = timer()
	durationMs = Int((endTime - startTime)*1000)
	'closeDB
	closeDbLogger "arabicUsers","C","admin.asp","users",durationMs,""	%>
	  	
	  </div>
</div>
<!--#include file="inc/trailer.asp"-->

</body>
</html>