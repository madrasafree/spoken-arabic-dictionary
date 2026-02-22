<!--#include file="inc/inc.asp"--><%
dim userId, name, username, d, gen, countMe, nikud

gen=""
countMe = 0
nikud = ""
if len(request("id"))>0 then
    userId = request("id")
else
    session("msg") = "לא התקבל מספר משתמש"
    response.redirect request.ServerVariables("HTTP_REFERER")
end if


'openDB "arabicUsers"
openDbLogger "arabicUsers","O","profile.asp","user details",""


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
	<meta name="Description" content="כל המילים שהוסיף המשתמש <%=res("username")%>" />
    <!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="team/inc/arabicTeam.css" />
    <style>
        #boxMenu {min-width:320px; max-width:490px; margin:20px auto; text-align: center;}
        #boxMenu > div {background-color:#e4e3e2;display: inline-block; margin-top:5px; opacity:.7;}
        #boxMenu > div:hover {opacity:1;}
        #boxMenu > div > a:hover {text-decoration:none;}
        #boxMenu > div > a > div {display:flex;justify-content:center;align-items:center;width:70px;height:64px;color:black;}
        #boxMenu img {opacity: .7;}
        #boxMenu img:hover {opacity: 1;}

        #audio, #video, #lists, #words, #edits {max-width: 490px;
    margin: 0 auto;
    border: 1px solid #b8b7b8;
    background: rgb(255, 255, 255);
    box-shadow: rgb(245, 251, 254) 0px 6px 17px;
    padding: 10px;}

        .listDiv > span {display:block; line-height: 15px;}
        @media(max-width:600px) {
            .arb {font-size:1.5em;}
        }
    </style>
    <script>
        $(document).ready(function(){


            function hideall(){
                $("#lists").hide();
                $("#words").hide();
                $("#edits").hide();
                $("#audio").hide();
                $("#video").hide();
                return false;
            };

            hideall();


            $("#showLists").click(function(){
                hideall();
                $("#lists").delay(50).fadeToggle();
            });


            $("#showWords").click(function(){
                hideall();
                $("#words").delay(50).fadeToggle();
            });


            $("#showEdits").click(function(){
                hideall();
                $("#edits").delay(50).fadeToggle();
            });

            $("#showAudio").click(function(){
                hideall();
                $("#audio").delay(50).fadeToggle();
            });

            $("#showVideo").click(function(){
                hideall();
                $("#video").delay(50).fadeToggle();
            });


        });
    </script>
</head>
<body>
<!--#include file="team/inc/time.asp"-->
<!--#include file="inc/top.asp"-->
<br />
<table class="table" style="background:white; box-shadow:4px 2px 5px -2px #888;">
    <tr style="vertical-align:top;">
        <td style="width:360px; text-align:right; padding:8px;">
	        <span style="display:block;"><%=username%></span>
	        <span style="font-size:small; line-height:15px;"><%=res("about")%></span>
        </td>
        <td style="width:130px; text-align:left;"><% 
            if res("gender")="2" then 
                gen="fe"
            else
                gen=""
            end if
            if res("picture")=true then %>
                <img src="img/profiles/<%=res("id")%>.png" style="height:128px;" title="<%=username%>'s avatar" /> <%
            else %>
                <img src="img/profiles/<%=gen %>male.png" style="height:128px;" title="<%=username%>'s avatar" /><%
            end if %>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="padding:8px; font-size: small;"><%
        if len(res("joindateUTC"))>0 then %>
            <span style="margin-bottom: 0px;">תאריך הצטרפות למילון -  <%=Str2hebDate(res("joinDateUTC"))%>.</span><%
        end if 

        'closeDB
        closeDbLogger "arabicUsers","C","profile.asp","user details",durationMs,""



        'openDB "arabicWords"
        openDbLogger "arabicWords","O","profile.asp","main",""

        dim isWords,isEdits,isLists,isAudio,isVideo
        mySQL = "SELECT count(id) FROM words WHERE show AND creatorId =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">✚ <%=res(0)%> מילים חדשות</span><%
                isWords=true
                end if
            end if
        res.close

        mySQL = "SELECT count(id) FROM history WHERE user =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">✓ <%=res(0)%> עריכות</span><%
                isEdits=true
                end if
            end if
        res.close

        mySQL = "SELECT count(id) FROM lists WHERE creator =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">≣ <%=res(0)%> רשימות</span><%
                isLists=true
                end if
            end if
        res.close 

        mySQL = "SELECT count(id) FROM media WHERE mType=1 AND speaker =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">► <%=res(0)%> הקלטות וידאו</span><%
                isVideo=true
                end if
            end if
        res.close

        mySQL = "SELECT count(id) FROM media WHERE mType=21 AND speaker =" &userId
        res.open mySQL, con
            if not res.EOF then 
                if res(0)>0 then %>
                <span style="display: block;">♫ <%=res(0)%> הקלטות אודיו</span><%
                isAudio=true
                end if
            end if
        res.close %>


        </td>
        </tr>
</table>



<!-- TILE MENU-->
<div id="boxMenu"><%
    if isLists=true then %>
    <div>
        <a href="#"><div id="showLists">רשימות שאספתי</div></a>
    </div><%
    end if
    if isWords=true then %>
    <div>
        <a href="#"><div id="showWords">מילים שהוספתי</div></a>
    </div><%
    end if
    if isEdits=true then %>
    <div>
        <a href="#"><div id="showEdits">מילים שערכתי</div></a>
    </div><%
    end if
    if isAudio=true then %>
    <div>
        <a href="#"><div id="showAudio">אודיו שהקלטתי</div></a>
    </div><%
    end if
    if isVideo=true then %>
    <div>
        <a href="#"><div id="showVideo">וידאו שהקלטתי</div></a>
    </div><%
    end if %>
</div>


<div id="lists"><%
mySQL = "SELECT * FROM lists WHERE creator =" &userId
res.open mySQL, con
    if res.EOF then %>
        משתמש זה טרם יצר רשימות<%
    else %>
        <div class="table" style="margin-bottom: 25px;">
        <h4 class="table">רשימות:</h4>
        <ul style="line-height: 1.3em;"><%
        do until res.EOF %>
            <li><a href="lists.asp?id=<%=res("id")%>"><%=res("listName")%></a></li><%
            res.moveNext
        loop %>
        </ul>
        </div><%
    end if
res.close %>
</div>

<div id="words"><%
mySQL = "SELECT TOP 10 words.id, words.arabic, words.creationTimeUTC, words.arabicWord, words.hebrewTranslation, words.pronunciation, words.imgLink, words.status, wordsMedia.wordID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show AND creatorId = "&userId&" ORDER BY creationTimeUTC DESC"
res.open mySQL, con
if res.EOF then %>
    <div class="table">משתמש זה טרם הוסיף ערכים למילון</div><%
else
    Do until res.EOF
        d = res("creationTimeUTC")
        d = Replace(d,"T"," ")
        d = Replace(d,"Z","") %>
        <div class="listDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">
            <span class="heb" style="float: none; position: relative;">
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
            <span class="eng">
                <%=res("pronunciation")%>
                <span style="font-size:small;float:right; display:inline; color:gray; direction:rtl; padding-right:0px;">
                    <span style="display:inline;padding-right:0px;"><%=Day(d)%> ב<%=MonthName(Month(d))%>, <%=year(d)%></span>
                    <span style="display:inline; font-size:smaller;"><%=formatDateTime(d,4)%></span>
                </span>
            </span>
        </div><%
        res.moveNext
        nikud = ""
        countMe = countMe + 1
    Loop 
end if
res.close %>

<div class="results">מציג <%=countMe%> מילים אחרונות.<%
    mySQL = "SELECT count(ID) FROM words WHERE creatorId = "&userId
    res.open mySQL, con
    if res(0) > 10 then %>
        <br/>לצפייה בכל המילים שהוסיף משתמש זה,<a href="profile.allwords.asp?id=<%=userID%>"> לחצו כאן</a><%
    end if
    res.close %>
</div><%


if (session("role") And 2)>0 then
	mySQL = "SELECT * FROM words WHERE show=false AND creatorId =" &userId& " ORDER BY creationTimeUTC DESC"
	res.open mySQL, con
    if res.EOF then %>
        <div style="width:310px; margin:4px auto; text-align:center; background:#fbf2f2; color:#bf2121; font-size:125%; padding:8px 0px;">לא נמצאו ערכים מוסתרים למשתמש זה</div><%
    else%>
        <table class="tableHeader">
	        <tr><td colspan="3">
                <h3>מילים מוסתרות</h3>
            </td></tr>
	    </table><%
        countMe = 0
        Do until res.EOF
            d = res("creationTimeUTC")
            d = Replace(d,"T"," ")
            d = Replace(d,"Z","") %>
            <div class="listDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">

                <span class="heb" style="float: none; position: relative;">
                    <%=res("hebrewTranslation")%>
                    <span style="display: inline-block; position: absolute; top: 0px; left:0px;">
                        <img src="img/site/hidden.png" alt="מילה זו מוסתרת מעיני הגולשים" title="מילה זו מוסתרת מעיני הגולשים" style="width:15px;opacity:0.7; position: absolute; top:9px; left:5px;" />
                    </span>
                </span><%
                    if len(res("arabic"))>0 then %>
                <span class="arb" style="padding-top: 7px;">
                    <%=res("arabic")%>
                </span><%
                    end if %>
                <span class="arb" style="padding: 10px 10px;"><%
                    ht=res("arabicWord")
                    if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
                        ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
                    end if %>
                    <%=ht%>                        
                </span>
                <span class="eng">
                    <%=res("pronunciation")%>
                    <span style="font-size:small;float:right; display:inline; color:gray; direction:rtl; padding-right:0px;">
                        <span style="display:inline;padding-right:0px;"><%=Day(d)%> ב<%=MonthName(Month(d))%>, <%=year(d)%></span>
                        <span style="display:inline; font-size:smaller;"><%=formatDateTime(d,4)%></span>
                    </span>
                </span>
            </div><%
            res.moveNext
            countMe = countMe + 1
        Loop %>
    <div class="results">נמצאו <%=countMe%> מילים מוסתרות </div><%    
    end if
    res.close 
end if %>
</div>




<div id="edits"><%


dim lblCNT
mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
    lblCNT = res(0)
res.close

redim labelNames(lblCNT)
dim a,x,i,timePast,cTime,nowUTC
i=1

mySQL = "SELECT now() FROM words"
res.open mySQL, con
    nowUTC = res(0)
    nowUTC = DateAdd("h",7,nowUTC)
res.close

mySQL = "SELECT TOP 50 * FROM (SELECT * FROM history LEFT JOIN (SELECT ID,username FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON history.[user]=T.ID WHERE T.ID="&userID&" ORDER BY actionUTC DESC)"
res.open mySQL, con
Do until res.EOF
    d = res("actionUTC")
    d = Replace(d,"T"," ")
    d = Replace(d,"Z","") %>
    <div style="margin-bottom:20px;">
        <div class="changeTop">
            <div title="<%=d%>" style="font-size:small;"><%
                timePast = dateDiff("s",d,nowUTC)
                'response.write timePast
                if timePast =< 60 then
                    response.write "לפני " &timepast& " שניות"
                else
                    if timePast =< 86400 then
                        if timepast/60 < 60 then 
                            response.write "לפני " &round(timepast/60)& " דקות"
                        else
                            response.write "לפני " &round(timepast/60/60)& " שעות"
                        end if
                    else
                        if timePast =< 172800 then
                            response.write "אתמול"
                        else
                            response.write FormatDateTime(d,1)
                        end if
                    end if
                end if%>
            </div>
            
            <span style="font-weight:bold;"><%
                Select Case res("action")
                Case 1
                    response.write "מילה חדשה"
                Case 2
                    response.write "חשד לטעות. בקשה לבדיקה"
                Case 3
                    response.write "נבדק ונמצא תקין"
                Case 4
                    response.write "תיקון טעויות"                        
                Case 5
                    response.write "הסתרה"
                Case 6
                    response.write "ביטול הסתרה"
                Case 7
                    response.write "שליחה לארכיב"
                Case 8
                    response.write "החזרה מארכיב" 
                End Select %>
            </span>
            <span>
                <a href="word.asp?id=<%=res("word")%>"><%
                if res("hebrewNew")<>"" then%>
                    <%=res("hebrewNew")%> <%
                else
                    mySQL = "SELECT hebrewTranslation FROM words WHERE id="&res("word")
                    if not res.EOF then
                        res2.open mySQL, con
                            response.write res2(0)
                        res2.close
                    else
                        response.write "<b>res.EOF</b>"
                    end if
                end if %></a>
            </span> (<%=res("word")%>)<%
            if trim(res("explain"))<>"" then %>
                <div style="font-size:small; font-style:italic;">הסבר לפעולה: <%=res("explain")%></div><%
            end if %>
        </div><%
        Select Case res("action")
        Case 1
            response.write "מילה חדשה"
        Case 2
            response.write "חשד לטעות. בקשה לבדיקה"
        Case 3
            response.write "נבדק ונמצא תקין"
        Case 4 %>
            <div class="hisTable" style="border:0; box-shadow:#cad5de 1px 1px 5px 1px;"><%

                if res("hebrewNew")<>res("hebrewOld") then %>
                <div>
                    <span class="field">עברית</span>
                    <span class="new"><%=res("hebrewNew")%></span>
                    <span class="old"><%=res("hebrewOld")%></span>
                </div><%
                end if

                if res("hebrewDefNew")<>res("hebrewDefOld") then %>
                <div>
                    <span class="field">פירושון</span>
                    <span class="new"><%=res("hebrewDefNew")%></span>
                    <span class="old"><%=res("hebrewDefOld")%></span>
                </div><%
                end if

                if res("arabicNew")<>res("arabicOld") then%>
                <div>
                    <span class="field">ערבית</span>
                    <span class="new"><%=res("arabicNew")%></span>
                    <span class="old"><%=res("arabicOld")%></span>
                </div><%
                end if
                
                if res("arabicWordNew")<>res("arabicWordOld") then%>
                <div>
                    <span class="field">תעתיק עברי</span>
                    <span class="new"><%=res("arabicWordNew")%></span>
                    <span class="old"><%=res("arabicWordOld")%></span>
                </div><%
                end if

                if res("pronunciationNew")<>res("pronunciationOld") then%>
                <div>
                    <span class="field">תעתיק לועזי</span>
                    <span class="new"><%=res("pronunciationNew")%></span>
                    <span class="old"><%=res("pronunciationOld")%></span>
                </div><%
                end if

                if res("statusNew")<>res("statusOld") then %>
                <div>
                    <span class="field">סטטוס</span>
                    <span class="new"><%
                        Select Case res("statusNew")
                        Case 1
                            response.write "תקין"
                        Case 0
                            response.write "לא נבדק"
                        Case -1
                            response.write "טעות"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                    <span class="old"><%
                        Select Case res("statusOld")
                        Case 1
                            response.write "תקין"
                        Case 0
                            response.write "לא נבדק"
                        Case -1
                            response.write "טעות"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                </div><%
                end if 

                if res("showNew")<>res("showOld") then %>
                <div>
                    <span class="field">תצוגה</span>
                    <span class="new"><%
                        if res("showNew")=True then %>מוצג<%else%>מוסתר<%end if%>
                    </span>
                    <span class="old"><%
                        if res("showOld")=True then %>מוצג<%else%>מוסתר<%end if%>
                    </span>
                </div><%
                end if

                if res("searchStringNew")<>res("searchStringOld") then%>
                <div>
                    <span class="field">מילות חיפוש</span>
                    <span class="new"><%=res("searchStringNew")%></span>
                    <span class="old"><%=res("searchStringOld")%></span>
                </div><%
                end if

                if res("rootNew")<>res("rootOld") then%>
                <div>
                    <span class="field">צורת מקור</span>
                    <span class="new"><%=res("rootNew")%></span>
                    <span class="old"><%=res("rootOld")%></span>
                </div><%
                end if

                if res("partOfSpeachNew")<>res("partOfSpeachOld") then%>
                <div>
                    <span class="field">חלק דיבר</span>
                    <span class="new"><%
                        Select Case res("partOfSpeachNew")
                        Case 0
                            response.write "לא ידוע / אחר"
                        Case 1
                            response.write "שם עצם"
                        Case 2
                            response.write "שם תואר"
                        Case 3
                            response.write "פועל"
                        Case 4
                            response.write "תואר הפועל"
                        Case 5
                            response.write "מילית יחס"
                        Case 6
                            response.write "מילת חיבור"
                        Case 7
                            response.write "מילת קריאה"
                        Case 8
                            response.write "תחילית"
                        Case 9
                            response.write "סופית"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                    <span class="old"><%
                        Select Case res("partOfSpeachOld")
                        Case 0
                            response.write "לא ידוע / אחר"
                        Case 1
                            response.write "שם עצם"
                        Case 2
                            response.write "שם תואר"
                        Case 3
                            response.write "פועל"
                        Case 4
                            response.write "תואר הפועל"
                        Case 5
                            response.write "מילית יחס"
                        Case 6
                            response.write "מילת חיבור"
                        Case 7
                            response.write "מילת קריאה"
                        Case 8
                            response.write "תחילית"
                        Case 9
                            response.write "סופית"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                </div><%
                end if

                if res("genderNew")<>res("genderOld") then%>
                <div>
                    <span class="field">מין</span>
                    <span class="new"><%
                        Select Case res("genderNew")
                        Case 0
                            response.write "נטרלי"
                        Case 1
                            response.write "זכר"
                        Case 2
                            response.write "נקבה"
                        Case 3
                            response.write "לא ידוע / לא רלוונטי"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                    <span class="old"><%
                        Select Case res("genderOld")
                        Case 0
                            response.write "נטרלי"
                        Case 1
                            response.write "זכר"
                        Case 2
                            response.write "נקבה"
                        Case 3
                            response.write "לא ידוע / לא רלוונטי"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                </div><%
                end if

                if res("numberNew")<>res("numberOld") then%>
                <div>
                    <span class="field">מספר</span>
                    <span class="new"><%
                        Select Case res("numberNew")
                        Case 0
                            response.write "בלתי ספיר"
                        Case 1
                            response.write "יחיד"
                        Case 2
                            response.write "זוגי"
                        Case 3
                            response.write "רבים"
                        Case 4
                            response.write "לא ידוע / לא רלוונטי"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                    <span class="old"><%
                        Select Case res("numberOld")
                        Case 0
                            response.write "בלתי ספיר"
                        Case 1
                            response.write "יחיד"
                        Case 2
                            response.write "זוגי"
                        Case 3
                            response.write "רבים"
                        Case 4
                            response.write "לא ידוע / לא רלוונטי"
                        Case else
                            response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                        End Select %>
                    </span>
                </div><%
                end if

                if res("infoNew")<>res("infoOld") then%>
                <div>
                    <span class="field">הערות</span>
                    <span class="new"><%=res("infoNew")%></span>
                    <span class="old"><%=res("infoOld")%></span>
                </div><%
                end if

                if res("exampleNew")<>res("exampleOld") then%>
                <div>
                    <span class="field">דוגמאות</span>
                    <span class="new"><%=res("exampleNew")%></span>
                    <span class="old"><%=res("exampleOld")%></span>
                </div><%
                end if

                if res("imgLinkNew")<>res("imgLinkOld") then%>
                <div>
                    <span class="field">קישור לתמונה</span>
                    <span class="new"><%=res("imgLinkNew")%></span>
                    <span class="old"><%=res("imgLinkOld")%></span>
                </div><%
                end if

                if res("imgCreditNew")<>res("imgCreditOld") then%>
                <div>
                    <span class="field">קרדיט תמונה</span>
                    <span class="new"><%=res("imgCreditNew")%></span>
                    <span class="old"><%=res("imgCreditOld")%></span>
                </div><%
                end if

                if res("linkDescNew")<>res("linkDescOld") then%>
                <div>
                    <span class="field">סוג קישור</span>
                    <span class="new"><%=res("linkDescNew")%></span>
                    <span class="old"><%=res("linkDescOld")%></span>
                </div><%
                end if

                if res("linkNew")<>res("linkOld") then%>
                <div>
                    <span class="field">קישור</span>
                    <span class="new"><%=res("linkNew")%></span>
                    <span class="old"><%=res("linkOld")%></span>
                </div><%
                end if

                if res("labelsNew")<>res("labelsOld") then%>
                <div>
                    <span class="field">תגיות</span>
                    <span class="new"><%
                        if res("labelsNew")<>"" then
                            a=Split(res("labelsNew"),",")
                            for each x in a
                                response.write(labelNames(x) & "; ")
                            next
                        end if %>
                    </span>
                    <span class="old"><%
                        if res("labelsOld")<>"" then
                            a=Split(res("labelsOld"),",")
                            for each x in a
                                response.write(labelNames(x) & "; ")
                            next
                        end if %>
                    </span>
                </div><%
                end if %>
        </div><%

        Case 7
            response.write "שליחה לארכיב"
        Case 8
            response.write "החזרה מארכיב" 
        End Select %>
    </div> <%
    res.movenext
loop
res.close %>
</div>




<div id="video"><%
countMe = 0
mySQL = "SELECT credit,mlink FROM media WHERE mType=1 AND speaker = "&userId&" ORDER BY creationTime DESC"
res.open mySQL, con
if res.EOF then %>
    <div class="table">לא נמצאו הקלטות וידאו למשתמש זה</div><%
else
    Do until res.EOF %>
        <!-- DISPLAY MEDIA -->
        <div style="margin:0px auto 10px auto; text-align:center; max-width: 450px;">
                    <iframe class="youTube" src="//www.youtube.com/embed/<%=res("mLink")%>?rel=0&theme=light" allowfullscreen style="border:0;"></iframe>
        </div><%
        res.moveNext
        countMe = countMe + 1
    Loop %>
    <div class="results">מציג <%=countMe%> הקלטות אחרונות.
        <br/>לצפייה בכל המילים שהוסיף משתמש זה,<a href="profile.allwords.asp?id=<%=userID%>"> לחצו כאן</a> </div><%    
end if
res.close %>
</div>


<div id="audio" style="padding:0;"><%
countMe = 0
mySQL = "SELECT * FROM media INNER JOIN wordsMedia ON media.id=wordsMedia.mediaID WHERE mType=21 AND speaker = "&userID&" ORDER BY description"
res.open mySQL, con
if res.EOF then %>
    <div class="table">לא נמצאו הקלטות אודיו למשתמש זה</div><%
else
    Do until res.EOF %>
        <div style="FONT-SIZE: 2EM; TEXT-ALIGN: CENTER;BORDER-BOTTOM: 1px gray dotted;
        padding: 5px;">
            <a href="word.asp?id=<%=res("wordID")%>"><%=res("description")%></a>
        </div><%
        res.moveNext
        countMe = countMe + 1
    Loop %>
    <div class="results">סה"כ <%=countMe%> ערכים משויכים להקלטות</div><%    
end if
res.close %>
</div><%

'closeDB
closeDbLogger "arabicWords","C","profile.asp","main",durationMs,""


%>
<!--#include file="inc/trailer.asp"-->