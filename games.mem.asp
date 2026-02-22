<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>משחק זיכרון</title>
	<meta name="Description" content="משחק זיכרון המציג כל פעם 20 תמונות אקראיות עם הפירוש שלהן בעברית. לחיצה על התמונה תגלה את המילה הערבית. רעננו את הדף כדי לקבל 20 מילים חדשות." />
    <meta name="Keywords" content="משחק זיכרון, משחקים בערבית מדוברת" />
	<!--#include file="inc/header.asp"-->
    <style>
				#lingolearn button {
					background:white;
				}
				#lingolearn button:hover {
					background:yellow;
				}
        #wrapper {
	        width: 90%;
	        margin: 10px auto;
        }

        #columns {
	        -webkit-column-count: 1;
	        -webkit-column-gap: 10px;
	        -moz-column-count: 1;
	        -moz-column-gap: 10px;
	        column-count: 1;
	        column-gap: 15px;
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

<div id="pTitle">משחק זיכרון
	<span style="display:block; font-size:medium;">לחצו על תמונה כדי להציג את המילה בערבית</span>
</div>

<div style="margin:20px auto; text-align:center; font-size:small;">
	<button onClick="window.location.reload();">לחצו כאן</button> או רעננו את הדף  כדי להחליף את התמונות
</div>

<div id="wrapper">
	<div id="columns"><%

	'openDB "arabicWords"
	openDbLogger "arabicWords","O","games.mem.asp","single",""

    mySQL = "SELECT TOP 20 * FROM words WHERE show AND status=1 AND imgLink <> '' ORDER BY rnd(-(100000*words.id)*time())"
	res.open mySQL, con
	Do until res.EOF %>
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
	            </div>
            	<img class="img" src="<%=res("imgLink")%>" alt="<%=res("hebrewTranslation")%>" title="<%=res("imgCredit")%>" style="max-width:480px;" />
            </div>
        </div><%
		res.moveNext
	Loop
	res.close 
	
	'closeDB
	closeDbLogger "arabicWords","C","games.mem.asp","single",durationMs,""

	%>
	</div>
</div>

<script>

	$('body').on('click', '.pin' , function () {
		$(this).children('.txtDiv').slideToggle('slow');
	});

</script>


<hr/>

<div style="margin:20px auto; text-align:center;">
	<button onClick="window.location.reload();">לחצו כאן</button> או רעננו את הדף  כדי להחליף את התמונות
</div>





<!--#include file="inc/trailer.asp"-->