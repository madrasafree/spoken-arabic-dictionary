<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") < 7 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>50 חיפושים אחרונים</title>
    <META NAME="ROBOTS" CONTENT="NONE">
<!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/arabic_utils.css" />
	<style>
		.bg {background: #F9F9F9;}
		.bg2 {background: #EAE6E6;}
		.bg td:hover, .bg2 td:hover {background:#BBEEBB;}
		.bg span,.bg2 span {padding: 2px 5px;}
		#bread {
			background: white;
			border: 1px solid gray;
			border-radius: 0;
			margin: 20px auto;
			padding: 4px 8px;
			}
		#container {
			margin:20px auto;
			width:90%;
			}
		.edit span {border:1px solid gray; padding:2px; background: #eee;}
		.edit input, button {margin-right: 10px;}
		h1 {
			display:inline-block;
			font-size:medium;
			margin:0;
			text-align: center;
			}
		h2 {
			cursor:pointer;
		}
		h2 > span {
			padding-right:10px;
		}
		.log {
			margin-top:20px;
		}
		.result0 {background:gray;}
		.result1 {background:#f9fff8; color:#63ad63;}
		.result2 {background:#ffe1ab; color: #b57a0c;}
		.result9 {background:#ffadad; color: #8c3f3f;}
		.result11 {background:#f9fff8; color:#313131;}
		.result21 {background:#ffe1ab; color:#313131;}
		.result91 {background:#ffadad; color:#313131;}
		.tbl {display:table; width:100%;}
		.tbl > div {display:table-row;}
		.tbl > div > span {
			border:1px dotted gray;
			display:table-cell;
			padding:4px;
			}
	</style>
</head>

<body>
<!--#include file="inc/top.asp"--><%
dim countMe, nikud, nowUTC, actionUTC, whr, ha, i, heb
countMe = 0
nikud = "bg"


startTime = timer()
'openDB "arabicSearch"
openDbLogger "arabicSearch","O","admin.searchHistory.last50.asp","single",""


mySQL = "SELECT now() FROM wordsSearched"
res.open mySQL, con
    nowUTC = res(0)
    nowUTC = DateAdd("h",7,nowUTC)
res.close %>

<div id="container">

	<div id="bread">
		<a href=".">מילון</a> /
		<a href="admin.searchHistory.asp">היסטורית חיפוש</a> /
		<h1>50 חיפושים אחרונים</h1>
	</div>

	<div>
		<div class="tbl">
			<div>
				<span>מתי</span>
				<span>מה חיפשו</span>
				<span>מה מצאו</span>
				<span>כמה פעמים חיפשו </span>
			</div><%
		mySQL = "SELECT TOP 50 * FROM latestSearched INNER JOIN wordsSearched ON latestSearched.searchID = wordsSearched.id ORDER BY searchTime DESC"
		res.open mySQL, con
		do until res.EOF
			actionUTC = Replace(res("searchTime"),"T"," ")
			actionUTC = Replace(actionUTC,"Z","") %>
			<div>
				<span title="UTC: <%=actionUTC%>"><%
					call secPast(actionUTC,nowUTC)
				%></span>
				<span><%=res("typed")%></span><%
				SELECT CASE res("result")
					case 0 %>
						<span class="result0">לא ידוע</span><%
					case 1 %>
						<span class="result1">תוצאה מדויקת ; משפט לדוגמא</span><%
					case 2 %>
						<span class="result2">תוצאות אחרות ; משפט לדוגמא</span><%
					case 9 %>
						<span class="result9">אין תוצאות בכלל ; משפט לדוגמא</span><%
					case 11 %>
						<span class="result11">תוצאה מדויקת ; אין משפט לדוגמא</span><%
					case 21 %>
						<span class="result21">תוצאות אחרות ; אין משפט לדוגמא</span><%
					case 91 %>
						<span class="result91">אין תוצאות בכלל ; אין משפט לדוגמא</span><%
					case else %>
						<span>-</span><%
				END SELECT %>
				<span><%=formatNumber(res("searchCount"),0)%></span>
			</div><%
			res.moveNext
		loop
		res.close %>
		</div>
		<div dir="ltr" style="text-align:left; font-size:small;">
			<%=mySQL%>
		</div>
	</div>

</div> <!-- container ends here --> <%
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSearch","C","admin.searchHistory.last50.asp","single",durationMs,""
%>
<!--#include file="inc/trailer.asp"-->
</body>
</html>