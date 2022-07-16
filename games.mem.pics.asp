<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"--><%

dim LID,LName,LDesc,imgLink

LID = Request("LID")
if LID = "" then LID = 0

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","games.mem.pics.asp","list details",""

mySQL = "SELECT * FROM lists Where ID="&LID
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
closeDbLogger "arabicWords","C","games.mem.pics.asp","list details",durationMs,""


%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
		<title><%=LName%> - תמונות לחיצות</title>
		<meta name="Description" content="משחק זיכרון תמונות על בסיס רשימות אישיות של משתמשים" />
    <meta name="Keywords" content="משחק זיכרון, משחקים בערבית מדוברת" />
    <meta property="og:url"     content="https://rothfarb.info/ronen/arabic/games.mem.pics.asp?lid=<%=LID%>" />
    <meta property="og:type"     content="website" />
    <meta property="og:title"     content="<%=LName%> - תמונות לחיצות" />
    <meta property="og:description"     content="משחק זיכרון תמונות על בסיס רשימות אישיות של משתמשים" />
    <meta property="og:image"           content="https://rothfarb.info/ronen/arabic/img/lists/<%=LID%>.png" />
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

        #wrapper {
	        width: 90%;
	        margin: 10px auto;
        }

        #columns {
	        -webkit-column-count: 1;
	        -webkit-column-gap: 10px;
	        -webkit-column-fill: auto;
	        -moz-column-count: 1;
	        -moz-column-gap: 10px;
	        -moz-column-fill: auto;
	        column-count: 1;
	        column-gap: 15px;
	        column-fill: auto;
        }

        .pin {
	        cursor: pointer;
            text-align:center;
            display: inline-block;
	        background: #FEFEFE;
	        border: 2px solid #FAFAFA;
	        box-shadow: 0 1px 2px rgba(34, 25, 25, 0.4);
	        margin: 0 2px 15px;
	        -webkit-column-break-inside: avoid;
	        -moz-column-break-inside: avoid;
	        column-break-inside: avoid;
	        padding: 15px;
	        background: -webkit-linear-gradient(45deg, #FFF, #F9F9F9);
	        opacity: 1;
	
	        -webkit-transition: all .2s ease;
	        -moz-transition: all .2s ease;
	        -o-transition: all .2s ease;
	        transition: all .2s ease;
        }

        .pin img {
	        width: 100%;
	        opacity: 0.9;
	        border-radius: 15px;
        }

        @media (min-width: 580px) {
	        #columns {
		        -webkit-column-count: 2;
		        -moz-column-count: 2;
		        column-count: 2;
	        }
        }

        @media (min-width: 820px) {
	        #columns {
		        -webkit-column-count: 3;
		        -moz-column-count: 3;
		        column-count: 3;
	        }
        }

        @media (min-width: 960px) {
	        #columns {
		        -webkit-column-count: 4;
		        -moz-column-count: 4;
		        column-count: 4;
	        }
        }

        @media (min-width: 1100px) {
	        #columns {
		        -webkit-column-count: 5;
		        -moz-column-count: 5;
		        column-count: 5;
	        }
        }

 .txtDiv {
    display: none;
 	width:100%;
    border-top: 0px solid #ccc;
    padding-bottom: 15px;
  }

  
    </style>
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
	<li class="button" onclick="location.href='games.mem.list.asp?lid=<%=LID%>';">קלפי זיכרון</li>
	<li class="button active">תמונות לחיצות</li>
</ul>

<br><%

if len(LDesc)>0 then %>
<div id="tagTitle">
	<div style="font-weight: 100; font-size: .8em"><%=LDesc%></div>
</div><%
end if %>


<div id="wrapper">
	<div id="columns"><%

	startTime = timer()
	'openDB "arabicWords"
	openDbLogger "arabicWords","O","games.mem.pics.asp","main",""

	mySQL = "SELECT DISTINCT words.id, words.show, words.arabic, words.arabicWord, words.hebrewTranslation, words.hebrewDef, words.imgCredit, words.pronunciation, "&_
			"words.status, words.imgLink, wordsLists.listID, wordsMedia.mediaID, wordsLists.pos "&_
			"FROM (words INNER JOIN wordsLists ON words.id = wordsLists.wordID) LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID "&_
			"WHERE wordsLists.listID=" & LID & " ORDER BY words.imgLink DESC"
    
	res.open mySQL, con
	if not res.EOF then
        dim lastID
        lastID = 0
	    do until res.EOF
			if lastID <> res("id") then %>
				<div class="pin">
					<div class="txtDiv" style="font-size:larger; line-height:1.2em;">
						<div class="arb">
							<%=res("arabic")%>
						</div>
						<div class="arb">
							<%=res("arabicWord")%>
						</div>
						<div class="eng" style="text-align:left;">
							<%=res("pronunciation")%>
						</div>
					</div>
					<div>
						<div class="heb" style="text-align:right;padding-bottom:3px;"><%=res("hebrewTranslation")%><%
							if len(res("hebrewDef"))>0 then %>
							<span style="font-size:small;">(<%=trim(res("hebrewDef"))%>)</span><%
							end if %>
						</div><%
						if len(res("imgLink"))>0 then imgLink = res("imgLink") else imgLink = "img/site/noPhoto.jpg"
						%>
						<img class="img" src="<%=imgLink%>" alt="<%=res("hebrewTranslation")%>" title="<%=res("imgCredit")%>" style="max-width:480px;" />
					</div>
				</div><%
				lastID = res("id")
			end if
			res.moveNext
            'response.write "<br>lastID = "&lastID&" <br>res(id)="&res("id")
			'response.end
		loop
	end if
	res.close 
	
	endTime = timer()
	durationMs = Int((endTime - startTime)*1000)
	'closeDB
	closeDbLogger "arabicWords","C","games.mem.pics.asp","main",durationMs,""

	%>
	</div>
</div>

<script>

	$('body').on('click', '.pin' , function () {
		$(this).children('.txtDiv').slideToggle('slow');
	});

</script>


<!--#include file="inc/trailer.asp"-->