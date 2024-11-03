﻿<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>ניהול חיפושים קצרים</title>
    <META NAME="ROBOTS" CONTENT="NONE">
<!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="static/css/test.css" />
	<style>
		.wordsShort {
			margin:20px auto 40px auto;
			min-width:300px;
		}
		.wordsShort input {
			display:inline-block;
			max-width:70px;
		}
		.wordsShort td {
			padding:4px 14px;
		}
		.wordsShort th {
			background:gray;
			color:white;
			font-size:small;
			font-weight:100;
			padding:2px;
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
<!--#include file="inc/top.asp"-->
<div id="container">

	<div id="bread">
		<a href=".">מילון</a> / <%
		if session("userID")=1 then %>
		<a href="admin.asp">ניהול</a> / <%
		end if %>
		<h1>ניהול חיפושים קצרים</h1>
	</div>
	
	<table class="wordsShort">
		<tr>
			<th>ID</th>
			<th>sStr</th>
			<th>wordId</th>
			<th>עריכה</th>
		</tr><%

	if request("action")="new" then
		startTime = timer()
		'openDB "arabicWords"
		openDbLogger "arabicWords","O","admin.wordsShort.asp","new",""
			mySQL = "INSERT INTO wordsShort (sStr,wordID) VALUES ('"&request("sStrNew")&"',"&request("wordIdNew")&")"
			con.execute mySQL

		endTime = timer()
		durationMs = Int((endTime - startTime)*1000)
		'closeDB
		closeDbLogger "arabicWords","C","admin.wordsShort.asp","new",durationMs,""
	end if

	if request("action")="edit" then
		startTime = timer()
		'openDB "arabicWords"
		openDbLogger "arabicWords","O","admin.wordsShort.asp","edit",""
			if len(request("sStr"))>0 then
				mySQL = "UPDATE wordsShort SET sStr='"&request("sStr")&"', wordID="&request("wordId")&" WHERE id="&request("id")
			else
				mySQL = "DELETE FROM wordsShort WHERE id="&request("id")
			end if
			con.execute mySQL
		endTime = timer()
		durationMs = Int((endTime - startTime)*1000)
		'closeDB
		closeDbLogger "arabicWords","C","admin.wordsShort.asp","edit",durationMs,""
	end if


	startTime = timer()
	'openDB "arabicWords"
	openDbLogger "arabicWords","O","admin.wordsShort.asp","display",""
	mySQL = "SELECT * FROM wordsShort"
	res.open mySQL, con, 0, 1 'adOpenForwardOnly, adLockReadOnly
	do until res.EOF %>
		<tr>
			<form action=admin.wordsShort.asp method="get">
			<td>
				<input type="text" name="action" value="edit" style="display:none;" />
				<input type="number" name="id" value="<%=res("ID")%>" style="display:none;" /><%=res("ID")%>
			</td>
			<td>
				<input type="text" name="sStr" value="<%=res("sStr")%>" />
			</td>
			<td>
				<input type="number" name="wordId" value="<%=res("wordId")%>" />
			</td>
			<td>
				<div><button>עריכה</button></div>
			</td>
			</form>
		</tr><%
		res.moveNext
	loop
	res.close 
	
	
	endTime = timer()
	durationMs = Int((endTime - startTime)*1000)
	'closeDB
	closeDbLogger "arabicWords","C","admin.wordsShort.asp","display",durationMs,""
	
	%>

	<tr>
		<form action=admin.wordsShort.asp method="get">
		<td>
			<input type="text" name="action" value="new" style="display:none;"/>
		</td>
		<td>
			<input type="text" name="sStrNew" required/>
		</td>
		<td>
			<input type="number" name="wordIdNew" required />
		</td>
		<td>
			<button type="submit">הוסף</button>
		</td>
		</form>
	</tr>
	</table>

	<div style="margin:0 auto 30px auto; width:500px; max-width:90%; text-align:center;">
		<mark>
			כדי למחוק רשומה, מחק את המחרוזת ולחץ על עריכה
		</mark>
	</div>

</div> <!-- container ends here -->

<!--#include file="inc/trailer.asp"-->
</body>
</html>