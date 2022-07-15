<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/time.asp"--><%
dim countMe, nikud, order
dim LID,LName,lDesc,lPrivacy,psik,current,creatorID,creatorName,creationTimeUTC,lastUpdateUTC,sqlShow

order = "pos"
Select case Left(Request("order")&"p",1)
    Case "a": order = "arabicWord"
    Case "e": order = "pronunciation"
    Case "h": order = "hebrewTranslation"
End select
countMe = 0
nikud = ""
LID = request("id")
if LID = "" then LID = 0
LName = "empty"
psik = ""

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","lists.asp","list details",""

mySQL = "SELECT * FROM lists Where ID="&LID
res.open mySQL, con
    if res.EOF then
        session("msg") = "לא נמצאה רשימה עם המספר הסידורי המבוקש"
        response.redirect "lists.all.asp"
    end if
    LName = shadaAlt(res("listName"))
    lDesc = shadaAlt(res("listDesc"))
    lPrivacy = res("privacy")
    creatorID = res("creator")
    creationTimeUTC = res("creationTimeUTC")
    lastUpdateUTC = res("lastUpdateUTC")
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","lists.asp","list details",durationMs,""


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","lists.asp","username",""

mySQL = "SELECT * FROM users WHERE id="&creatorID
res.open mySQL, con
    creatorName = res("username")
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","lists.asp","username",durationMs,""


sqlShow = ""
if creatorName <> session("username") then sqlShow = "AND show" %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title><%=LName%> - רשימה אישית</title>
    <meta name="Description" content="רשימת מילים אישית בנושא - <%=LName%> | מילון ערבית מדוברת" />
    <meta name="Keywords" content="רשימת מילים, אוסף מילים, ערבית מדוברת, מילים לשיעור, מילים לכיתה, מילים לשיחה" />
    <meta property="og:url"     content="https://rothfarb.info/ronen/arabic/lists.asp?id=<%=LID%>" />
    <meta property="og:type"     content="website" />
    <meta property="og:title"     content="<%=LName%> - רשימה אישית" />
    <meta property="og:description"     content="רשימת מילים אישית בנושא - <%=LName%> | מילון ערבית מדוברת" />
    <meta property="og:image"           content="https://rothfarb.info/ronen/arabic/img/lists/<%=LID%>.png" />
    <link rel="stylesheet" href="team/inc/edit.css" />

    <!--#include file="inc/header.asp"-->
    <style>
        h1,h3 {
            text-align:right;
        }
        .pTitle {
            background-color:#d4eaff;
            text-align:right;
            }
        .ul_inline {
            margin:0;
            padding:0;
            display:flex;
            justify-content:space-between;
        }
        .ul_inline li {
            display:inline-block;
        }
		.viewMenu {
			list-style:none;
			padding:0;
		}

		.viewMenu li {
			display:inline;
		}

		.button {
			background:#ffffff;
			border:1px solid #4191c2;
			color:#4191c2;
			cursor:pointer;
			padding:5px 10px;
		}

		.button:hover:not(.active) {
			background:#41b0c2;
			color:white;
		}
		
		.active {
			background:#4191c2;
			color:white;
			cursor:initial;
		}

        .star {
            background: white;
            border:2px dotted #4191c2;
            border-radius: 50%;    
            color:#4191c2;
            cursor:pointer;
            float:left;
            font-size:1.8em;
            padding:3px 7px 0px 7px;
            text-align: center;
            }
        .starOn { color:#fff900;}

        .eng {padding-left: 2px;}
        .harm {font-size:1.6em; line-height:.8;}
        .heb {padding-bottom: 4px; padding-right: 2px;}
        .heb a:link,.heb a:visited {color:#1988cc !important;}

        .listDiv > span {display:block; line-height: 15px;}
        .pos,.def {display:inline-block !important; font-size:small ;}

        .result {
            background-color:#ffffff60;
            padding:4px;
            border: 1px dotted #a5d0f3; 
            margin-bottom: 3px; 
            box-shadow:0px 6px 17px rgba(144, 190, 234, 0.21);
            margin-left:20px;
        }
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
    <script src="team/js/jquery.list.update.js"></script> <!-- THIS HAS THE JSON CODE-->
    <script>
        $(document).ready(function(){
            //$("#wordsSum").html("1");
            var cnt = $("#countMe").data("count");
            if (cnt > 1) $("#wordsSum").html(cnt + " מילים");
        });
    </script>
</head>
<body>
<style>
    #container {
        margin-top:0;
    }
</style>
<!--#include file="inc/top.asp"--><%

    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","lists.asp","main",LID
    
    if session("userID") then
        dim starred
        starred=false
        mySQL = "SELECT pos FROM listsUsers WHERE list="&LID&" AND user="&session("userID")
        res.open mySQL, con
            if not res.EOF then starred=true
        res.close
    end if

    mySQL = "SELECT DISTINCT words.id, words.show, words.arabic, words.arabicWord, words.hebrewTranslation, words.hebrewDef, words.pronunciation, words.status, words.imgLink, words.partOfSpeach, words.gender, words.number, wordsLists.listID, wordsMedia.mediaID, wordsLists.pos FROM (words INNER JOIN wordsLists ON words.id = wordsLists.wordID) LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE (((wordsLists.listID)=" & LID & ")" &sqlShow&") ORDER BY "& order
    res.open mySQL, con %>


<div class="table">
    <button class="button" onclick="location.href='lists.all.asp'" style="font-size:medium;">רשימות אישיות</button>
    <span class="star" onclick="location.href='listsToggle.asp?lid=<%=LID%>'"><%
        if starred then %>
            <span class="material-icons" title="הסרה ממועדפים">star</span><%
        else %>
            <span class="material-icons" title="הוספה למועדפים">star_border</span>
        <%
        end if %>
    </span>
</div>

<style>
    #listHead {
        background-color:#d4eaff;
        border:2px solid #4794c4;
        color:#4794c4;
        margin:10px auto;
    }

    #listHead h1 {
        margin:0;
    }
    #listHead td {
        border-bottom: 1px solid #4794c4;
        padding:2px 6px;
    }
</style>

<table id="listHead" class="table">
    <tr>
        <td><h1><%=LName%></h1></td>
        <td style="width:30px; text-align:center;">
            <span class="material-icons" title="<%
                select case lPrivacy
                    case 0 %>רשימה פרטית<%
                    case 1 %>רשימה לבעלי קישור<%
                    case 2 %>רשימה פומבית<%
                    case 3 %>רשימה משותפת<%
                end select %>"><%
                select case lPrivacy
                    case 0 %>lock<%
                    case 1 %>lock_open<%
                    case 2 %>public<%
                    case 3 %>group<%
                end select %>
            </span>
        </td>
    </tr><%
    if len(lDesc)>0 then
    %>
    <tr>
        <td colspan="2" style="padding:6px; background-color:#e8f4ff;">
            <%=lDesc%>
        </td>
    </tr><%
    end if %>
    <tr>
        <td colspan="2" style="padding:6px; font-size:0.8em; text-align:center;">
            <ul class="ul_inline">
                <li><span id="wordsSum">...</span></li>
                <li style="text-align:left;">
                   <a href="profile.asp?id=<%=creatorID%>"><%=creatorName%></a>
                    
                </li>
            </ul>
        </td>
    </tr>
</table>
<table class="table" style="font-size:0.8em; color:#ababab;">
    <tr>
        <td><%
            if len(lastUpdateUTC)>0 then %>
                    עריכה אחרונה - <%=Str2hebDate(lastUpdateUTC)%><%
            end if %>
        </td>
        <td style="text-align:left;">
            נוצר ב-<%=Str2hebDate(creationTimeUTC)%>
        </td>
    </tr>
</table>

<div class="table">
    <ul class="viewMenu">
        <li>
            <button class="button active">רשימה</button> 
            <button class="button" onclick="location.href='games.mem.list.asp?lid=<%=LID%>';">קלפי זיכרון</button>
            <button class="button" onclick="location.href='games.mem.pics.asp?lid=<%=LID%>';">תמונות לחיצות</button>
        </li>
        <li style="DISPLAY:NONE;"><span class="star<%if starred then%> starOn<%end if%>" title="מועדפים" onclick="location.href='listsToggle.asp?lid=<%=LID%>'">★</span></li>
    </ul>
</div>

<div class="table" style="text-align:right; font-weight: 400; font-size:.8em; padding-bottom: 8px;"><%
    if session("userID") = creatorID then %>

    <div style="padding:10px; background:#ffb6b655; border:0px solid #ffb6b6; margin:10px auto;">
        <h4 style="margin:0 auto 5px auto;">ניהול רשימה</h4>
        <li class="button" onclick="location.href='listsEdit.asp?id=<%=LID%>'">עריכת רשימה</li><%
        if session("userID")=1 or session("userID")=73 or session("userID")=76 then%>
        <div class="newRelDiv" data-ready="no" style="margin-top:5px; font-size:large; text-align:center;">
            <form action="listsWord.insert.asp" method="post" id="newRelForm" name="newRelForm">
                <input type="hidden" id="wordID" name="wordID" value="" />
                <input type="hidden" id="listID" name="listID" value="<%=LID%>" />
                <label for="items">הוספת מילה לרשימה</label>
                <br>
                <input class="newRelInput" name="items" autocomplete="off" placeholder="הקלידו מילה..." />
                <ul class="newRelSelect">
                </ul>
            </form>
        </div><%
        end if %>
    </div><%

    end if %>

</div>

<%

Function GetName (Names, Num)
    Dim Arr
    Arr = Split(Names, "|")
    GetName = Arr(Num)
End Function 

if res.EOF then %>
    <style>
        :root {
            --error-bg-color: #ff000036;
            --error-txt-color: #910505;
        }
        .emptyList {
            background:var(--error-bg-color);
            color:var(--error-txt-color);
            padding:80px 0px;
            text-align:center;
        }
    </style>
    <div class="table emptyList">טרם נוספו מילים לרשימה זו
        <br><%
        if session("userID") = creatorID then %>
        <br><button><a href="welcome.asp#lists">מדריך שימוש קצר</a></button><%
        end if %>
    </div><%
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
                    <div class="arb harm"><%=res("arabic")%></div>
                    <div class="arb keter"><%=shadaAlt(res("arabicWord"))%></div>
                    <div class="eng"><%=res("pronunciation")%></div>
                </div><%
                if (session("userID")=1 or session("userID")=73) and session("userID")=creatorID then %>
                <style>
                    .removeBtn {
                        bottom:45px;
                        cursor: pointer;
                        left:-7px;
                        opacity:30%;
                        POSITION:absolute;
                    }
                    .removeBtn:hover {
                        opacity:100%;
                    }
                </style>
                <div class="itemActions" style="margin-bottom:10px; POSITION:relative;">
                    <span class="material-icons removeBtn" title="הסרה מהרשימה">delete</span>
                    <form style="DISPLAY:NONE;" class="RUSure" action="listsWord.remove.asp">
                        להסיר מהרשימה?
                        <button type="submit" class="RUSureYes">כן</button>
                        <button type="button" class="RUSureNo">אופס, לא משנה</button>
                        <input type="hidden" name="wordID" value="<%=res("id")%>"/>
                        <input type="hidden" name="listID" value="<%=LID%>"/>
                    </form>
                </div>
                    <%
                end if %><%
                lastID = res("id")
            end if
            res.moveNext
	    Loop %>
        </div><%
end if
res.close %>
    <span id="countMe" data-count="<%=countMe%>"></span><%

    '+1 to viewcount IF not creator or siteAdmin'
    dim viewcount,sessionExist
    sessionExist = false
    if session("userID") then sessionExist = true
    if (sessionExist=false OR (sessionExist=true) AND (session("userID")<>creatorID) AND (session("userID")<>1)) then
        mySQL = "SELECT * FROM lists WHERE id="&LID
        res.open mySQL, con
            viewcount = res("viewCNT")
            if isnull(viewcount) then viewcount=0 
            viewcount = viewcount+1
        res.close

        mySQL = "UPDATE lists SET viewCNT="& viewcount &" WHERE id="&LID
        cmd.CommandType=1
        cmd.CommandText=mySQL
        Set cmd.ActiveConnection=con
        cmd.execute ,,128 
    end if %>


    <div id="tagsNew" class="lMenu">
        <ul>
        <li style="border:2px #afc3d6 dotted; background-color: #e9f2fb;"><a href="listsNew.asp">+ רשימה חדשה</a></li><%
        if session("userID") then
            mySQL = "SELECT TOP 7 * FROM lists WHERE creator="&session("userID")&" ORDER BY lastUpdateUTC DESC"
            res.open mySQL, con
                Do until res.EOF 
                    If cint(LID) = res("id") then
                        LName = shadaAlt(res("listName"))%>
                        <li id="current"><%
                    else %>
                        <li><%
                    End if%>
                        <a href="lists.asp?id=<%=res("id")%>"><%=shadaAlt(res("listName"))%></a></li><%
                    res.moveNext
                Loop
            res.close
            response.write "<hr/>"
            mySQL = "SELECT TOP 7 * FROM lists WHERE creator<>"&session("userID")&" AND privacy > 1 ORDER BY  Rnd(-(100000*ID)*Time())"
            res.open mySQL, con
                Do until res.EOF 
                    If cint(LID) = res("id") then
                        LName = shadaAlt(res("listName"))%>
                        <li id="current"><%
                    else %>
                        <li><%
                    End if%>
                        <a href="lists.asp?id=<%=res("id")%>"><%=shadaAlt(res("listName"))%></a></li><%
                    res.moveNext
                Loop
            res.close
        else
            mySQL = "SELECT TOP 10 * FROM lists WHERE privacy > 1 ORDER BY Rnd(-(100000*ID)*Time())"
            res.open mySQL, con
                Do until res.EOF 
                    If cint(LID) = res("id") then
                        LName = shadaAlt(res("listName"))%>
                        <li id="current"><%
                    else %>
                        <li><%
                    End if%>
                        <a href="lists.asp?id=<%=res("id")%>"><%=shadaAlt(res("listName"))%></a></li><%
                    res.moveNext
                Loop
            res.close 
        end if %>
        </ul>
    </div>

<%
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","lists.asp","main",durationMs,LID+" "+LName
%>



</div>

<script>
    $(function() {

        $(".removeBtn").on("click",function(){
            $(this).hide();
            $(this).closest(".itemActions").find(".RUSure").show();
        });

        $(".RUSureNo").on("click",function(){
            $(this).parent().hide();
            $(this).closest(".itemActions").find(".removeBtn").show();
        });
    });
</script>

<script type="text/javascript"><!--
    //document.title = document.title + " : <%=LName%>";
//--></script>



<%
if session("userID")=1 then %>
<style>
    #adminTasks {max-width:600px; margin:0 auto;}
    #adminTasks h3 {color:#a94e00; line-height:0em;}
    #adminTasks ol {border:1px solid #ff7600; color:#a94e00; background:white; padding:10px 40px;}
</style>
<div id="adminTasks">
    <h3>משימות אדמין לדף זה</h3>
    <ol>
        <li>הוספת מילים מהירה בלי עלייה חדשה של הדף</li>
        <li>איחוד 3 התצוגות לדף אחד - שינוי תצוגה באמצעות JQUERY</li>
    </ol>
</div>
<%
end if %>


<!--#include file="inc/trailer.asp"-->