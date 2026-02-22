<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>מילים עם אודיו</title>
	<meta name="Description" content="כל המילים שיש להם הקלטת אודיו" />
	<!--#include file="inc/header.asp"-->
    <style>
        .listDiv > span {display:block; line-height: 15px;}
        @media(max-width:600px) {
            .arb {font-size:1.5em;}
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>
        $(document).ready(function(){
            var cnt = $("#countMe").data("count");
            $("#wordsSum").html(cnt);
        });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"--><%
dim countMe, order
order = "hebrewTranslation"
Select case Left(Request("order")&"h",1)
    Case "e": order = "pronunciation"
    Case "a": order = "arabicWord"
End select
countMe = 0

'openDB "arabicWords"
openDbLogger "arabicWords","O","list.audio.asp","single",""


mySQL = "SELECT DISTINCT media.mType, words.* FROM words INNER JOIN (media INNER JOIN wordsMedia ON media.[id] = wordsMedia.[mediaID]) ON words.[id] = wordsMedia.[wordID] WHERE (((media.mType)=21) AND ((words.[show])=True)) ORDER BY "& order & ";"
res.open mySQL, con %>

<div id="pTitle"><span id="wordsSum"></span> מילים עם אודיו</div>

<table class="tableHeader">
	<tr>
		<td style="width:33%;text-align:right;">
            <%if order="hebrewTranslation" then %> עברית <img src="assets/images/site/sort.png" /><%else %> <a href="?order=h">עברית</a><%end if%></td>
		<td style="width:34%;text-align:center;">
            <%if order="arabicWord" then %> ערבית <img src="assets/images/site/sort.png" /><%else %> <a href="?order=a">ערבית</a><%end if%></td>
	    <td style="width:33%;" class="tdEng">
            <%if order="pronunciation" then %> הגייה <img src="assets/images/site/sort.png" /><%else %> <a href="?order=e">הגייה</a><%end if%></td>
	</tr>
</table><%
	Do until res.EOF %>
        <div class="listDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">
            <span class="heb" style="float: none; position: relative;"><%
            if len(res("imgLink"))>0 then%>
                <img src="assets/images/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="img" style="opacity: 0.6; float: none; position: absolute; top:4px; left: 20px;" /><%
            end if
            if res("mType") then %>
                <img src="assets/images/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="img"  style="max-width:16px ; opacity: 0.8; float: none; position: absolute; top:9px; left: 46px;"/><%
            end if %>
	            <%=res("hebrewTranslation")%><%
                Select Case res("status")
                Case 1 %>
                    <img src="assets/images/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" style="width:15px;opacity:0.4; position: absolute; top:9px; left:5px;" /><%
                Case -1 %>
                    <img src="assets/images/site/erroneous.png" id="ערך זה סומן כלא תקין" alt="ערך זה סומן כלא תקין" title="ערך זה סומן כלא תקין" style="width:15px;opacity:0.7; position: absolute; top:9px; left:5px;" /><%
                End Select %>
            </span><%
                if len(res("arabic"))>0 then %>
            <span class="arb" style="padding-top: 7px;">
                <%=res("arabic")%>
            </span><%
                end if %>
            <span class="arb" style="padding: 10px 10px;"><% 
                dim ht
                ht=res("arabicWord")
                if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
                    ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
                end if %>
                <%=ht%>
            </span>
            <span class="eng"><%=res("pronunciation")%></span>
        </div><%
	    countMe = countMe + 1
	    res.moveNext
	Loop
    res.close %>
<span id="countMe" data-count="<%=countMe%>"></span>
<br /><%

'closeDB
closeDbLogger "arabicWords","C","list.audio.asp","single",durationMs,""


%>
<!--#include file="inc/trailer.asp"-->