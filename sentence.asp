<!--#include file="includes/inc.asp"-->
<!--#include file="includes/functions/functions.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title></title>
	<meta name="Description" content="נסיונות מילון על משפטים" />
	<!--#include file="includes/header.asp"-->
	<link rel="stylesheet" href="assets/css/arabic_utils.css" />
	<style>
		.sentence {background: #ffffff90; margin: 10px 0px 5px 0px ; border-radius:4px; box-shadow:rgba(0,0,0,0.45) 2px 2px 22px -3px;}
		.info {border:1px solid #dedede; border-radius:4px; margin:0px 36px 15px 0px; padding:10px; background:#ffffff90;}
		.tools {border:1px solid #f5c10c7d; border-radius:4px; margin:15px auto; padding:10px; background:#ffffff90; font-size:small;}

		.normal a:link,.normal a:visited {
			color:#2ead31;
			border-bottom:0 dashed #2ead31;
			padding: 0 4px;
			}

		.normal a:hover {
			background:yellow;
			text-decoration:none;
			}
		.highlight a:link,.highlight a:visited {
			color:red;
			}
		.arb {background:#4caf5010; padding:5px;}
		.heb {font-size:1.4em; padding:12px 0 10px 0; border-top:2px dotted #bebebe;}

		.notice {margin-top:40px; text-align:center; padding: 5px 0; font-size:small;}
		.simuLev {color:#ad8722;border:solid #f5bd00; border-width:1px 0; background-color: #ffff0037;}

		@media (max-width:490px) {
			.heb {float:initial;}
		}

	</style>
	<script>
        $(document).ready(function(){

			$(document).prop('title', $(".heb").text()+" - תרגום לערבית");

		});
	</script>
</head>
<body>
<!--#include file="includes/top.asp"-->


<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin/">ניהול</a> / <%
	end if %>
	<a href="sentences.asp">משפטים</a> / 
	<h1>משפט</h1>
</div>

<br/><%

'openDB "arabicWords"
openDbLogger "arabicWords","O","sentence.asp","single",""

dim sID, arabicFull, words,nextS,prevS,maxSID,minSID
sID = request("sID")

if len(sID)=0 then
	session("msg") = "חסר מספר סידורי של המשפט"
	response.redirect "."
end if

mySQL = "SELECT MAX(id) AS maxSID FROM sentences"
res.open mySQL, con
	maxSID = res(0)
res.close

mySQL = "SELECT MIN(id) AS minSID FROM sentences"
res.open mySQL,con
	minSID = res(0)
res.close

mySQL = "SELECT TOP 1 * FROM sentences INNER JOIN wordsSentences ON sentences.id=wordsSentences.sentence WHERE sentences.id < "&sID&" ORDER BY sentences.id DESC"
res.open mySQL, con
	if res.EOF then
		prevS = maxSID
	else
		prevS = res(0)
	end if
res.close

mySQL = "SELECT TOP 1 * FROM sentences INNER JOIN wordsSentences ON sentences.id=wordsSentences.sentence WHERE sentences.id > "&sID&" ORDER BY sentences.id"
res.open mySQL, con
	if res.EOF then
		nextS = minSID
	else
		nextS = res(0)
	end if
res.close


mySQL = "SELECT * FROM wordsSentences WHERE sentence="&sID
res.open mySQL, con
if res.EOF then
	mySQL = "SELECT * FROM sentences WHERE sentences.id="&sID
else
	mySQL = "SELECT * FROM sentences INNER JOIN wordsSentences ON sentences.id=wordsSentences.sentence WHERE sentences.id="&sID
end if 
res.close

res.open mySQL, con

%>	
<div class="table" style="font-size:small;">
	<table style="width:100%;">
		<tr>
			<td title="למשפט הקודם"><a href="sentence.asp?sID=<%=prevS%>"><span class="material-icons">skip_next</span></a></td>
			<td style="text-align:center;">
				<span style="opacity:.6;">מס"ד <%=res("id")%></span>
			</td>
			<td title="למשפט הבא" style="text-align:left;"><a href="sentence.asp?sID=<%=nextS%>"><span class="material-icons">skip_previous</span></a></td>
		</tr>
	</table>
</div>
<div class="sentence">
	<div class="arb" style="font-size:2em;"><%
		dim merge,spanPos
		spanPos = "start"
		arabicFull = res("arabic")
		words = split(arabicFull," ")
		mySQL = "SELECT * FROM wordsSentences WHERE sentence ="&res("id")&" ORDER BY location"
		res2.open mySQL, con
			dim current,wordLocation,i
			current=0
			do until res2.EOF
				wordLocation = res2("location")
				merge = res2("merge")
				while wordLocation > current
					'REPLACE ADDED SPACE WITH VAR
					response.write words(current)&" "
					current = current+1
				wend
			
				' if merge>=1 then open span 
				if merge >= 1 then %>
					<span class="normal"><a href="word.asp?id=<%=res2("word")%>"><%
				end if
				' print word
				response.write words(current)

				' if merge>=2 then add space after word
				if merge>=2 then response.write " "

				' if merge=<1 then close span 
				if merge =< 1 then %></a></span> <%
				end if


				current = current+1
				res2.moveNext
			loop
			for i = current to ubound(words) %>
				<span><%=words(current)%></span><%
			
				current = current+1
			next
		res2.close
	%>
	</div>
	<div class="arb"><%=res("arabicHeb")%></div>
	<div style="display:none;" class="arb arabicHeb"><%=res("arabicHeb")%></div>
	<div class="heb" style="text-align:center;"><%=res("hebrew")%></div>
</div><%
if len(res("info"))>0 then %>
<span title="הערות" style="position:relative; color: #9e9e9e;top: 34px; right:4px; opacity:0.5;"><img src="assets/images/site/info.png" style="width:24px;"/></span>
<div class="info"><%=res("info")%></div><%
end if
res.close


'closeDB
closeDbLogger "arabicWords","C","sentence.asp","single",durationMs,""

%>




<div class="notice simuLev">
	<span style="font-weight:bold;">פרויקט משפטים בהתהוות</span>
 - ייתכנו תקלות. אנא היאזרו בסבלנות
</div>

<div class="table">
	<table style="width:100%;">
		<tr>
			<td>
				<span class="material-icons" style="color:#f5bd00bf;" title="כלים">build</span>
			</td>
			<td>
				<div class="tools"><%
				if session("role")>6 or session("userID")=90 then %>
					<a href="sentenceEdit.asp?sID=<%=sID%>">עריכת המשפט</a> |
					<a href="sentenceNew.asp">הוספת משפט חדש</a><%
				else%>
					הוספה ועריכת משפטים - זמין כרגע לעורכים בלבד<%
				end if%>
				</div>
			</td>
		</tr>
	</table>
</div>

<div style="font-size:small;">
	<ul><u>עוד בדף זה בהמשך:</u>
		<li>היסטוריית עריכות</li>
		<li>שיוך למדיה</li>
		<li>שמירה למועדפים</li>
		<li>הוספה לרשימות</li>
	</ul>
</div>

<!--#include file="includes/trailer.asp"-->