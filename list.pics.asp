<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>מילים עם תמונות</title>
	<meta name="Description" content="כל המילים שיש להם תמונה" />
	<!--#include file="inc/header.asp"-->
    <style>
        .listDiv > span {display:block; line-height: 15px;}
        @media(max-width:600px) {
            .arb {font-size:1.5em;}
        }
    </style>
</head>
<body>
<!--#include file="inc/top.asp"--><%
dim countMe, order
order = "hebrewTranslation"
Select case Left(Request("order")&"h",1)
    Case "e": order = "pronunciation"
    Case "a": order = "arabicWord"
End select
countMe = 0 %>

<div id="pTitle">מילים עם תמונות</div>

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

    'openDB "arabicWords"
    openDbLogger "arabicWords","O","list.pics.asp","single",""

    mySQL = "SELECT words.id, words.arabic, words.arabicWord, words.hebrewTranslation, words.pronunciation, words.imgLink, words.status, wordsMedia.mediaID FROM words left JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show ORDER BY "& order
	res.open mySQL, con
	Do until res.EOF
		if len(res("imgLink"))>0 then %>
            <div class="listDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">
                <span class="heb" style="float: none; position: relative;">
                <img src="assets/images/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="img" style="opacity: 0.6; float: none; position: absolute; top:4px; left: 20px;" /><%
                if res("mediaID") then %>
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
			end if
		    res.moveNext
		Loop
	    res.close 
        
    'closeDB
    closeDbLogger "arabicWords","C","list.pics.asp","single",durationMs,"" %>

<br>
<!--#include file="inc/trailer.asp"-->