<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"--><%

dim LID,LName,Ldesc,countMe
countMe=0

LID = Request("LID")
if LID = "" then LID = 0

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","games.mem.list.asp","list details",""

mySQL = "SELECT * FROM lists WHERE id="&LID
res.open mySQL, con
	if res.EOF then
			session("msg") = "לא נמצאה רשימה עם המספר הסידורי המבוקש"
			response.redirect "lists.all.asp"
	end if
	LName = res("listName")
	LDesc = res("listDesc")
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","games.mem.list.asp","list details",durationMs,""

%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
		<title><%=LName%> - קלפי זיכרון</title>
		<meta name="Description" content="הפכו את הקלפים וגלו אם זכרתם נכון. זכרתם? השאירו אותו הפוך. לא זכרתם? החזירו חזרה ונסו שוב כשתסיימו לעבור על כל הקלפים" />
    <meta name="Keywords" content="משחק זיכרון, משחקים בערבית מדוברת" />
    <meta property="og:url"     content="https://milon.madrasafree.com/games.mem.list.asp?lid=<%=LID%>" />
    <meta property="og:type"     content="website" />
    <meta property="og:title"     content="<%=LName%> - קלפי זיכרון" />
    <meta property="og:description"     content="הפכו את הקלפים וגלו אם זכרתם נכון. זכרתם? השאירו אותו הפוך. לא זכרתם? החזירו חזרה ונסו שוב כשתסיימו לעבור על כל הקלפים" />
    <meta property="og:image"           content="https://milon.madrasafree.com/img/lists/<%=LID%>.png" />
	<!--#include file="inc/header.asp"-->
    <style>
		.viewMenu {
			list-style:none;
			padding:0;
		}

		.viewMenu li {
			display:inline;
		}

		.button {
			background:#ffffff;
			border:1px solid #4191c2;
			color:#4191c2;
			cursor:pointer;
			padding:5px 10px;
		}

		.button:hover:not(.active) {
			background:#41b0c2;
			color:white;
		}
		
		.active {
			background:#4191c2;
			color:white;
			cursor:initial;
		}

		.card {flex-basis:300px; height:150px; max-height:150px; display:grid; margin:10px; padding:5px;box-sizing: border-box; border-radius:5px; background: beige;border:1px solid GRAY; transform-style: preserve-3d; transition: all 0.75s ease-in-out;}
		.front,.back {display: flex; flex-direction: column;  justify-content: center;}
  		.card:hover {cursor:pointer;}
		.front {backface-visibility: hidden;border-radius: 6px;overflow: hidden;width: 100%;}
		.back {background: #eaeaed; color: #0087cc; text-align: center; transform: rotateY(180deg);}
		.heb {text-align: right; float: none;}
	</style>
	<script>
	$(document).ready(function() {
		$('.back').hide();

		$('.card').click(function() {
			var transform = $(this).css('transform');
			//alert(transform)
			if (transform == 'none') {
				$(this).css('transform', 'rotateY(180deg)');
				$(this).css('background', '#eaeaed');
				$('.back',this).show(200);
				}
			else {
				$(this).css('transform', 'none');
				$(this).css('background', 'beige');
				$('.back',this).hide(200);
			}
		});

		var cnt = $("#countMe").data("count");
		if (cnt > 1) $("#wordsSum").html(cnt + " מילים");

	});
	</script>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">
	<a href="lists.all.asp"><span style="font-size:medium;">רשימות אישיות</span></a>
	<br>
	<span style="display:block;"><%=LName%></span>
</div>

<br>
<ul class="table viewMenu" style="text-align:center;">
	<li class="button" onclick="location.href='lists.asp?id=<%=LID%>';" >רשימה</li> 
	<li class="button active">קלפי זיכרון</li>
	<li class="button" onclick="location.href='games.mem.pics.asp?lid=<%=LID%>';">תמונות לחיצות</li>
</ul>
<br><%

if len(LDesc)>0 then %>
<div id="tagTitle" style="width:90%;max-width:1050px;">
	<div style="font-weight: 100; font-size: .8em"><%=LDesc%></div>
</div><%
end if %>

<div style="width:90%; margin:0 auto;max-width:1050px; border:0px solid gray;">
	<div style="display:flex;flex-wrap:wrap;justify-content:space-around ;"><%

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","games.mem.list.asp","main",""

	mySQL = "SELECT * FROM words INNER JOIN wordsLists ON words.id=wordsLists.wordID WHERE show AND listID="&LID
	res.open mySQL, con
	Do until res.EOF %>
		<div class="card">
			<div class="back">
				<span class="heb" style="text-align:center; font-size:2em; margin-top:30px;">
					<%=res("hebrewTranslation")%><%
					if len(res("hebrewDef"))>0 then %>
					<span style="font-size:small;">(<%=res("hebrewDef")%>)</span><%
					end if%>
				</span>
			</div>
			<div class="front">
				<span class="arb" style="font-size:2em; margin:0;"><%=res("arabic")%></span>
				<span class="arb" style="font-size:2em;"><%=res("arabicWord")%></span>
				<span class="eng" style="vertical-align:bottom; text-align:center;"><%=res("pronunciation")%></span>
			</div>
		</div><%
		countMe = countMe + 1
		res.moveNext
	Loop
	res.close %>
	</div>
	<span id="countMe" data-count="<%=countMe%>"></span>
</div><%

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","games.mem.list.asp","main",durationMs,""

%>
<br>
<div class="table" style="font-size:medium; text-align:center;">
	<span id="wordsSum"></span>
</div>

<!--#include file="inc/trailer.asp"-->