<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>ארגז חול - משפטים</title>
	<meta name="Description" content="נסיונות מילון על משפטים" />
	<!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
	<style>
		.arb {
			font-size:initial;
			}
		.heb {
			font-size:initial;
			}
		.highlight a:link,.highlight a:visited {
			color:red;
			}
		.info {
			background:#fefefe;
			border:1px solid #dedede;
			border-radius:4px;
			margin:5px 15px 15px 15px;
			padding:10px;
			}
		.normal {
			padding:0;
		}
		.normal a:link,.normal a:visited {
			border:0;
			box-shadow:none;
			color:#2ead31;
			padding:0;
			}
		.normal a:hover {
			background:yellow;
			text-decoration:none;
			}
		.sentence {
			background: #ffffff90;
			border: 1px solid #2ead32ab;
			border-radius: 0 10px 0 0;
			margin: 10px 0px;
			}
		.sentence > div {
			text-align:right;
		}
		.table {
			width:initial;
		}
		rt {
			font-size:60%;
		}

        @media (min-width:1000px) {
			.flex-container {
				display:flex;
				justify-content: center;
			}
			.flex-inner {
				flex: 1;
				min-width:320px;
			}		
		}
	</style>
	<script>
	$(function() {
		$("#toggleTaatik").click(function() {
			$("rt").slideToggle(function(){
				return false;
			});
		});
	});
	</script>
</head>
<body>
<!--#include file="inc/top.asp"-->


<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ארגז חול</a> / 
	<h1>משפטים</h1>
</div>


<div class="message warning">
	דף בבנייה
</div>

<div class="table" style="margin-top:20px;">

	<div style="margin-bottom:10px;">
		<a href="sentenceNew.asp">הוספת משפט חדש</a>
		<a href="#" id="toggleTaatik" style="float:left;">הסתר/הצג תעתיק</a>
	</div><%

	dim wordID, arabicFull, words,cls
	cls = "normal"


	startTime = timer()
	'openDB "arabicWords"
	openDbLogger "arabicWords","O","TEST.sentences.asp","single",""

	mySQL = "SELECT count(id) FROM sentences"
	res.open mySQL, con %>
	<div>מציג <%=res(0)%> משפטים</div><%
	res.close

	mySQL = "SELECT * FROM sentences ORDER BY id DESC"
	res.open mySQL, con
	if res.EOF then
		response.write " - EOF"
	else 
		do until res.EOF %>
			<div class="sentence flex-container">
				<div class="heb flex-inner">
					<a href="sentence.asp?sID=<%=res("id")%>"><%=res("hebrew")%></a>
				</div>
				<div class="arb flex-inner"><ruby><%
					arabicFull = res("arabic")
					words = split(arabicFull," ")
					mySQL = "SELECT * FROM wordsSentences WHERE sentence ="&res("id")&" ORDER BY location"
					res2.open mySQL, con
						dim current,wordLocation,i
						current=0
						do until res2.EOF
							wordLocation = res2("location")
							while wordLocation > current
								'REPLACE ADDED SPACE WITH VAR
								response.write words(current)&" "
								current = current+1
							wend
							if cstr(wordID)=cstr(res2("word")) then
								cls="normal highlight"
							end if %>
							<span class="<%=cls%>"> <a href="../word.asp?id=<%=res2("word")%>"><%=words(current)%></a> </span><%
							current = current+1
							cls="normal"
							res2.moveNext
						loop
						for i = current to ubound(words)
							response.write words(current)&" "
							current = current+1
						next
					res2.close
				%>
				<rt><%=shadaAlt(res("arabicHeb"))%></rt></ruby></div>
			</div><%
				if len(res("info"))>0 then %>
				<div class="info flex-inner"><%=res("info")%></div><%
				end if%><%
			res.moveNext
		loop
	end if
	res.close

	endTime = timer()
	durationMs = Int((endTime - startTime)*1000)
	'closeDB
	closeDbLogger "arabicWords","C","TEST.sentences.asp","single",durationMs,""


	%>
</div>
<!--#include file="inc/trailer.asp"-->