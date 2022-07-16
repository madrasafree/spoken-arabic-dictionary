<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
	<title>מילים עם תמונות</title>
	<meta name="Description" content="כל המילים שיש להם תמונה" />
	<!--#include file="inc/header.asp"-->
    <style>
        #wrapper {
	        width: 90%;
	        /*max-width: 1100px;
	        min-width: 800px;*/
	        margin: 50px auto;
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
	        padding-bottom: 5px;
	        background: -webkit-linear-gradient(45deg, #FFF, #F9F9F9);
	        opacity: 1;
	
	        -webkit-transition: all .2s ease;
	        -moz-transition: all .2s ease;
	        -o-transition: all .2s ease;
	        transition: all .2s ease;
        }

        .pin img {
	        width: 100%;
	        border-bottom: 1px solid #ccc;
	        padding-bottom: 15px;
	        margin-bottom: 5px;
        }

        .pin p {
	        font: 12px/18px Arial, sans-serif;
	        color: #333;
	        margin: 0;
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

        /*#columns:hover .pin:not(:hover) {
	        opacity: 0.4;
        }*/
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">מילים עם תמונות</div> 

<div id="wrapper">
	<div id="columns"><%

	startTime = timer()
	'openDB "arabicWords"
	openDbLogger "arabicWords","O","TEST.list.pics.asp","single",""

    mySQL = "SELECT * FROM words WHERE show AND imgLink <> ''"
	res.open mySQL, con
	Do until res.EOF %>
        <div class="pin" onclick="location.href='word.asp?id=<%=res("id")%>'">
                <img class="img" src="<%=res("imgLink")%>" alt="<%=res("hebrewTranslation")%>" title="<%=res("imgCredit")%>" style="max-width:480px;" />
            <span class="heb" style="float:right;"><%=res("hebrewTranslation")%></span>
            <span class="arb"><%=res("arabicWord")%></span>
            <span class="eng" style="float:left;"><%=res("pronunciation")%></span>
        </div><%
		res.moveNext
	Loop
	res.close 

	endTime = timer()
	durationMs = Int((endTime - startTime)*1000)
	'closeDB
	closeDbLogger "arabicWords","C","TEST.list.pics.asp","single",durationMs,""

	%>
	</div>
</div>





<br />
<!--#include file="inc/trailer.asp"-->