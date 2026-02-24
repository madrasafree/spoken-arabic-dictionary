<!--#include file="includes/inc.asp"-->
<!--#include file="includes/functions/functions.asp"--><%

'openDB "arabicWords"
openDbLogger "arabicWords","O","dashboard.lists.asp","single",""

dim listID, pTitle, x, total, where,quickOK
mySQL = ""
quickOK = false
listID = 99
listID = request("listID")
select case listID
    case 1
        pTitle = "מילים שטרם נבדקו <span style='display:block;font-size:small;'>לא מציג ערכים מוסתרים</span>"
        where = "status=0 AND show=true"
        quickOK = true
    case 2
        pTitle = "מילים עם חשד לטעות"
        where = "status=-1"
    case 3
        pTitle = "מילים מוסתרות"
        where = "show=false"
    case 4
        pTitle = "מילים ללא ערבית"
        where = "len(arabic)=0"
    case 5
        pTitle = "עברית עם תו בעייתי"
        where = "((hebrewTranslation LIKE '%/%') OR (hebrewTranslation LIKE '%\%') OR (hebrewTranslation LIKE '%)%') OR (hebrewTranslation LIKE '%(%'))"
    case 6
        pTitle = "ללא סוג מילה"
        where = "partOfSpeach=0"
    case 7
        pTitle = "ללא מספר"
        where = "number=4"
    case 8
        pTitle = "ללא מגדר"
        where = "gender=3"
    case 9
        pTitle = "משפט לדוגמא בפורמט הישן"
        where = "len(example)>0"
    case 10
        pTitle = "מילות חיפוש בפורמט הישן"
        where = "len(searchString)>0"
    case 11
        pTitle = "תמונה עם קישור לא מאובטח"
        where = "imgLink LIKE '%http:%'"
    case 12
        pTitle = "פעלים ללא בניין"
        where = "partOfSpeach=3 AND binyan=0 AND show"
    case 13
        pTitle = "ש.עצם ביחיד ללא קישור לרבים"
        mySQL = "SELECT TOP 100 * FROM words INNER JOIN taskNoPlural ON words.id = taskNoPlural.word1 WHERE words.partOfSpeach=1 AND show"
    case 14
        pTitle = "ש.תואר ביחיד ללא קישור לרבים"
        mySQL = "SELECT TOP 100 * FROM words INNER JOIN taskNoPlural ON words.id = taskNoPlural.word1 WHERE words.partOfSpeach=2 AND show"
    case else
        session("msg") = "מספר סטטוס לא חוקי!<br/>אם התקלה חוזרת על עצמה, אנא פנו למנהל המילון"
        response.redirect ("default.asp")
end select %>
<!DOCTYPE html>
<html>
<head>
	<title><%=pTitle%></title>
    <META NAME="ROBOTS" CONTENT="NONE">
<!--#include file="includes/header.asp"-->
    <style>
        .checker {border: 0px solid; margin-bottom: 20px; padding: 7px 0 10px 0; text-align: center;}
        h1 {font-size:1em; margin:0;}
        h2 {font-size:1em;}
        #dashboard  { width:500px; margin:0 auto; }

        .listDiv > span {display:block; line-height: 15px;}
        .quickOK { background: #dfe6fb; padding:5px 10px; border-radius: 10px; border:1px solid #8697e2; }
        .quickEdit { background: #fbdfe6; padding:5px 10px; border-radius: 10px; border:1px solid #e28686; }
        

        .eng {padding-left: 2px;}
        .heb {padding-bottom: 4px; padding-right: 2px;}
        .heb a:link,.heb a:visited {color:#1988cc !important;}

        .pos,.def {display:inline-block !important; font-size:small ;}

        .result {background-color:#ffffff60;padding:4px;border: 1px dotted #a5d0f3; margin-bottom: 3px; box-shadow:0px 6px 17px rgba(144, 190, 234, 0.21);}
        .result:hover, fieldset:hover {background-color: #fff; border:1px solid #a5d0f3; cursor:pointer;}
        .icons {display: inline-block; position: absolute; top: 0px; left:0px;}
        .correct {width:15px;opacity:0.4; position: absolute; top:9px; left:5px;}
        .imgLink {width:25px;opacity:0.5; float: none; position: absolute; top:4px; left: 42px;}
        .audio {max-width:16px ; opacity: 0.5; float: none; position: absolute; top:9px; left: 26px;}
        .erroneous {width:15px;opacity:0.7; position: absolute; top:9px; left:5px;}


        @media (max-width: 499px) {
            .arb {font-size:1.5em;}
            .eng,.heb {float:none;}
            #dashboard {width: 90%;}
        }
    </style>
</head>
<body>
<!--#include file="includes/top.asp"-->
<div id="dashboard">
    <div id="pTitle"><h1><%=pTitle%></h1></div>
    <span>הערכים מסודרים מותיק לחדש
    <br>מציג מקסימום 100 תוצאות</span>
    <div id="check" class="table"><%

        if mySQL="" then
            mySQL = "SELECT TOP 100 words.id, words.show, words.arabic, words.arabicWord, words.hebrewTranslation,words.hebrewDef, words.pronunciation, words.status, words.imgLink "&_
                "FROM words WHERE "&where&" ORDER BY creationTimeUTC"
            'mySQL = "SELECT TOP 100 words.id, words.show, words.arabic, words.arabicWord, words.hebrewTranslation,words.hebrewDef, words.pronunciation, words.status, words.imgLink,  wordsLinks.description "&_
            '    "FROM words LEFT JOIN wordsLinks ON words.id = wordsLinks.wordID "&_
            '    "WHERE "&where&" ORDER BY creationTimeUTC"
        end if
        'response.write "mySQL = "&mySQL
        'response.END
        res.open mySQL, con
	    Do until res.EOF %>
            <div class="result" onclick="location.href='word.asp?id=<%=res("id")%>'">
                <div class="heb" style="position:relative;float:none;"><a href="word.asp?id=<%=res("id")%>"><%=res("hebrewTranslation")%></a><%
                    if len(res("hebrewDef"))>0 then %>
                        <span class="def">(<%=trim(res("hebrewDef"))%>)</span><%
                    end if %>
                        <span class="icons"><%
                        if len(res("imgLink"))>0 then %>
                            <img src="assets/images/site/photo.png" alt="לערך זה יש תמונה" title="לערך זה יש תמונה" class="imgLink" /><%
                        end if
                        if res("show")=false then %>
                            <img src="assets/images/site/hidden.png" alt="ערך מוסתר" title="ערך מוסתר" class="correct" style="left:70px;opacity:1;" /><%
                        end if %>
                        </span><%
                    Select Case res("status")
                    Case 1 %>
                        <img src="assets/images/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" class="correct" /><%
                    Case -1 %>
                        <span style="background: #ff2f00; color: #ffffff; font-weight: bold; padding: 4px 10px; border-radius: 3px; position:absolute; left:0px; top:35px;">חשד לטעות</span><%
                    Case Else %>
                        <span style="background: #ff8d00; color: #ffffff; font-weight: bold; padding: 4px 10px; border-radius: 3px; position:absolute; left:0px; top:35px;">טרם נבדק</span><%
                    End Select %>
                </div>
                <div class="arb"><%=res("arabic")%></div>
                <div class="arb" style="font-size:1.6em;"><%=res("arabicWord")%></div>
                <div class="eng" style="float:none;"><%=res("pronunciation")%></div>
            </div><%
            if quickOK=true and res("show")=true and session("role")>6 then%>
            <div class="checker">
                <a href="team/edit.asp?id=<%=res("ID")%>" class="quickEdit">ערוך מילה</a>
                <a href="team/word.correct.quick.asp?id=<%=res("ID")%>" class="quickOK">אישור מהיר</a>
            </div><%
            end if
            res.movenext
        loop
        res.close %>
    </div>

</div><%

'closeDB
closeDbLogger "arabicWords","C","dashboard.lists.asp","single",durationMs,""

%>
<!--#include file="includes/trailer.asp"-->
</body>
</html>