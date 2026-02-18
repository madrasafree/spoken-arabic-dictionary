<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") < 7 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>היסטורית חיפושים</title>
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
	<script>
	$(document).ready(function(){
		$("h2").next("div").hide();
		$("h2").click(function() {
			$(this).next("div").slideToggle(200);
			$(this).find("span").text($(this).find("span").text() == '▼' ? '▶' : '▼');
		});
	});
	</script>
</head>

<body>
<!--#include file="inc/top.asp"--><%
dim countMe, nikud, nowUTC, actionUTC, whr, ha, i, heb
countMe = 0
nikud = "bg"


startTime = timer()
'openDB "arabicSearch"
openDbLogger "arabicSearch","O","admin.searchHistory.asp","single",""


mySQL = "SELECT now() FROM wordsSearched"
res.open mySQL, con
    nowUTC = res(0)
    nowUTC = DateAdd("h",7,nowUTC)
res.close %>

<div id="container">

	<div id="bread">
		<a href=".">מילון</a> / <%
		if session("userID")=1 then %>
	<%
		end if %>
		<h1>היסטורית חיפוש</h1>
	</div>


	<h2><a href="admin.searchHistory.last50.asp">50 חיפושים אחרונים</a></h2>

	<h2><a href="admin.searchHistory.noExact.asp?downFrom=100000">50  החיפושים הנפוצים - ללא תוצאה מדויקת</a></h2>

	<h2><a href="admin.searchHistory.noSentence.asp">50 החיפושים הנפוצים - ללא משפטים לדוגמא</a><h2>
	
	<h2><a href="admin.searchHistory.24h.asp">50 החיפושים הנפוצים - ב-24 השעות האחרונות</a></h2>
	
	<h2><a href="admin.searchHistory.7days.asp">50 החיפושים הנפוצים - ב-7 הימים האחרונים</a><h2>

	<h2><a href="admin.searchHistory.since2009.asp">50 החיפושים הנפוצים - מאז 2009</a></h2>


</div> <!-- container ends here --> <%
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSearch","C","admin.searchHistory.asp","single",durationMs,""

%>
<!--#include file="inc/trailer.asp"-->
</body>
</html>