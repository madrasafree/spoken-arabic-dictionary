<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") < 7 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>50 החיפושים הנפוצים - מאז 2009</title>
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


'openDB "arabicSearch"
openDbLogger "arabicSearch","O","admin.searchHistory.since2009.asp","single",""


mySQL = "SELECT now() FROM wordsSearched"
res.open mySQL, con
    nowUTC = res(0)
    nowUTC = DateAdd("h",7,nowUTC)
res.close %>

<div id="container">

	<div id="bread">
		<a href=".">מילון</a> /
		<a href="admin.searchHistory.asp">היסטורית חיפוש</a> /
		<h1>50 החיפושים הנפוצים - מאז 2009</h1>
	</div>

	<div><%
		mySQL = "SELECT TOP 50 * FROM wordsSearched ORDER BY searchCount DESC"
		res.open mySQL, con %>
		<div class="tbl">
			<div>
				<span>חיפוש מצטבר</span>
				<span>מה חיפשו?</span>
				<span>סוג תוצאה</span>
				<span>בקרה</span>
			</div><%
			do until res.EOF %>
				<div>
					<span><%=FormatNumber(res("searchCount"),0)%></span>
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
					<span><%
						if session("userID")=1 then %>
						<form action="admin.mark4translate.update.asp" method="post">
							<input name="id" type="hidden" value="<%=res("id")%>" />
							<select name="mark">
								<option value="0" <%if res("translated")>0 then%> selected <%end if%>>לא ידוע</option>
								<option value="1" <%if res("translated")=1 then%> selected <%end if%>>לא תורגם</option>
								<option value="5" <%if res("translated")=5 then%> selected <%end if%> title="לא כל המשמעויות תורגמו">חלקי</option>
								<option value="8" <%if res("translated")=8 then%> selected <%end if%>>תורגם</option>
								<option value="20" <%if res("translated")=20 then%> selected <%end if%>>תעתיק ערבי</option>
								<option value="21" <%if res("translated")=21 then%> selected <%end if%>>ג'יבריש</option>
								<option value="22" <%if res("translated")=22 then%> selected <%end if%>>קצר מדי</option>
								<option value="23" <%if res("translated")=23 then%> selected <%end if%>>תעתיק לועזי</option>
								<option value="24" <%if res("translated")=24 then%> selected <%end if%>>מספרים</option>
							</select>
							<button style="padding:0 4px;">עדכן</button>
						</form><%
						end if%>
					</span>
				</div><%
				res.moveNext
			loop
		res.close  %>
		</div>
		<div dir="ltr" style="font-size:small;">
			<%=mySQL%>
		</div>
	</div>

</div> <!-- container ends here --> <%
'closeDB
closeDbLogger "arabicSearch","C","admin.searchHistory.since2009.asp","single",durationMs,""

%>
<!--#include file="inc/trailer.asp"-->
</body>
</html>