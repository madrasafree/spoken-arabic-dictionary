<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"--><%
'FILES TO EDIT WHEN ADDING/REMOVING LABEL FROM DB:
'edit.update.asp - lblCnt'
'word.asp - labelNames'
dim countMe, order
dim LID, LName, psik, current
order = "arabicWord"
Select case Left(Request("order")&"a",1)
    Case "e": order = "pronunciation"
    Case "h": order = "hebrewTranslation"
End select
countMe = 0
LID = Request("id")
LName = "empty"
psik = ""


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","label.asp","single",""

mySQL = "SELECT labelName FROM labels WHERE id="+LID
res.open mySQL, con
    LName = res("labelName")
res.close 


%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title><%=LName%></title>
	<meta name="Description" content="קבוצות מילים לפי נושאים" />
    <meta property="og:image"           content="https://rothfarb.info/ronen/arabic/img/labels/<%=LID%>.png" />
    <!--#include file="inc/header.asp"-->
    <style>
        #lingolearn button:hover {
            background:yellow;
        }

        #hide,#unhide {margin-left:10px;text-align:left; cursor:pointer;}
        #hide:hover,#unhide:hover {font-weight:bold;}


        .eng {padding-left: 2px;}
        .harm {font-size:1.6em; line-height:.8;}
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
    <script>
        $(document).ready(function(){
            // COUNTS HOW MANY WORDS IN LABEL
            var cnt = $("#countMe").data("count");
            if (cnt > 1) $("#wordsSum").html(cnt + " מילים");

            // HIDES / UNHIDES LABELS LIST
            $("#tagsCloud").hide();
            $("#hide").hide();
            $("#unhide").click(function(){
                $("#tagsCloud").slideToggle();
                $("#unhide").slideToggle();
                $("#hide").slideToggle();
            });
            $("#hide").click(function(){
                $("#tagsCloud").slideToggle();
                $("#unhide").slideToggle();
                $("#hide").slideToggle();
            });
        });
    </script>
</head>
<body>

<!--#include file="inc/top.asp"-->
<div id="pTitle">קבוצות מילים לפי נושאים</div>

<div id="tagsCloud">
    <ul><%
    dim x,tagSize
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
            res2.close
            If cint(LID) = res("id") then
                LName = res("labelName")%>
                <li id="current" style="font-size:<%=tagSize%>;"><%
            else %>
                <li style="font-size:<%=tagSize%>;"><%
            End if%>
                <a href="label.asp?id=<%=res("id")%>"><%=res("labelName")%></a></li><%
		    res.moveNext
	    Loop
	res.close%>
    </ul>
</div>

<div id="tagTitle">
    <div id="hide">הסתר רשימת נושאים</div>
    <div id="unhide">הצג רשימת נושאים</div>
    <h3><%=LName%></h3>
    <span id="wordsSum"></span>
</div>


	<%
    dim prevID
    prevID = 0
    mySQL = "SELECT DISTINCT words.id, words.arabic, words.arabicWord, words.hebrewTranslation, words.hebrewDef, words.pronunciation, words.status, words.imgLink, wordsLabels.labelID, wordsMedia.mediaID FROM (words INNER JOIN wordsLabels ON words.id = wordsLabels.wordID) LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show AND (((wordsLabels.labelID)=" & LID & ")) ORDER BY "& order
	res.open mySQL, con

	    Do until res.EOF 
            if res("id")<>prevID then %>
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
                    <div class="arb harm"><%=res("arabic")%></div>
                    <div class="arb keter" style="font-size:1.6em"><%=shadaAlt(res("arabicWord"))%></div>
                    <div class="eng"><%=res("pronunciation")%></div>
                </div><%
                countMe = countMe + 1
            end if
            prevID = res("id")
		    res.moveNext
	    Loop
	    res.close %>
<span id="countMe" data-count="<%=countMe%>"></span>
<script type="text/javascript"><!--
    //document.title = document.title + " : <%=LName%>";
//--></script>

<%


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","label.asp","single",durationMs,LName

%>


<!--#include file="inc/trailer.asp"-->