<!--#include file="inc/inc.asp"-->
<!--#include file="team/inc/functions/string.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title>מילון ערבית מדוברת - לדוברי עברית</title>
    <meta charset="UTF-8">
    <meta name="Description" content="המילון לערבית מדוברת (לדוברי עברית) הוא שירות חינמי שנועד לעזור לקהילת לומדי הערבית המדוברת" />
    <meta name="Keywords" content="מילון, ערבית, מדוברת, עברית, עברי, ערבי, חופשי, חינם, חינמי, תרגום, תירגום, מילים, איך, אומרים, בערבית" />
    <!--#include file="inc/header.asp"-->
    <style>
        .thumb { text-align: center; margin:10px auto; font-size:x-small;}
        .thumb img {max-width:90%; border:1px dashed #bbb; max-height:200px;}
        .credit {max-width:90%; margin: 2px auto;}


        .activities {display:table; width:90%; margin: 0 auto; border:solid #c267df; border-width:2px 0; background:#c267df26;}
        .activityBox {display:table-row; font-size:small;}
        .activityBox > div {display:table-cell; padding:3px 5px;}
        .activityBox:nth-child(2) > div {border-top: 1px dotted #c267df70; border-bottom: 1px dotted #c267df70;}
        .activityBox div:last-child {text-align:left;}
        .activeUserImg {DISPLAY:NONE; background:white; width:30px; border-radius:30%; box-shadow:#2a3035 0px 0px 4px;}
        #boxMenu {min-width:320px; max-width:490px; margin:50px auto; text-align: center;}
        #boxMenu > div {display: inline-block; margin-top:5px; opacity:.7;}
        #boxMenu > div:hover {opacity:1;}
        #boxMenu > div > a:hover {text-decoration:none;}
        #boxMenu > div > a > div {display:flex;justify-content:center;align-items:center;width:64px;height:64px;color:black;}
        #boxMenu img {opacity: .7;}
        #boxMenu img:hover {opacity: 1;}
        #cnt2,#cnt3,#cnt4,#test5 {text-align:right; background:#fff5d7b8; padding-right:10px; border-right: 6px solid #8690ff; color:#8690ff; font-size:1em;}
        .eng {padding-left: 2px;}
        .exact {margin-bottom:10px;counter-increment: mega-step;}
        .exact::before {counter-increment: exactCount; content: counter(mega-step);display: block; padding: 5px 5px 3px 5px; background: #ffffff; width: 10%; text-align: center; border: 1px solid #a5d0f3; border-bottom: 0; margin-top:20px;}
        .harm {font-size:1.6em; line-height:.8;}
        .heb {padding-bottom: 4px; padding-right: 2px;}
        .heb a:link,.heb a:visited {color:#1988cc !important;}
        .media {margin:0px auto 10px auto; text-align:center; max-width:700px;}
        .newWord {display:inline-block; font-size: 1em; font-weight:bold; }
        .newWord a {colorx:#1988cc; }
        .newWord a:hover {text-decoration: underline;}
        .noResult {text-align:center; border:1px dotted #bbb; padding: 4px 0; max-width: 450px; margin:0 auto;}

        fieldset { width:90%; border: 1px dashed #c0c0c0; background-color:#ffffff90; margin:0 auto 6px auto; padding:0;}
        legend {border: 1px dotted #bbb; background: #fefefe; padding: 0 12px; text-align: center;}


        .notice {max-width: 440px; margin:30px auto; text-align:center;padding: 10px 0; border-radius: 20px;}
        .notice:hover {color:black; cursor:pointer; font-weight: 400; background-color:#b6eaf5; }
        .info {color:#43808e; background: #a6eaf970; border:1px solid #8ab8c3; }
        .info:hover {background-color: #a6eaf9; border-color:#124e5d;}
        .feedback {color:#ad8722;border:1px solid #f5bd00; background-color: #ffff0037;}
        .feedback:hover {background-color: #ffff0057;}



        .or { font-size:small;}
        .pos,.def {font-size:small;}
        #related {padding:4px;}
        .showString {word-break: break-all; font-size:small; text-align:center; margin-bottom:10px;}
        .search {max-width: 450px; margin: 20px auto 60px auto;}
        .search > form {background-color:#d5ebfe; padding:10px;}
        #searchString,#submit {padding:4px; font-size:large;}
        .icons {display: inline-block; position: absolute; top: 0px; left:0px;}
        .icons mark {
            font-size: 0.8em;
            left: 0px;
            min-width: 70px;
            padding: 4px;
            position: absolute;
            text-align: center;
            top: 25px;
        }
        .correct {width:15px;opacity:0.4; position: absolute; top:9px; left:5px;}
        .imgLink {width:25px;opacity:0.5; float: none; position: absolute; top:4px; left: 42px;}
        .audio {max-width:16px ; opacity: 0.5; float: none; position: absolute; top:9px; left: 26px;}
        .erroneous {width:15px;opacity:0.7; position: absolute; top:9px; left:5px;}

        body {counter-reset: exactCount;}
        h1 {display:none;}
        h2 {
            text-align:center;
            font-size:small;
            font-weight:400;
            margin:20px auto 10px;
            background-color:#d5ebfe;
            line-height:2;
            }
        h2 span, h2 div {display: inline-block;}
        hr {border: 0; height: 1px; 
          background-image: -webkit-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
          background-image: -moz-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
          background-image: -ms-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
          background-image: -o-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0); 
        }


        @media (max-width:610px) {
            hr {margin:10px auto; }
            .eng,.heb {float:none;}
            .box {max-width:500px; margin:0 2%;}
        }        

        @media (min-width:610px) {
            .box {max-width:500px; margin:0 auto;}
            .exact .result {
                font-size: 2em;
                }
            .exact mark {
                min-width:130px;
                }
            hr {margin:30px auto; }
        }        

    </style>
    <script>
        $(document).ready(function(){

            // HIDDEN ON PAGE LOAD
            $("#msgRsltsExct").hide();
            $("#msgRsltsZeroExct").hide();
            $("#msgRsltsNone").hide();
            $("#tagsCloud").hide();

            // SHOWING NUMBERS NEXT TO SEARCH RESULTS
            var cnt1 = $("#count1").data("count");
            if (cnt1 >= 1) $("#msgRsltsExct").show();
            if (cnt1 == 0) $("#msgRsltsZeroExct").show();
            if (cnt1 > 1) $("#cnt1").prepend(cnt1+" תוצאות מדויקות");
            if (cnt1 == 1) $("#cnt1").prepend("תוצאה מדויקת אחת")
            
            var cnt2 = $("#count2").data("count");
            if (cnt2 > 1) $("#cnt2").prepend(cnt2+" ");
            if (cnt2 == 0) $("#cnt2").hide();
            var cnt3 = $("#count3").data("count");
            if (cnt3 > 1) $("#cnt3").prepend(cnt3+" ");
            if (cnt3 == 0) $("#cnt3").hide();
            var cnt4 = $("#count4").data("count");
            if (cnt4 > 1) $("#cnt4").prepend(cnt4+" ");
            if (cnt4 == 0) $("#cnt4").hide();
            
            var cntRest = cnt2 + cnt3 + cnt4;
            if (cntRest > 1) $("#cntRest").prepend(" | "+cntRest+" תוצאות נוספות");
            if (cntRest == 0) $("#cntRest").prepend(" | ללא תוצאות נוספות");
            if (cntRest == 1) $("#cntRest").prepend(" | תוצאה נוספת אחת");
            var cntMore = cntRest
            if (cntRest > 0) $("#cntMore").prepend(cntRest);
            
            var cntAll = cnt1 + cntRest;
            if (cntAll == 0) $("#msgRsltsZeroExct").hide();
            if (cntAll == 0) $("#msgRsltsNone").show();
            

            // HIDES / UNHIDES LABELS LIST
            $("#tagsTile").click(function(){
                $("#tagsCloud").slideToggle();
                return false;
            });


        });


        //RANDOM MESSAGE BOARD
        function getRndInt(min, max) {
            var x = "000"+(Math.floor(Math.random() * (max - min + 1) ) + min).toString();
            return x.substring(x.length-3,x.length);
        }
        //make sure number of messages is updated in call function(first msg, last msg)
        //currently calling messages 1 to 3
        $(function(){
        $("#msgBoard").load("msg"+getRndInt(1,3)+".html?version=7"); 
        });


      //NOT IN USE
      //USING VBSCRIPT FUNCTION AT SOUNDEX.ASP
      function justLtrs() 
      {
        var ltrs = document.getElementById("searchString").value ;
        ltrs = ltrs.replace(/[^א-תؠ-يٱ-ٳٶ-ە'`׳‘’]/g,"");
        ltrs = ltrs.replace(/[`׳‘’]/g,"'");
        document.getElementById("ltrs").value = ltrs;
      }

    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->
<!--#include file="team/inc/functions/soundex.asp"--><%

dim countMe,resultPos,id,ids,idx,skip,wordMain,title,psikArr,psikWord,found

countMe = 0
resultPos = 0
ids = ""
skip = false
wordMain=0 %>

<div class="box">
    <h1>חיפוש</h1>
    <div class="search"><%
        if len(strInput)=0 then%>
            <div style="text-align:center; border:0; line-height:1.5; padding:4px;">
                חפשו <span class="heb" style="font-size:larger;">מילה</span>, <span class="arb keter">כִּלְמֵה</span> <span class="or">או</span> <span class="arb harm">كلمة</span>
            </div><%
        end if %>
        <form action=default.noAds.asp method="get">
            <input name="searchString" id="searchString" value="<%=server.HTMLEncode(strDisplay)%>" style="border-radius:5px;width:70%;" />
            <button id="submit" type="submit" style="float:left; width:25%;">יאללה</button>
        </form>
    </div>
    
    <div id="msgRsltsExct" style="text-align: center; padding: 5px; background:#fff5d7b8; border-bottom: 2px solid #8286ff; margin: 0 auto; color: #8286ff;">
        <span style="font-weight:bold;" id="cnt1"></span>
        <span style="font-size:small;" id="cntRest"></span>
    </div>

    <div id="msgRsltsZeroExct" style="text-align: center; padding: 5px; background: #fff5d7b8; border-bottom: 2px solid #ffaa82; margin: 0 auto; color: #ffaa82;">
        <p style="font-weight:bold;">
            אויש!
            <br/>לא מצאנו ב-ד-י-ו-ק את מה שכתבתם
            <br/>אבל כן מצאנו <span style="font-size:small;" id="cntMore"></span> תוצאות אחרות:
        </p>
    </div>

    <div id="msgRsltsNone" style="text-align: center; padding: 5px; background: #ffd7d73d; border-bottom: 2px solid #ff8282; margin: 0 auto; color: #ff8282;">
        <p style="font-weight:bold;">
            אופס!
            <br/>לא מצאנו את מה שחיפשתם
        </p>
        <ul style="text-align:right; width:max-content; margin:0 auto; padding-left:15%;"><u>טיפים</u>:
            <li>חפשו פעלים בגוף שלישי עבר</li>
            <li>חפשו שמות עצם בצורת יחיד</li>
            <li>חפשו מילה אחת כל פעם</li>
        </ul>
        <br/>
    </div>
        
    <%

    if len(strDisplay)>0 then
        openDB "arabicWords"
        mySQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE "&_
                "((hebrewClean LIKE '%"& strClean &"%') OR (hebrewCleanMore LIKE '%"& strClean &"%') OR "&_
                "(arabicClean LIKE '%"& strClean &"%') OR (arabicCleanMore LIKE '%"& strClean &"%') OR"&_
                "(arabicHebClean LIKE '%"& strClean &"%') OR (arabicHebCleanMore LIKE '%"& strClean &"%')) AND show"
        res.open mySQL, con
        if not res.EOF then
            Do until res.EOF
                found=false
                skip = false
                idx=Split(ids,",")
                for each id in idx
                    if id=cstr(res("id")) then skip=true
                next 

                if strClean = res("hebrewClean") or (strClean = res("arabicClean")) or (strClean) = res("arabicHebClean") then
                    found = true
                    if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    countMe = countMe+1
                else
                    psikArr = split(res("hebrewClean"),",")
                    for each psikWord in psikArr
                        if onlyLetters(strDisplay) = psikWord then
                            found = true
                            if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                            countMe = countMe+1
                        end if        
                    next
                end if 

                'CHECK FOR MORE EXACT RESULTS 1/3
                if len(res("hebrewCleanMore"))>0 then
                    psikArr = split(res("hebrewCleanMore"),",")
                    for each psikWord in psikArr
                        if onlyLetters(strDisplay) = psikWord then
                            found = true
                            if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                            countMe = countMe+1
                        end if        
                    next
                end if

                'CHECK FOR MORE EXACT RESULTS 2/3
                if len(res("arabicCleanMore"))>0 then
                    psikArr = split(res("arabicCleanMore"),",")
                    for each psikWord in psikArr
                        if onlyLetters(strDisplay) = psikWord then
                            found = true
                            if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                            countMe = countMe+1
                        end if        
                    next
                end if

                'CHECK FOR MORE EXACT RESULTS 3/3
                if len(res("arabicHebCleanMore"))>0 then
                    psikArr = split(res("arabicHebCleanMore"),",")
                    for each psikWord in psikArr
                        if onlyLetters(strDisplay) = psikWord then
                            found = true
                            if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                            countMe = countMe+1
                        end if        
                    next
                end if


                if (found=true) and (skip=false) then %>

            <div class="exact">
                <div class="result" onclick="location.href='word.asp?id=<%=res("id")%>';">
                    <div class="heb" style="position: relative;">
                        <a href="word.asp?id=<%=res("id")%>"><%=res("hebrewTranslation")%></a>
                        <%
                        if len(res("hebrewDef"))>0 then %>
                            <span class="def">(<%=trim(res("hebrewDef"))%>)</span><%
                        end if %>
                        <span class="icons"><%
                        if res("mediaID") then %>
                            <img src="img/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="audio"/><%
                        end if
                        Select Case res("status")
                        Case 1 %>
                            <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" class="correct" /><%
                        Case -1 %>
                            <mark>ערך בבדיקה</mark><%
                        Case Else %>
                            <mark>טרם נבדק</mark><%
                        End Select %>
                        </span>                    
                    </div>
                    <div class="arb harm"><%=res("arabic")%></div>
                    <div class="arb keter"><%=shadaAlt(res("arabicWord"))%></div>
                    <div class="eng"><%=res("pronunciation")%></div>
                    <div class="attr">
                        <div class="pos"><%
                            SELECT CASE res("partOfSpeach")
                                case 0 response.write "-"
                                case 1 response.write "שם עצם"
                                case 2 response.write "שם תואר"
                                case 3 response.write "פועל"
                                    if res("binyan")=>1 then %><span style="font-size:small;"> (בניין <%=res("binyan")%>)</span><%end if
                                case 4 response.write "תואר הפועל"
                                case 5 response.write "מילית יחס"
                                case 6 response.write "מילית חיבור"
                                case 7 response.write "מילת קריאה"
                                case 8 response.write "תחילית"
                                case 9 response.write "סופית"
                            END SELECT %>
                        </div>     
                        <div class="gender"><%
                            SELECT CASE res("gender")
                                case 0 response.write "נטרלי"
                                case 1 response.write "זכר"
                                case 2 response.write "נקבה"
                                case 3 response.write "-"
                            END SELECT %>
                        </div>     
                        <div class="number"><%
                            SELECT CASE res("number")
                                case 0 response.write "בלתי ספיר"
                                case 1 response.write "יחיד"
                                case 2 response.write "זוגי"
                                case 3 response.write "רבים"
                                case 4 response.write "-"
                            END SELECT %>
                        </div>     
                    </div>
                </div>
            </div><%


            'SHOW MEDIA'
            if res("mediaID") then
                mySQL = "SELECT * FROM wordsMedia INNER JOIN media ON wordsMedia.mediaID=media.ID WHERE wordsMedia.wordID="&res("id")
                    res2.open mySQL, con
                do until res2.EOF %>
                    <div class="media" style=""><%
                        SELECT Case res2("mType")
                        case 1 'youtube' %>
                            <iframe class="youTube" src="//www.youtube.com/embed/<%=res2("mLink")%>?rel=0&theme=light" allowfullscreen style="border:0;"></iframe><%
                        case 21 'clyp.it' %>
                            <iframe class="clyp" width="100%" height="160" src="https://clyp.it/<%=res2("mLink")%>/widget" frameborder="0"></iframe><%
                        case 22 'soundcloud' %>
                            <iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/<%=res2("mLink")%>&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe><%
                        case else
                        END SELECT %>
                        <div style="font-size:small;">תודה ל: <%
                            if len(res2("creditLink"))>0 then %>
                                <a href="<%=res2("creditLink")%>" target="_new"><%
                                if res2("credit") = "ערביט" then %>
                                    <img src="img/site/links.arabit.png" alt="ערביט" title="לחצו לדף המילה בפרויקט ערביט"/><%
                                else %>
                                    <%=res2("credit")%><%
                                end if %>
                                </a><%
                            else %>
                                <%=res2("credit")%><%
                            end if %>
                        </div>
                    </div><%
                    res2.movenext
                loop
                res2.close
            end if


            'SINGLE - PLURAL'
            if res("partOfSpeach")=1 then 
                mySQL = "SELECT * FROM wordsRelations WHERE (word1="&res("id")&" OR word2="&res("id")&") AND relationType=3"
                res2.open mySQL, con
                if not res2.EOF then 
                    if res2("word1") = res("id") then
                        wordMain = res2("word2")
                        title = "רבים"
                    else 
                        wordMain = res2("word1")
                        title = "יחיד"
                    end if
                end if
                res2.close
                if wordMain>0 then
                    mySQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE id="&wordMain
                    res2.open mySQL, con %>
                    <fieldset onclick="location.href='word.asp?id=<%=wordMain%>';">
                        <legend><%=title%></legend>
                        <div id="related">
                            <div class="heb" style="position: relative;"><a href="word.asp?id=<%=res2("id")%>"><%=res2("hebrewTranslation")%></a><%
                            if len(res2("hebrewDef"))>0 then %>
                                <span class="def">(<%=res2("hebrewDef")%>)</span><%
                            end if %>
                            <span class="icons"><%
                            if len(res2("imgLink"))>0 then %>
                                <img src="img/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="imgLink" /><%
                            end if
                            if res2("mediaID") then %>
                                <img src="img/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="audio"/><%
                            end if
                            Select Case res2("status")
                            Case 1 %>
                                <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" class="correct" /><%
                            Case -1 %>
                                <mark>ערך בבדיקה</mark><%
                            Case Else %>
                                <mark>טרם נבדק</mark><%
                            End Select %>
                            </span>                                              
                            </div>
                            <div class="arb harm"><%=res2("arabic")%></div>
                            <div class="arb keter" style="font-size:1.6em;"><%=shadaAlt(res2("arabicWord"))%></div>
                            <div class="eng"><%=res2("pronunciation")%></div>
                        </div>
                    </fieldset><%
                    if ids = "" then ids = wordMain else ids = ids & "," & wordMain
                    res2.close
                    wordMain=0
                end if
            end if 


            'SHOW IMAGE'
            if len(res("imgLink"))>0 then %>
                <div class="thumb">
                    <img src="<%=res("imgLink")%>"/>
                    <div class="credit"><%=res("imgCredit")%></div>
                </div><%
            end if

        end if
        res.moveNext
    loop
end if
res.close%>
    
<span id="count1" data-count="<%=countMe%>" style="display:hidden;"></span><%
if countMe>0 then resultPos=1
countMe=0 

    dim sndx,searchNumber,searchTitle,divClass,searchSQL,countID
    searchNumber=2
    sndx = soundex(strClean) 


    do until searchNumber=5

        SELECT CASE searchNumber
        case 2
            searchTitle = "<h2 id='cnt2'>מילים שנשמעות כמו מה שחיפשתם<span style='font-size:.7em; float:left; padding-left:4px;'>"&sndx&"</span></h2>"
            divClass = "soundexed"
            searchSQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((sndxArabicV1 = '"& sndx &"') OR (sndxHebrewV1 = '"& sndx &"')) AND show"
            countID = "count2"
        case 3
            searchTitle = "<h2 id='cnt3'>מילים עם רצף האותיות שחיפשתם</h2>"
            divClass = "like"
            searchSQL = "SELECT TOP 50 words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((hebrewClean LIKE '%"& strDisplay &"%') OR (arabicClean LIKE '%"& strDisplay &"%') OR (arabicHebClean LIKE '%"& strDisplay &"%')) AND show"
            countID = "count3"
        case 4
            searchTitle = "<h2 id='cnt4'>תוצאות נוספות : שגיאות נפוצות, מילים נרדפות ועוד</h2>"
            divClass = "searchWords"
            searchSQL = "SELECT TOP 50 words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE searchString LIKE '%"& strDisplay &"%' AND show"
            countID = "count4"
        END SELECT
        searchNumber = searchNumber+1

    %>

        <%=searchTitle%>
        <div class="<%=divClass%>"><%
            mySQL = searchSQL
            res.open mySQL, con
            if not res.EOF then
                Do until res.EOF
                    idx=Split(ids,",")
                    for each id in idx
                        if id=cstr(res("id")) then skip=true
                    next 
                    if skip = false then %>
                        <div class="result" onclick="location.href='word.asp?id=<%=res("id")%>';">
                            <div class="heb" style="position:relative;"><a href="word.asp?id=<%=res("id")%>"><%=res("hebrewTranslation")%></a><%
                            if len(res("hebrewDef"))>0 then %>
                                <span class="def">(<%=res("hebrewDef")%>)</span><%
                            end if %>
                                <span class="icons"><%
                            if len(res("imgLink"))>0 then %>
                                <img src="img/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="imgLink" /><%
                            end if
                            if res("mediaID") then %>
                                <img src="img/site/audio.png" alt="לערך זה יש סרטון או אודיו" title="לערך זה יש סרטון או אודיו" class="audio"/><%
                            end if
                            Select Case res("status")
                            Case 1 %>
                                <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" class="correct" /><%
                            Case -1 %>
                                <mark>ערך בבדיקה</mark><%
                            Case Else %>
                                <mark>טרם נבדק</mark><%
                            End Select %>
                            </div>
                            <div class="arb harm"><%=res("arabic")%></div>
                            <div class="arb keter" style="font-size:1.6em;"><%=shadaAlt(res("arabicWord"))%></div>
                            <div class="eng"><%=res("pronunciation")%></div>
                        </div><%
                    countMe = countMe+1
                    end if
                    if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    skip = false
                    res.moveNext
                Loop
            end if
            res.close %>
        </div>
        <span id="<%=countID%>" data-count="<%=countMe%>" style="display:none;"></span><%
        if (countMe>0) and (resultPos=0) then resultPos=2 'no exact results
        if (countMe=0) and (resultPos=0) then resultPos=9 'no results
        countMe=0 'reset

    loop



    end if %>





<!-- RESULTS FROM SENTENCES --><%
if len(strDisplay)>0 then 
    mySQL = "SELECT sentences.* FROM sentences WHERE ((hebrewClean LIKE '%"& strClean &"%') OR (arabicClean LIKE '%"& strClean &"%') OR (arabicHebClean LIKE '%"& strClean &"%')) AND show"
    res.open mySQL, con
    if res.EOF then 
        if resultPos=1 then resultPos = 11
        if resultPos=2 then resultPos = 21
        if resultPos=9 then resultPos = 91
    else %>
    <h2 id="test5">ניסוי - תוצאות חיפוש ממשפטים</h2><%
        Do until res.EOF %>
            <div class="result" onclick="location.href='sentence.asp?sID=<%=res("id")%>'">
                <div class="heb"><%=res("hebrew")%></div>
                <div class="arb harm"><%=res("arabic")%></div>
                <div class="arb keter"><%=shadaAlt(res("arabicHeb"))%></div>
            </div><%
            res.moveNext
        loop
    end if
end if %>







<!-- IF NOT WELCOME PAGE --><%
if len(strDisplay)>0 then %>
    <div class="notice info" onclick="location.href='guide.asp'">
        הסבר על התעתיק
    </div>

    <div class="notice feedback" onclick="location.href='https://docs.google.com/forms/d/e/1FAIpQLSdRbT5gLX_dde1lxAAVKDzLmnEQMeggHSyHLjjg2hj7P7ulcg/viewform?usp=sf_link'">
        משוב על החיפוש החדש
    </div>

<hr/><%
end if 
closeDB %>



<!-- TILE MENU-->
<div id="boxMenu">
    <div id="communityTile">
    <a href="activity.asp"><div data-gtm="tile_community" style="background-color:#c267df;">פעילות קהילה</div></a>
    </div>
    <div id="tagsTile">
        <a href="#"><div data-gtm="tile_labels" style="background-color:#dfb467;">רשימות נושאים</div></a>
    </div>
    <div>
        <a href="lists.all.asp"><div data-gtm="tile_lists" style="background-color:#dedf67;">הרשימות שלכם</div></a>
    </div>
    <div>
        <a href="guide.asp"><div data-gtm="tile_guide" style="background-color:#75df67;">מדריך שימוש</div></a>
    </div>
    <div>
        <a href="where2learn.asp"><div data-gtm="tile_learn" style="background-color:#67bfdf;">איפה ללמוד</div></a>
    </div>
    <div>
        <a href="games.mem.asp"><div data-gtm="tile_games" style="background-color:#67a5df;">משחק זיכרון</div></a>
    </div>
    <div>
        <a href="links.asp"><div data-gtm="tile_links" style="background-color:#677edf;">קישורים שונים</div></a>
    </div>
</div>




<!-- TAG CLOUD-->
<div id="tagsCloud">
    <ul><%
    dim x,tagSize
    openDB "arabicWords"
    mySQL = "SELECT * FROM labels ORDER BY labelName"
    res.open mySQL, con
        Do until res.EOF
            mySQL = "SELECT count(wordID) FROM wordsLabels WHERE labelID="&res("ID")
            res2.open mySQL, con
                x = res2(0)
                SELECT Case true
                    case x>=0 AND x<=10
                    tagSize = "1em"
                    case x>=11 AND x<=30
                    tagSize = "1.2em"
                    case x>=31 AND x<=70
                    tagSize = "1.4em"
                    case x>=71 AND x<=120
                    tagSize = "1.6em"
                    case x>=121 AND x<=180
                    tagSize = "1.8em"
                    case x>=180 AND x<=300
                    tagSize = "2em"
                    case else
                    tagSize = "2.2em"
                END SELECT
            res2.close %>
            <li style="font-size:<%=tagSize%>;" title="ישנן <%=x%> מילים בנושא זה" style="font-size:<%=tagSize%>">
                <a href="label.asp?id=<%=res("id")%>"><%=res("labelName")%></a>
            </li><%
            res.moveNext
        Loop
    res.close%>
    </ul>
</div>



<!-- IF WELCOME PAGE --><%
If len(strDisplay)=0 then
dim creatorID 
openDB "arabicWords"
%>
<!-- NEW ACTIVITY ON SITE -->
<div style="font-size:small; margin:20px 10px 5px 0px;">הצצה לפעילות הקהילה:</div>
<div class="activities">
    <!-- NEWLY ADDED WORD-->
    <div class="activityBox"><%
        mySQL = "SELECT TOP 1 * FROM (SELECT * FROM words LEFT JOIN (SELECT ID,username,picture,gender FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON words.[creatorID]=T.ID WHERE show ORDER BY words.ID DESC)"
        res.open mySQL, con 
            creatorID = res("creatorID") %>
                <div style="width:85px;">מילה חדשה:</div>
                <div class="newWord"><a href="word.asp?id=<%=res("words.id")%>"><%=res("hebrewTranslation")%></a></div>
                <div><a href="profile.asp?id=<%=creatorID%>"><%=res("username")%></a></div>
                <%
        res.close %>
    </div>

    <!-- Last EDIT of a WORD-->
    <div class="activityBox"><%
        mySQL = "SELECT TOP 1 * FROM (SELECT * FROM history LEFT JOIN (SELECT ID,username,picture,gender FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON history.[user]=T.ID WHERE showNew ORDER BY actionUTC DESC)"
        res.open mySQL, con 
        creatorID = res("user") %>
            <div>עריכת מילה:</div>
            <div class="newWord"><a href="word.asp?id=<%=res("word")%>"><%=res("hebrewNew")%></a></div>
            <div><a href="profile.asp?id=<%=creatorID%>"><%=res("username")%></a></div>
            <%
        res.close%>
    </div>

    <!-- Last EDIT on a LIST-->
    <div class="activityBox"><%
        mySQL = "SELECT TOP 1 * FROM (SELECT * FROM lists LEFT JOIN (SELECT ID,username,picture,gender FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON lists.creator=T.ID ORDER BY lastUpdateUTC DESC)"
        res.open mySQL, con 
        creatorID = res("creator") %>
        <div>עריכת רשימה:</div> 
        <div class="newWord"><a href="lists.asp?id=<%=res("lists.id")%>"><%=res("listName")%></a></div>
        <div><a href="profile.asp?id=<%=creatorID%>"><%=res("username")%></a></div>
        <%
        res.close %>
    </div>

    <div style="font-size:small; text-align:left;DISPLAY:none;">
        <a href="activities.asp">הצג עוד</a>
    </div>
</div><%
else %>

<!-- AD BY GOOGLE -->
<div style="min-width:320px; max-width:490px; margin:50px auto;">
    <div style="font-size:small; margin-right:10px;">פרסומת לכיסוי הוצאות האתר:</div>
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
    <!-- 'Search Results' Ad -->
    <ins class="adsbygoogle"
         style="display:block"
         data-ad-client="ca-pub-3338230826889333"
         data-ad-slot="9595580203"
         data-ad-format="auto"></ins>
    <script>
    (adsbygoogle = window.adsbygoogle || []).push({});
    </script>
</div><%

end if %>




<!-- RANDOMISED MESSAGE -->
<div style="font-size:small; margin:20px 10px 5px 0px;">הודעה מתחלפת:</div>
<div id="msgBoard"></div>



</div><%
if session("role")>=7 then %><!--#include file="inc/welcome.editors.asp"--><%end if
if session("role")>=15 then %><!--#include file="inc/welcome.admins.asp"--><%end if%>

<!--#include file="inc/trailer.asp"-->

<div style="bottom-margin:200px;" dir="ltr"><%
response.Flush


'INSERT TO SEARCH HISTORY'
if len(strDisplay)>0 then
    openDB "arabicSearch"
    dim searchID

    'COUNTER & RESULT STATUS
    mySQL = "SELECT id,searchCount FROM wordsSearched WHERE typed='"&strDisplay&"'"
    res.open mySQL, con
    if res.EOF then 'if new string
        mySQL = "INSERT into wordsSearched(typed,result) VALUES('"& strDisplay &"',"& resultPos &")"
        searchID = 0
    else
        mySQL = "UPDATE wordsSearched SET searchCount="& (res("searchCount")+1) &",result="& resultPos &" WHERE typed='"& strDisplay &"'"
        searchID = res("id")
    end if
    res.close
    con.execute mySQL

    'TIMESTAMP
    if searchID = 0 then 'if new string
        mySQL = "SELECT max(ID) FROM wordsSearched" 'get maxID
        res.open mySQL, con
            searchID = res(0)
        res.close
    end if
    mySQL = "INSERT into latestSearched(searchTime,searchID) VALUES('"& AR2UTC(now()) &"',"& searchID &")"
    con.execute mySQL
    

    closeDB
end if %>
</div>