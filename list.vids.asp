<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>מילים עם סרטון</title>
	<meta name="Description" content="כל המילים שיש להם סירטון" />
	<!--#include file="inc/header.asp"-->
    <style>
        #center {text-align:center;}
        .heb {text-align: right;}
        .listDiv {width:320px; display:inline-block; border:1px dotted grey;}
        .youtube {width:320px; height:180px;}
        .listDiv > span {display:block; line-height: 15px;}
        
        @media (max-width:340px) {
            
            .arb {font-size:1.5em;}
            .listDiv {border:0;padding:0;margin-bottom:15px;}
        }
        
    </style>
    <script>
    $(document).ready(function(){
      $("#mediaClick").click(function(){
          $("#reportErr").hide();
          $("#toolsTable").slideToggle();
      });
    });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="pTitle">מילים עם סרטון</div>
<div style="max-width:500px; margin:0 auto; text-align: center;">
<div>
    <script src="https://apis.google.com/js/platform.js"></script>
    <div class="g-ytsubscribe" data-channelid="UCHnLvw-TCwckLXmjYozv9tw" data-layout="default" data-count="default"></div>
</div><%
dim countMe, lastLink
lastLink = ""
countMe = 0

'openDB "arabicWords"
openDbLogger "arabicWords","O","list.vids.asp","single",""


mySQL = "SELECT * FROM media WHERE mType=1"
res.open mySQL, con
    Do until res.EOF %>
        <div style="margin-bottom: 20px;"><%
            SELECT Case res("mType")
                case 1 'youtube' %>
                    <iframe class="youTube" src="//www.youtube.com/embed/<%=res("mLink")%>?rel=0&theme=light" allowfullscreen style="border:0;"></iframe><%
                case 21 'clyp.it' %>
                    <iframe width="100%" height="160" src="https://clyp.it/<%=res("mLink")%>/widget" frameborder="0"></iframe><%
                case 22 'soundcloud' %>
                    <iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/<%=res("mLink")%>&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe><%
                case else
            END SELECT
        mySQL = "SELECT words.* FROM wordsMedia INNER JOIN words ON wordsMedia.wordID=words.id WHERE mediaID="&res("id")
            res2.open mySQL, con
            if res2.EOF then %><div>סרטון זה לא משויך לאף מילה</div><%end if
            do until res2.EOF %>
                
<div class="listDiv" onclick="location.href='word.asp?id=<%=res2("id")%>'">
                    
                    <span class="heb" style="float: none; position: relative;">
                        <%=res2("hebrewTranslation")%>
                        <span style="display: inline-block; position: absolute; top: 0px; left:0px;"><%
                        if len(res2("imgLink"))>0 then %>
                            <img src="img/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="img" style="opacity: 0.6; float: none; position: absolute; top:4px; left: 20px;" /><%
                        end if
                        if res("id") then %>
                            <img src="img/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="img"  style="max-width:16px ; opacity: 0.8; float: none; position: absolute; top:9px; left: 46px;"/><%
                        end if
                        Select Case res2("status")
                        Case 1 %>
                            <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" style="width:15px;opacity:0.4; position: absolute; top:9px; left:5px;" /><%
                        Case -1 %>
                            <img src="img/site/erroneous.png" id="ערך זה סומן כלא תקין" alt="ערך זה סומן כלא תקין" title="ערך זה סומן כלא תקין" style="width:15px;opacity:0.7; position: absolute; top:9px; left:5px;" /><%
                        End Select %>
                        </span>
                    </span><%
                        if len(res2("arabic"))>0 then %>
                    <span class="arb" style="padding-top: 7px;">
                        <%=res2("arabic")%>
                    </span><%
                        end if %>
                    <span class="arb" style="padding: 10px 10px;"><%
                        dim ht
                        ht=res2("arabicWord")
                        if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
                            ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
                        end if %>
                        <%=ht%>                        
                    </span>
                    <span class="eng">
                        <%=res2("pronunciation")%>
                    </span>
                </div><%
                res2.moveNext
            Loop
            res2.close %>
        </div><%
        countMe = countMe + 1
		res.moveNext
	Loop
res.close 

'closeDB
closeDbLogger "arabicWords","C","list.vids.asp","single",durationMs,""


%>
<br>
</div>
<script src="https://milon.madrasafree.com/inc/youtube.js"></script>
<!--#include file="inc/trailer.asp"-->