<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>ארגז חול - השמעת סאונד</title>
	<meta name="Description" content="בדיקת אפשרויות שונות להשמעת סאונד במילון" />
	<!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
	<style>
	</style>
</head>
<body>
<!--#include file="inc/top.asp"-->


<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ארגז חול</a> / 
	<h1>השמעת סאונד</h1>
</div>

<br/>

<div class="table" style="font-size:small;">

	<audio id="audioPlayer">
		<source src="audio/test_ramadan_karim.ogg" type="audio/ogg">
		Your browser does not support the audio element.
	</audio>
	<div> 
		<button onclick="document.getElementById('audioPlayer').play()">Play</button> 
	</div>

</div>


<!--#include file="inc/trailer.asp"-->