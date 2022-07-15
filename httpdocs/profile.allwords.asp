<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
dim userId, name, username, d, gen, countMe, nikud

gen=""
countMe = 0
nikud = ""
userId = request("id")


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","profile.allwords.asp","user details",""

mySQL = "SELECT * FROM users WHERE id =" &userId
res.open mySQL, con
if res.EOF then
    session("msg") = "מספר משתמש לא קיים"
    Response.Redirect "default.asp"
else
    name = res("name")
    username = res("username")
end if
%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title><%=username%></title>
	<meta name="Description" content="שם המשתמש: <%=res("username")%>" />
    <!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="team/inc/arabicTeam.css" />
    <style>
        .listDiv > span {display:block; line-height: 15px;}
        @media(max-width:600px) {
            .arb {font-size:1.5em;}
        }
    </style>
</head>
<body>

<!--#include file="inc/top.asp"-->
<br />
<table class="table" style="background:white; box-shadow:4px 2px 5px -2px #888; margin-bottom:20px;">
    <tr style="vertical-align:top;">
        <td style="width:360px; text-align:right; padding:8px;">
	        <span style="display:block;"><%=username%></span>
	        <span style="font-size:small; line-height:15px;"><%=res("about")%></span>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="padding:8px; font-size: small;"><%
        if len(res("joindateUTC"))>0 then %>
            <span style="margin-bottom: 0px;">בצוות המילון מאז <%=Str2hebDate(res("joindateUTC"))%>.</span><%
        end if 
        res.close

        endTime = timer()
        durationMs = Int((endTime - startTime)*1000)
        'closeDB
        closeDbLogger "arabicUsers","C","profile.allwords.asp","user details",durationMs,""


        startTime = timer()
        'openDB "arabicWords"
        openDbLogger "arabicWords","O","profile.allwords.asp","words",""

        mySQL = "SELECT count(id) FROM words WHERE show AND creatorId =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">✚ <%=res(0)%> מילים חדשות</span><%
                end if
            end if
        res.close

        mySQL = "SELECT count(id) FROM history WHERE user =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">✓ <%=res(0)%> עריכות</span><%
                end if
            end if
        res.close %>
        </td>
        </tr>
</table><%

mySQL = "SELECT DISTINCT words.id, words.arabic, words.creationTimeUTC, words.arabicWord, words.hebrewTranslation, words.pronunciation, words.imgLink, words.status, wordsMedia.wordID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show AND creatorId = "&userId&" ORDER BY creationTimeUTC DESC"
res.open mySQL, con
if res.EOF then %>
    <div class="table">משתמש זה טרם הוסיף ערכים למילון</div><%
else%>
    <h4 class="table">כל המילים שהוסיף משתמש זה למילון:</h4>
    <table class="tableHeader">
	    <tr>
			<td style="width:33%;text-align:right;">עברית</td>
		    <td style="width:34%;text-align:center;">ערבית</td>
	        <td style="width:33%;" class="tdEng">הגייה</td>
	    </tr>
	</table><%
        Do until res.EOF
            d = res("creationTimeUTC")
            d = Replace(d,"T"," ")
            d = Replace(d,"Z","")
            if countMe mod 2 <> 0 Then nikud = "bg"%>
                <div class="listDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">

                    <span class="heb <%=nikud%>" style="float: none; position: relative;">
                        <%=res("hebrewTranslation")%>
                        <span style="display: inline-block; position: absolute; top: 0px; left:0px;"><%
                        if len(res("imgLink"))>0 then %>
                            <img src="img/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="img" style="opacity: 0.6; float: none; position: absolute; top:4px; left: 20px;" /><%
                        end if
                        if res("wordID") <> "" then %>
                            <img src="img/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="img" style="max-width:16px ; opacity: 0.7; float: none; position: absolute; top:9px; left: 46px;"/><%
                        end if
                        Select Case res("status")
                        Case 1 %>
                            <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" style="width:15px;opacity:0.4; position: absolute; top:9px; left:5px;" /><%
                        Case -1 %>
                            <img src="img/site/erroneous.png" id="ערך זה סומן כלא תקין" alt="ערך זה סומן כלא תקין" title="ערך זה סומן כלא תקין" style="width:15px;opacity:0.7; position: absolute; top:9px; left:5px;" /><%
                        End Select %>
                        </span>
                    </span><%
                        if len(res("arabic"))>0 then %>
                    <span class="arb harm" style="padding-top: 7px;">
                        <%=res("arabic")%>
                    </span><%
                        end if %>
                    <span class="arb <%=nikud%>" style="padding: 10px 10px;"><%
                        dim ht
                        ht=res("arabicWord")
                        if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
                            ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
                        end if %>
                        <%=ht%>                        
                    </span>
                    <span class="eng <%=nikud%>">
                        <%=res("pronunciation")%>
                        <span style="font-size:small;float:right; display:inline; color:gray; direction:rtl; padding-right:0px;">
                            <span style="display:inline;padding-right:0px;"><%=Day(d)%> ב<%=MonthName(Month(d))%>, <%=year(d)%></span>
                            <span style="display:inline; font-size:smaller;"><%=formatDateTime(d,4)%></span>
                        </span>
                    </span>
                </div>
            <%
            res.moveNext
            nikud = ""
            countMe = countMe + 1
        Loop %>
    <div class="results">נמצאו סה"כ <%=countMe%> מילים שמשתמש זה הוסיף.</div><%    
end if
res.close 


if (session("role") And 2)>0 then
    'mySQL = "SELECT words.id, words.arabic, words.creationTimeUTC, words.arabicWord, words.hebrewTranslation, words.pronunciation, words.status, words.imgLink, wordsLabels.labelID, wordsLinks.description FROM (words INNER JOIN wordsLabels ON words.id = wordsLabels.wordID) LEFT JOIN wordsLinks ON words.id = wordsLinks.wordID WHERE words.show=false AND words.creatorId =" &userId& " ORDER BY creationTimeUTC DESC"    
    mySQL = "SELECT words.id, words.arabic, words.creationTimeUTC, words.arabicWord, words.hebrewTranslation, words.pronunciation, words.imgLink, words.status, wordsMedia.wordID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show AND creatorId = "&userId&" ORDER BY creationTimeUTC DESC"
	res.open mySQL, con
    if res.EOF then %>
        <div style="width:310px; margin:4px auto; text-align:center; background:#fbf2f2; color:#bf2121; font-size:125%; padding:8px 0px;">לא נמצאו ערכים מוסתרים למשתמש זה</div><%
    else%>
        <table class="tableHeader">
	        <tr><td colspan="3">
                <h3>מילים מוסתרות</h3>
            </td></tr>
	        <tr>
			    <td style="width:33%;text-align:right;">עברית</td>
		        <td style="width:34%;text-align:center;">ערבית</td>
	            <td style="width:33%;" class="tdEng">הגייה</td>
	        </tr>
	    </table><%
        countMe = 0
        Do until res.EOF
            d = res("creationTimeUTC")
            d = Replace(d,"T"," ")
            d = Replace(d,"Z","")
            if countMe mod 2 <> 0 Then nikud = "bg"%>
                <div class="listDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">

                    <span class="heb <%=nikud%>" style="float: none; position: relative;">
                        <%=res("hebrewTranslation")%>
                        <span style="display: inline-block; position: absolute; top: 0px; left:0px;"><%
                        if len(res("imgLink"))>0 then %>
                            <img src="img/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="img" style="opacity: 0.6; float: none; position: absolute; top:4px; left: 20px;" /><%
                        end if
                        if res("wordID") <> "" then %>
                            <img src="img/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="img" style="max-width:16px ; opacity: 0.7; float: none; position: absolute; top:9px; left: 46px;"/><%
                        end if
                        Select Case res("status")
                        Case 1 %>
                            <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" style="width:15px;opacity:0.4; position: absolute; top:9px; left:5px;" /><%
                        Case -1 %>
                            <img src="img/site/erroneous.png" id="ערך זה סומן כלא תקין" alt="ערך זה סומן כלא תקין" title="ערך זה סומן כלא תקין" style="width:15px;opacity:0.7; position: absolute; top:9px; left:5px;" /><%
                        End Select %>
                        </span>
                    </span><%
                        if len(res("arabic"))>0 then %>
                    <span class="arb harm" style="padding-top: 7px;">
                        <%=res("arabic")%>
                    </span><%
                        end if %>
                    <span class="arb <%=nikud%>" style="padding: 10px 10px;"><%
                        ht=res("arabicWord")
                        if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
                            ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
                        end if %>
                        <%=ht%>                        
                    </span>
                    <span class="eng <%=nikud%>">
                        <%=res("pronunciation")%>
                        <span style="font-size:small;float:right; display:inline; color:gray; direction:rtl; padding-right:0px;">
                            <span style="display:inline;padding-right:0px;"><%=Day(d)%> ב<%=MonthName(Month(d))%>, <%=year(d)%></span>
                            <span style="display:inline; font-size:smaller;"><%=formatDateTime(d,4)%></span>
                        </span>
                    </span>
                </div>
            <%
            res.moveNext
            nikud = ""
            countMe = countMe + 1
        Loop %>
    <div class="results">נמצאו <%=countMe%> מילים מוסתרות </div><%    
    end if
    res.close 
end if 

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","profile.allwords.asp","words",durationMs,""


%>
<!--#include file="inc/trailer.asp"-->