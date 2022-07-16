<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"--><%
dim countMe, nikud
dim psik,current

countMe = 0
nikud = ""
psik = ""
 %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title>TEST - VERBS</title>
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
    <style>
        .autoMenu li {
            background: white;
            border: 1px solid gray;
            border-radius: 10px;
            display: inline-block;
            line-height: 2em;
            margin: 2px 0;
            padding: 0px 4px;
            }
        .star { color:white; float:left; margin-left:7px; text-shadow:0 0 3px black; font-size:1.8em; cursor:pointer;}
        .starOn { color:#f5f029;}

        .eng {padding-left: 2px;}
        .heb {padding-bottom: 4px; padding-right: 2px;}
        .heb a:link,.heb a:visited {color:#1988cc !important;}

        .listDiv > span {display:block; line-height: 15px;}
        .pos,.def {display:inline-block !important; font-size:small ;}

        .result {background-color:#ffffff60;padding:4px;border: 1px dotted #a5d0f3; margin-bottom: 3px; box-shadow:0px 6px 17px rgba(144, 190, 234, 0.21);}
        .result:hover, fieldset:hover {background-color: #fff; border:1px solid #a5d0f3; cursor:pointer;}
        .icons {display: inline-block; position: absolute; top: 0px; left:0px;}
        .correct {width:15px;opacity:0.4; position: absolute; top:9px; left:5px;}
        .imgLink {width:25px;opacity:0.5; float: none; position: absolute; top:4px; left: 42px;}
        .audio {max-width:16px ; opacity: 0.5; float: none; position: absolute; top:9px; left: 26px;}
        .erroneous {width:15px;opacity:0.7; position: absolute; top:9px; left:5px;}

        @media (max-width: 600px) {
            .eng,.heb {float:none;}
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>
        $(document).ready(function(){
            var cnt = $("#countMe").data("count");
            if (cnt > 1) $("#wordsSum").html(cnt + " מילים");
        });
    </script>
</head>
<body><%
dim al,userChoice,sqlWhere,sqlTitle
al = request("al")
userChoice = true
sqlTitle = "רשימות אוטומטיות"
select case al
    case 1
        sqlWhere = "partOfSpeach=3 AND binyan=1"
        sqlTitle = "פעלים בניין 1"
    case 2
        sqlWhere = "partOfSpeach=3 AND binyan=2"
        sqlTitle = "פעלים בניין 2"
    case 3
        sqlWhere = "partOfSpeach=3 AND binyan=3"
        sqlTitle = "פעלים בניין 3"
    case 4
        sqlWhere = "partOfSpeach=3 AND binyan=4"
        sqlTitle = "פעלים בניין 4"
    case 5
        sqlWhere = "partOfSpeach=3 AND binyan=5"
        sqlTitle = "פעלים בניין 5"
    case 6
        sqlWhere = "partOfSpeach=3 AND binyan=6"
        sqlTitle = "פעלים בניין 6"
    case 7
        sqlWhere = "partOfSpeach=3 AND binyan=7"
        sqlTitle = "פעלים בניין 7"
    case 8
        sqlWhere = "partOfSpeach=3 AND binyan=8"
        sqlTitle = "פעלים בניין 8"
    case 9
        sqlWhere = "partOfSpeach=3 AND binyan=9"
        sqlTitle = "פעלים בניין 9"
    case 10
        sqlWhere = "partOfSpeach=3 AND binyan=10"
        sqlTitle = "פעלים בניין 10"
    case else
        userChoice = false
end select


%>

<!--#include file="inc/top.asp"-->

<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ארגז חול</a> / 
	<h1>רשימות אוטומטיות</h1>
</div>




<ul class="autoMenu">פעלים:
    <li><a href="TEST.list.auto.asp?al=1">בניין 1</a></li>
    <li><a href="TEST.list.auto.asp?al=2">בניין 2</a></li>
    <li><a href="TEST.list.auto.asp?al=3">בניין 3</a></li>
    <li><a href="TEST.list.auto.asp?al=4">בניין 4</a></li>
    <li><a href="TEST.list.auto.asp?al=5">בניין 5</a></li>
    <li><a href="TEST.list.auto.asp?al=6">בניין 6</a></li>
    <li><a href="TEST.list.auto.asp?al=7">בניין 7</a></li>
    <li><a href="TEST.list.auto.asp?al=8">בניין 8</a></li>
    <li><a href="TEST.list.auto.asp?al=9">בניין 9</a></li>
    <li><a href="TEST.list.auto.asp?al=10">בניין 10</a></li>
</ul>
<div id="pTitle">
    <%=sqlTitle%>
    <div id="wordsSum" style="font-size:small;"></div>
</div><%



if userChoice=true then

    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","TEST.list.auto.asp","single",""

    mySQL = "SELECT DISTINCT words.id, words.show, words.arabic, words.arabicWord, words.hebrewTranslation, words.hebrewDef, words.pronunciation, words.status, words.imgLink, words.partOfSpeach, words.gender, words.number, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show AND "&sqlWhere
    res.open mySQL, con 
    if res.EOF then %>
        <div class="table" style="text-align:center;">לא נמצאו פעלים בבניין זה</div><%
    else

        dim partsOfSpeach,pos,genders,gen,numbers,nums
        partsOfSpeach = "לא ידוע / אחר|שם עצם|שם תואר|פועל|תואר הפועל|מילית יחס|מילית חיבור|מילת קריאה|תחילית|סופית"
        genders = "מגדר נטרלי|זכר|נקבה|לא ידוע / לא רלוונטי"
        numbers = "בלתי ספיר|יחיד|זוגי|רבים|לא ידוע / לא רלוונטי" %>

        <div class="table"><%
            dim lastID
            lastID = 0
            Do until res.EOF
                if lastID <> res("id") then 
                    if res("show")=false then %>
                        <div class="listDiv">הערך הבא מוסתר מהגולשים:</div><%
                    else
                        countMe = countMe + 1
                    end if %>
                    <div class="result" onclick="location.href='word.asp?id=<%=res("id")%>';">
                        <div class="heb" style="position:relative;"><a href="word.asp?id=<%=res("id")%>"><%=res("hebrewTranslation")%></a><%
                        if len(res("hebrewDef"))>0 then %>
                            <span class="def">(<%=trim(res("hebrewDef"))%>)<%
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
                            <span style="background: #ff2f00; color: #ffffff; font-weight: bold; padding: 4px 10px; border-radius: 3px;">ערך בבדיקה</span><%
                        Case Else %>
                            <span style="background: #ff8d00; color: #ffffff; font-weight: bold; padding: 4px 10px; border-radius: 3px;">טרם נבדק</span><%
                        End Select %>
                        </div>
                        <div class="arb"><%=res("arabic")%></div>
                        <div class="arb"><%=res("arabicWord")%></div>
                        <div class="eng"><%=res("pronunciation")%></div>
                    </div><%
                    lastID = res("id")
                end if
                res.moveNext
            Loop %>
            </div><%
    end if
    res.close

    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicWords","C","TEST.list.auto.asp","single",durationMs,""


end if %>
<span id="countMe" data-count="<%=countMe%>"></span>


<!--#include file="inc/trailer.asp"-->