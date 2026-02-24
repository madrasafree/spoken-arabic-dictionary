<!--#include file="includes/inc.asp"-->
<!--#include file="includes/functions/functions.asp"-->
<!--#include file="includes/time.asp"--><%

dim wordId, countMe, spacer, show, status, imgLink, imgCredit
dim	partsOfSpeach,pos,genders,gen,nums, binyan
dim creatorID,creationTimeUTC,userName,cTime,cTimeFix
dim pronunciation,arabic,arabicWord, hebTrans, info, example, origin
dim sndxHeb,sndxArb,hebDef,hebClean,searchString,needsEdit

wordId = request("id")

'openDB "arabicWords"
openDbLogger "arabicWords","O","word.asp","Labels load",wordId


dim lblCNT
mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
    lblCNT = res(0)
res.close

redim labelNames(lblCNT)
dim a,x,i,timePast
i=1


mySQL = "SELECT * FROM labels"
res.open mySQL, con
    do while not res.EOF
        labelNames(i) = res("labelName")
        'labelNames(i) = "ok"
        i=i+1
        res.movenext
    loop
res.close

'closeDB
closeDbLogger "arabicWords","C","word.asp","Labels load",durationMs,wordId



countMe = 0
needsEdit = false
spacer = ""

partsOfSpeach = "לא ידוע / אחר|שם עצם|שם תואר|פועל|תואר הפועל|מילית יחס|מילית חיבור|מילת קריאה|תחילית|סופית"
genders = "נטרלי|זכר|נקבה|לא ידוע / לא רלוונטי"

Function GetName (Names, Num)
    Dim Arr
    Arr = Split(Names, "|")
    GetName = Arr(Num)
End Function


'openDB "arabicWords"
openDbLogger "arabicWords","O","word.asp","Words Main",wordId

mySQL = "SELECT * FROM words LEFT JOIN " & _
	"(SELECT * FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T " & _
	"ON words.creatorID=T.ID WHERE words.id = "&wordId&" ORDER BY arabicWord"
res.open mySQL, con

    if res.eof then
        session("msg") = "הערך שחיפשת הוסר או אוחד עם ערך אחר"
        response.redirect "default.asp"
    end if
    hebClean = res("hebrewClean")
    hebTrans = res("hebrewTranslation")
    hebDef = trim(res("hebrewDef"))
    pronunciation = res("pronunciation")
    arabic = res("arabic")
    if len(arabic)=0 then 
        needsEdit = true
    end if
    arabicWord = res("arabicWord")
    creatorID = res("creatorID")
    creationTimeUTC = res("creationTimeUTC")
    userName = res("userName")
    info = res("info")
    example = res("example")
    if len(example)>0 then needsEdit = true
    pos = res("partOfSpeach")
    if len(pos)=0 then needsEdit = true
    gen = res("words.gender")
    if gen=3 then needsEdit = true
    nums = res("number")
    if nums=4 then needsEdit = true
    origin = res("originWordId")
    binyan = res("binyan")
    show = res("show")
    status = res("status")
    imgLink = res("imgLink")
    imgCredit = res("imgCredit")

    sndxArb=res("sndxArabicV1")
    sndxHeb=res("sndxHebrewV1")

    searchString = res("searchString") 'REMOVE WHEN ALL FIELD FINALLY DELETED FROM DB
    if len(searchString)>0 then needsEdit = true

res.close

'closeDB
closeDbLogger "arabicWords","C","word.asp","Words Main",durationMs,wordId+" "+hebTrans


%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <%if len(imgLink)>0 then%>
    <meta property="og:image" content="<%=imgLink%>" />
    <%else%>
    <meta property="og:image" content="assets/images/site/logo.jpg" />
    <%end if%>
<!--#include file="includes/header.asp"-->
    <title><%=hebTrans%> - איך אומרים בערבית</title>
    <meta property="og:title" content="<%=hebTrans%> - איך אומרים בערבית" />
    <meta property="og:type" content="website" />
    <link rel="stylesheet" href="assets/css/arabicTeam.css" />
	<style>
        h1 {
            opacity: 0.6;
            text-align: center;
            font-weight: 100;
            font-style: italic;
            margin-bottom: 3px;
            font-size: 1em;
        }

        main h2 {
            background-color: #8cc3fd;
            font-weight: 100;
            padding: 4px;
            max-width: 450px;
            margin: 0 auto 8px auto;
            color: white;
            letter-spacing: 0.2em;
        }

        h2 a:link,h2 a:visited {color:white;}

        fieldset {
            background-color:#ffffff90;
            border-color:#c0c0c0;
            border-style:dashed;
            border-width:1px 0;
            margin:0 auto 6px auto;
            padding:0;
            width:95%;
            }

        #container {
            margin-top:15px;
        }

        legend {
            background: #8cc3fd36;
            border:1px dotted #bbb;
            padding: 0 12px;
            text-align: center;
            }


        .hebDef {font-size:small; line-height: 15px; margin-bottom:2px;}

        .playAudio {
            font-size:50px;
            cursor:pointer;
        }

		.disabled { background-color: rgba(238, 238, 238, 0.87); border-radius:15px; cursor:initial;}
        .sentence:not(:last-child) {
            border-bottom:dotted 2px #8cc3fd;
        }
		#toolsClick,#historyClick { cursor:pointer;}
		#toolsTable { display:block; margin-top:20px; background-color:rgba(225, 226, 144, 0.36); padding:8px 10px 10px 0px;}
		#toolsTable > div {display:inline-block; width:100px; height:100px; border: 1px solid rgba(174, 120, 78, 1); margin: 5px 5px; border-radius: 15px; text-align: center; vertical-align: middle; background-color: white; box-shadow: 2px 2px 5px rgba(174, 120, 78, 0.66); color: rgb(174, 120, 78);}
		#toolsTable > div:hover:not(.disabled) {background-color: rgb(255, 239, 208); box-shadow: 2px 2px 15px #999; cursor:pointer;}
		#toolsTable p {display:table-cell; width:100px; height:100px; vertical-align:middle; padding:0 5px; font-size:small;}
		#toolsTable img {opacity: 0.7;}
		.disabled img {opacity: 0.3 !important;}
        #reportErr { display:none;padding:8px 10px 10px 0px;}
        .h2 {
            max-width: 450px;
            border: solid 2px #8cc3fd;
            margin-bottom: 20px;
            background-color: white;
        }

        .eng {padding-left: 2px;}
        .heb {padding-bottom: 4px; padding-right: 2px;}
        .heb a:link,.heb a:visited {color:#1988cc !important;}

        @media (min-width:1000px) {

            .flex-container {
                display:flex;
                border:0px solid black;
                justify-content: center;
            }

            .sctRight,.sctLeft {
                /* flex: 0; */
                max-width:500px;
                padding-right:15px;
            }

        }

    

        @media (max-width:610px) {
            .eng,.heb {float:none;}
        }        

        @media (min-width:610px) {
            .exact .result {font-size: 2em;}
        }   

	</style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script>
        $(document).ready(function(){
            $("#reportErr").hide();
            $("#toolsClick").click(function(){
                $("#reportErr").hide();
            });
            $("#errBtn").click(function(){
                $("#reportErr").slideToggle();
            });
            $("#back").click(function(){
                $("#reportErr").hide();
            });

            $("#myLists").change(function(){
                window.location = "listsWord.insert.asp?wordID="+<%=wordID%>+"&listID="+$(this).val();
            });
        });

        // $(window).on('load', function() {
        //     if ( $.trim($(".sctLeft").html()) ) {
        //         $('.sctLeft').css("flex","1");
        //         $('.sctRight').css("flex","1");

        //         // $('.sctLeft').css({
        //         //     // "background-color":"#8cc3fd13",
        //         //     // "border":"1px solid #8cc3fd"
        //         // });
        //     }
        // });

    </script>
</head>
<body>
<!--#include file="includes/top.asp"-->
<!--#include file="includes/banner.asp"-->

<main class="flex-container">
    <section class="sctRight">

        <!-- STATUS --><%
        if not show then %>
            <div class="tableH" style="border:dashed 2px red;">
                <img src="assets/images/site/hidden.png" alt="מילה זו מוסתרת מעיני הגולשים במילון" title="מילה זו מוסתרת מעיני הגולשים במילון" />
                <br/>ערך מוסתר (לא יופיע בתוצאות חיפוש)
            </div><%
        end if 
        Select Case status
            Case 1 %>
                <div class="tableH" style="color:#00800075;">
                    ✓ - ערך זה נבדק ונמצא תקין
                </div><%
            Case 0 
                needsEdit = true %>
                <div class="tableH">
                    <img src="assets/images/site/unchecked.png" alt="ערך זה טרם נבדק" title="ערך זה טרם נבדק" />
                    <br />ערך זה טרם נבדק
                </div> <%
            Case -1 
                needsEdit = true %>
                <div class="tableH" style="border:dashed 2px red;">
                    <img src="assets/images/site/erroneous.png" alt="ערך לא תקין" title="ערך לא תקין" />
                    <br />ערך זה סומן כ'לא תקין'.
                    <span style="display:inline-block;">ייתכן ואיננו מדויק.</span>
                </div> <%
        End Select %>


        <!-- WORD -->
        <div class="table exact" style="margin-bottom:10px;">
            <div class="result" style="box-shadow:rgba(0,0,0,0.45) 2px 2px 22px -3px; margin-bottom:20px; font-size:150%; cursor:initial;">
                <div title="המילה בעברית" class="heb"><%=hebTrans%><%
                    if len(hebDef)>0 then %>
                    <span title="פירושון" class="hebDef">(<%=hebDef%>)</span><%
                    end if %>
                </div>
                <div class="arb"><%
                    if len(arabic)>0 then %>
                        <div title="המילה בערבית"><%=arabic%></div><%
                    end if %>
                    <span title="ערבית בתעתיק עברי"><%=arabicWord%></span>
                </div>
                <div title="ערבית בתעתיק לועזי" class="eng">
                    <%=pronunciation%>
                </div>
                <div class="attr">
                    <div class="pos" title="חלק דיבר"><%
                        SELECT CASE pos
                            case 0 response.write "-"
                            case 1 response.write "שם עצם"
                            case 2 response.write "שם תואר"
                            case 3 response.write "פועל"
                                if binyan=>1 then %><span style="font-size:small;"> (בניין <%=binyan%>)</span><%end if
                            case 4 response.write "תואר הפועל"
                            case 5 response.write "מילית יחס"
                            case 6 response.write "מילית חיבור"
                            case 7 response.write "מילת קריאה"
                            case 8 response.write "תחילית"
                            case 9 response.write "סופית"
                        END SELECT %>
                    </div>     
                    <div class="gender" title="מין"><%
                        SELECT CASE gen
                            case 0 response.write "נטרלי"
                            case 1 response.write "זכר"
                            case 2 response.write "נקבה"
                            case 3 response.write "-"
                        END SELECT %>
                    </div>     
                    <div class="number" title="מספר"><%
                        SELECT CASE nums
                            case 0 response.write "בלתי ספיר"
                            case 1 response.write "יחיד"
                            case 2 response.write "זוגי"
                            case 3 response.write "רבים"
                            case 4 response.write "-"
                            case 5 response.write "לא רלוונטי"
                            case 6 response.write "שם קיבוצי"
                        END SELECT %>
                    </div>     
                </div>
            </div>
        </div>

        <!-- LABELS --><%
        'openDB "arabicWords"
        openDbLogger "arabicWords","O","word.asp","Labels display",wordId

        mySQL = "SELECT * FROM labels INNER JOIN wordsLabels ON labels.id=wordsLabels.labelID WHERE wordID=" + wordId + " ORDER BY labelName"
        res.open mySQL, con
        if not res.EOF then%>
            <div class="table" style="max-width:450px; margin: 0 auto 15px auto;"><%
            Do until res.EOF %>
                <a href="label.asp?id=<%=res("labelID")%>"><span class="label"><%=res("labelName")%></span></a> <%
                res.moveNext
            Loop%>
            </div><%
        end if
        res.close 
        
        'closeDB
        closeDbLogger "arabicWords","C","word.asp","Labels display",durationMs,wordId+" "+hebTrans
        %>

        <!-- INFO --><%
        if info <> "" then %>
            <div class="table h2">
                <h2>הערות</h2>
                <div style="padding: 0 8px 9px 8px;">
                    <%=info%>
                </div>
            </div><%
        end if %>

        <!--RELATIONS BETWEEN WORDS // START--><%
            dim wordMain,lastType,firstType,skip
            wordMain = 0
            lastType = -1 'PUT SAME TYPES IN ONE ROW'
            skip = false

            'openDB "arabicWords"
            openDbLogger "arabicWords","O","word.asp","Relations",wordId

            mySQL = "SELECT * FROM wordsRelations WHERE (word1="&wordID&" OR word2="&wordID&") AND relationType <> 99 ORDER BY relationType"
            res.open mySQL, con
            if NOT res.EOF then %>
                <div class="table h2">
                    <h2>קשרים בין מילים</h2><%

                    do until res.EOF %>
                        <fieldset><%
                            SELECT case res("relationType")
                                case 1 'NOT TESTED YET' 
                                    if lastType<>1 then %> 
                                        <legend>מילה נרדפת בעברית</legend><%
                                    end if
                                    lastType=1
                                    SELECT case cint(res("word1"))
                                        case cint(wordID) wordMain = res("word2")
                                        case else wordMain = res("word1")
                                    END SELECT
                                case 2 
                                    if lastType<>2 then %>
                                        <legend>מילה נרדפת בערבית</legend><%
                                    end if
                                    lastType=2
                                    SELECT case cint(res("word1"))
                                        case cint(wordID) wordMain = res("word2")
                                        case else wordMain = res("word1")
                                    END SELECT
                                case 3
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2") 
                                        if lastType<>3 then%>
                                            <legend>צורת הרבים</legend><%
                                        end if
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>3 then %>
                                            <legend>צורת היחיד</legend><%
                                        end if
                                    end if
                                    lastType=3
                                case 4 
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2") 
                                        if lastType<>4 then %>
                                            <legend>צורת הנקבה</legend><%
                                        end if
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>4 then %>
                                            <legend>צורת הזכר</legend><%
                                        end if
                                    end if
                                    lastType=4
                                case 5
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                    else 
                                        wordMain = res("word1")
                                    end if 
                                    if lastType<>5 then %>
                                        <legend>מילה הופכית</legend><%
                                    end if
                                    lastType=5
                                case 6
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                    else 
                                        wordMain = res("word1")
                                    end if 
                                    if lastType<>6 then %>
                                        <legend>להבדיל מ...</legend><%
                                    end if
                                    lastType=6
                                case 7
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                    else 
                                        wordMain = res("word1")
                                    end if
                                    if lastType<>7 then %>
                                        <legend>להבדיל מ...</legend><%
                                    end if
                                    lastType=7
                                case 8
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>8 then %>
                                            <legend>עונים</legend><%
                                        end if
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>8 then %>
                                            <legend>מענה ל</legend><%
                                        end if
                                    end if
                                    lastType=8
                                case 10
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>10 then %>
                                            <legend>צירופי מילים</legend><%
                                        end if
                                        lastType=10
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>11 then %>
                                            <legend>מורכב מ</legend><%
                                        end if
                                        lastType=11
                                    end if
                                case 12
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                    else 
                                        wordMain = res("word1")
                                    end if
                                    if lastType<>12 then %>
                                        <legend>משמעויות נוספות בעברית למילה
                                            <br/><%=arabicWord%>
                                        </legend><%
                                    end if
                                    lastType=12
                                case 13
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                    else 
                                        wordMain = res("word1")
                                    end if
                                    if lastType<>13 then %>
                                        <legend>משמעויות נוספות בערבית למילה 
                                            <br/><%=hebTrans%>
                                        </legend><%
                                    end if
                                    lastType=13
                                case 20
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>20 then %>
                                            <legend>נגזרות ממילה זו</legend><%
                                        end if
                                        lastType=20
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>21 then %>
                                            <legend>מקור הנגזרת</legend><%
                                        end if
                                        lastType=21
                                    end if
                                case 50
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>50 then %>
                                            <legend>בינוני פועל</legend><%
                                        end if
                                        lastType=50
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>51 then %>
                                            <legend>צורת יסוד</legend><%
                                        end if
                                        lastType=51
                                    end if
                                case 52
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>52 then %>
                                            <legend>בינוני פעול</legend><%
                                        end if
                                        lastType=52
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>53 then %>
                                            <legend>צורת יסוד</legend><%
                                        end if
                                        lastType=53
                                    end if
                                case 54
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>54 then %>
                                            <legend>מַצְדַר (שם פעולה)</legend><%
                                        end if
                                        lastType=54
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>55 then %>
                                            <legend>צורת יסוד</legend><%
                                        end if
                                        lastType=55
                                    end if
                                case 60
                                    if cint(res("word1")) = cint(wordID) then
                                        wordMain = res("word2")
                                        if lastType<>60 then %>
                                            <legend>צורת הסביל</legend><%
                                        end if
                                        lastType=60
                                    else 
                                        wordMain = res("word1")
                                        if lastType<>61 then %>
                                            <legend>צורת הפעיל</legend><%
                                        end if
                                        lastType=61
                                    end if
                                case 0
                                    if lastType<>0 then %>
                                        <legend>ראו גם :</legend><% 
                                    end if
                                    lastType = 0
                                    SELECT case cint(res("word1"))
                                        case cint(wordID) wordMain = res("word2")
                                        case else wordMain = res("word1")
                                    END SELECT
                                case else %>
                                        תקלה. אנא דווחו למנהלי האתר - סוג קשר לא קיים<% 
                            END SELECT
                            mySQL = "SELECT * FROM words WHERE id="&wordMain
                            res2.open mySQL, con 
                                if not res2.EOF and skip=false then %>
                                    <!--MAKE classes work with links-->
                                    <div style="line-height:15px; border-radius:7px; margin:3px;" onclick="location.href='word.asp?id=<%=wordMain%>';">
                                        <div class="heb" style="padding-bottom:0;">
                                            <%=res2("hebrewTranslation")%><%
                                            if len(res2("hebrewDef"))>0 then %>
                                                <span class="hebDef">(<%=res2("hebrewDef")%>)</span><%
                                            end if%>
                                        </div>
                                        <div class="arb">
                                            <%=res2("arabic")%>
                                        </div>
                                        <div class="arb" style="margin-top:12px; font-size:1.6em;">
                                            <%=res2("arabicWord")%>
                                        </div>
                                        <div class="eng" style="padding:9px 0 0 0;">
                                            <%=res2("pronunciation")%>
                                        </div>
                                    </div><%
                                end if
                                skip=false
                            res2.close
                            res.moveNext %>
                        </fieldset><%
                    loop %>
                    </div><%
                end if
                res.close 

            'closeDB
            closeDbLogger "arabicWords","C","word.asp","Relations",durationMs,wordId+" "+hebTrans
            %>

            <!-- RELATIONS BETWEEN WORDS // END -->


        <!-- DISPLAY LISTS --><%
        
        'openDB "arabicWords"
        openDbLogger "arabicWords","O","word.asp","Lists",wordId
        
        %>
        <div id="lists" class="table h2" style="max-width:450px; line-height:25px;">
            <h2><a href="lists.asp">רשימות אישיות</a></h2><%
            mySQL = "SELECT * FROM lists INNER JOIN wordsLists ON lists.id = wordsLists.listID WHERE wordID="&wordID
            res.open mySQL, con %>
                <ul><%
                do until res.EOF %>
                    <li>
                        <a href="lists.asp?id=<%=res("id")%>"><%=res("listName")%></a><%
                        if res("creator")=session("userID") then %>
                        [[<a href="listsWord.remove.asp?wordID=<%=wordID%>&listID=<%=res("listID")%>">הסר</a>]]<%
                        end if
                        %>
                    </li><%
                    res.moveNext
                loop %>
                </ul><%
            res.close


            if session("userID") then
                mySQL = "SELECT * FROM lists WHERE creator="&session("userID")
                res.open mySQL, con
                if res.EOF then %>
                    אין לך רשימות. <a href="lists.asp">צור רשימה חדשה</a><%
                else %>
                <div style="text-align:center; padding-bottom:10px;">
                    <select id="myLists" name="myLists" onchange="saveToList">
                    <option>הוסף לרשימה משלך</option><%
                    do until res.EOF %>
                        <option value="<%=res("id")%>"><%=res("listName")%></option><%
                        res.moveNext
                    loop %>
                    </select>
                </div><%
                end if
                res.close
            else %>
                <div style="font-size:small; padding:4px;">על מנת לעדכן רשימות, יש <a href="login.asp?returnTo=word.asp?id=<%=wordID%>">להתחבר</a></div><%
            end if %>
            
        </div><%
        
        'closeDB
        closeDbLogger "arabicWords","C","word.asp","Lists",durationMs,wordId+" "+hebTrans
        
        %>
        





    </section>
    <section class="sctLeft">

        <%

        'openDB "arabicWords"
        openDbLogger "arabicWords","O","word.asp","Media",wordId

        mySQL = "SELECT * FROM wordsMedia INNER JOIN media ON wordsMedia.mediaID=media.ID WHERE wordsMedia.wordID="&wordId
        res.open mySQL, con
        if not res.EOF then %>
<!-- DISPLAY MEDIA -->
            <div class="table h2">
            <h2>קבצי מדיה</h2><%
            do until res.EOF %>
                <div style="margin:0px auto 5px auto; text-align:center; max-width: 450px;"><%
                    SELECT Case res("mType")
                        case 1 'youtube' %>
                            <iframe class="youTube" 
                                    src="//www.youtube.com/embed/<%=res("mLink")%>?rel=0&theme=light" 
                                    allowfullscreen
                                    style="border:0;">
                            </iframe><%
                        case 21 'clyp.it' %>
                            <iframe width="100%" height="160" src="https://clyp.it/<%=res("mLink")%>/widget" frameborder="0"></iframe><%
                        case 22 'soundcloud' %>
                            <iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/<%=res("mLink")%>&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false"></iframe><%
                        case 23 'local ogg' %>
                            <audio id="audioPlayer">
                                <source src="audio/<%=res("mLink")%>" type="audio/ogg">
                                הדפדפן שלך לא תומך באלמנט האודיו.
                            </audio>
                            <div> 
                                <span class="material-icons playAudio" onclick="document.getElementById('audioPlayer').play()">play_circle_outline</span>
                            </div>                           
                            <%
                        case else
                    END SELECT %>
                    <div style="font-size:small; margin-top:3px;">תודה ל: <%
                        if len(res("creditLink"))>0 then %>
                            <a href="<%=res("creditLink")%>" target="_new" style="line-height:normal; vertical-align:middle;"><%
                            if res("credit") = "ערביט" then %>
                                <img src="assets/images/site/links.arabit.png" alt="ערביט" title="לחצו לדף המילה בפרויקט ערביט"/><%
                            else %>
                                <%=res("credit")%><%
                            end if %>
                            </a><%
                        else %>
                            <%=res("credit")%><%
                        end if %>
                    </div>
                </div><%
                res.movenext
            loop %>
            </div><%
        end if
        res.close 

        'closeDB
        closeDbLogger "arabicWords","C","word.asp","Media",durationMs,wordId+" "+hebTrans



        dim arabicFull,words,cls,lastID,merge
        cls="normal"
        lastID=0

        'openDB "arabicWords"
        openDbLogger "arabicWords","O","word.asp","Sentences",wordId

        mySQL = "SELECT * FROM sentences INNER JOIN wordsSentences ON sentences.id=wordsSentences.sentence WHERE wordsSentences.word="&wordID&" ORDER BY id"
        res.open mySQL, con
        if NOT res.EOF then %>
<!-- SENTENCES -->        
            <div class="table h2">
                <h2><a href="sentences.asp">משפטים לדוגמא</a></h2><%
            do until res.EOF
                if lastID<>res("id") then %>
                    <div class="sentence">
                        <div class="heb" style="margin-bottom:10px;">
                            <a href="sentence.asp?sID=<%=res("id")%>"><%=trim(res("hebrew"))%></a>
                        </div>
                        <div class="arb" style="padding:0;margin-bottom:10px;line-height:2;"><%
                            arabicFull = res("arabic")
                            words = split(arabicFull," ")
                            mySQL = "SELECT * FROM wordsSentences WHERE sentence ="&res("id")&" ORDER BY location"
                            res2.open mySQL, con
                                dim current,wordLocation
                                current=0
                                do until res2.EOF
                                    wordLocation = res2("location")
					                merge = res2("merge")
                                    while wordLocation > current
                                        'REPLACE ADDED SPACE WITH VAR
                                        response.write words(current)&" "
                                        current = current+1
                                    wend
                                    if cstr(wordID)=cstr(res2("word")) then
                                        cls="normal highlight"
                                    end if 
				
                                    ' if merge>=1 then open span 
                                    if merge >= 1 then %>
                                        <span class="<%=cls%>"><a href="word.asp?id=<%=res2("word")%>"><%
                                    end if
                                    ' print word
                                    response.write words(current)

                                    ' if merge>=2 then add space after word
                                    if merge>=2 then response.write " "

                                    ' if merge=<1 then close span 
                                    if merge =< 1 then %></a></span> <%
                                    end if
                                    current = current+1
                                    cls="normal"
                                    res2.moveNext
                                loop
                                for i = current to ubound(words)
                                    response.write words(current)&" "
                                    current = current+1
                                next
                            res2.close
                        %>
                        </div>
                        <div class="arb" style="padding-top:5px;"><%=res("arabicHeb")%></div><%
                        if len(res("info"))>0 then %>
                        <div style="background:#ffffff96; border: 1px solid #aaa; text-align:center; margin:5px 10px;font-size:smaller; padding:4px;">
                            הערה: <%=res("info")%>
                        </div><%
                        end if%>
                        
                    </div><%
                    end if
                    lastID = res("id")
                res.moveNext
            loop %>
            </div><%
        end if
        res.close 
        
        'closeDB
        closeDbLogger "arabicWords","C","word.asp","Sentences",durationMs,wordId+" "+hebTrans



        if len(example)>0 then %>
<!-- EXAMPLES (REPLACED BY SENTENCES) -->
            <div class="table h2">
                <h2>משפטים לדוגמא - פורמט ישן</h2>
                <div style="padding: 0 8px 9px 8px;">
                    <%=example%>  
                </div>
            </div><%
        end if


        if imgLink <> empty then %>
<!-- IMAGE -->
            <div class="table h2" style="background-color:white; text-align:center; margin-bottom:15px;" dir="ltr">
                <h2 style="text-align:right; margin:0;">תמונה להמחשה</h2>
                <img src="<%=imgLink%>" alt="<%=imgCredit%>" title="<%=imgCredit%>" class="photo" style="margin:0; box-sizing:border-box; max-height:300px;" />
                <div style="display:block; color:#aaa; padding:3px; font-size:small;">Credit : <%=imgCredit%></div>
            </div><%
        end if %>

    </section>
</main>

<!-- EDITORS AREA --><%

'openDB "arabicWords"
openDbLogger "arabicWords","O","word.asp","Editor",wordId

'check for duplics
dim firstDup
mySQL = "SELECT * FROM wordsRelations WHERE (word1="&wordID&" OR word2="&wordID&") AND relationType = 99 ORDER BY relationType"
res.open mySQL, con
if NOT res.EOF then
    needsEdit = true
    firstDup = true
end if

if (session("role") > 6) and (needsEdit=true) then %>
    <div class="table" style="background:white; border:2px solid #fd8c8c; margin-bottom:20px; max-width:450px;">
        <h2 style="background:#fd8c8c; color:#902b2b; margin:0; font-weight:100;">
            לטיפול עורכי מילים
            <span style="font-size:small;float:left; letter-spacing:0.1em;">עורכי מילים ומעלה</span>
        </h2>
        <ul style="line-height:1.5em;"><%
        if len(arabic)=0 then %>
            <li>הוספת כתב ערבי</li><%
        end if
        if pos=0 then %>
            <li>ציון סוג המילה</li><%
        end if
        if gen=3 then %>
            <li>ציון מין המילה</li><%
        end if
        if nums=4 then %>
            <li>ציון מספר</li><%
        end if
        if status<>1 then %>
            <li>אישור הערך</li><%
        end if
        if len(searchString)>0 then %>
            <li>להעביר 'מילות חיפוש' ל'תוצאות מדויקות'</li><%
        end if
        if len(example)>0 then %>
            <li>להעביר משפטים לדוגמא מפורמט ישן לחדש</li><%
        end if

        'DUPLICS 
        if firstDup = true then%>
            <li>טיפול בכפילויות:</li><%
            do until res.EOF
                if cint(res("word1")) = cint(wordID) then wordMain = res("word2") else wordMain = res("word1")
                mySQL = "SELECT * FROM words WHERE id="&wordMain
                res2.open mySQL, con 
                    if not res2.EOF then %>
                        <!--MAKE classes work with links-->
                        <fieldset>
                        <div style="line-height:15px; border-radius:7px; margin:3px;" onclick="location.href='word.asp?id=<%=wordMain%>';">
                            <div class="heb" style="padding-bottom:0;">
                                <%=res2("hebrewTranslation")%><%
                                if len(res2("hebrewDef"))>0 then %>
                                    <span class="hebDef">(<%=res2("hebrewDef")%>)</span><%
                                end if
                                if res2("show")=false then %>
                                    <span style="font-size:small; float:left; background:gray; color:white; transform: rotate(-15deg);">ערך מוסתר</span><%
                                end if%>
                            </div>
                            <div class="arb">
                                <%=res2("arabic")%>
                            </div>
                            <div class="arb" style="margin-top:12px; font-size:1.6em;">
                                <%=res2("arabicWord")%>
                            </div>
                            <div class="eng" style="padding:9px 0 0 0;">
                                <%=res2("pronunciation")%>
                            </div>
                        </div>
                        </fieldset><%
                    end if
                res2.close
                res.moveNext
            loop %>
            <div style="padding:10px; font-size:small; text-align:center;">יש לכם מילה חדשה להוסיף? שקלו "לדרוס" ערך שהוסתר</div><%
        end if %>
        </ul>        
    </div><%
end if
res.close 

'closeDB
closeDbLogger "arabicWords","C","word.asp","Editor",durationMs,wordId+" "+hebTrans
%>



<hr style="border:0; height:1px; background-image:linear-gradient(to right, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.30), rgba(0, 0, 0, 0));">
<br>
<!-- ID -->    
<h1>איך אומרים <%=hebClean%> בערבית?</h1>
<div class="table" style="font-size:small; opacity:.6; text-align:center;">
    מס"ד: <%=wordId%> | אינדקס קולי: <%=sndxHeb%>, <%=sndxArb%>
</div>


<!-- EDIT HISTORY -->    
<div class="table" style="margin:10px auto; text-align:center;">
    <span onclick="location.href='word.edit.asp?id=<%=wordID%>'" role="button" id="toolsClick">עריכה</span> | <span onclick="location.href='word.history.asp?id=<%=wordID%>'" role="button" id="historyClick"> היסטוריה </span>
</div>


<!--#include file="includes/trailer.asp"-->