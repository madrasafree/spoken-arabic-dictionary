<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/string.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/time.asp"-->
<%
dim ok, countme, wordID, lockFrom, lockTo, lockDiff
countme = 0
wordID = request("ID")
ok = false
'TO EDIT, AT LEAST 1 OF 2 CONDITIONS MUST BE MET:
'1 - The user has an editor's role.
'2 - The user is the creator of the word, and it has not been aproved yet.


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","word.edit.asp","permission",""


mySQL = "SELECT creatorID,status,lockedUTC FROM words WHERE id="&wordID
res.open mySQL, con
    if len(res("lockedUTC"))>0 then
        if session("userID") <> CINT(right(res("lockedUTC"),len(res("lockedUTC"))-24)) then
            lockFrom = replace(left(res("lockedUTC"),19),"T"," ")
            lockTo = replace(left(AR2UTC(now()),19),"T"," ")
            lockDiff = dateDiff("n",lockFrom,lockTo)
            if lockDiff < 30 then 
                session("msg") = "הערך נחסם לעריכה (30 דקות) לפני "&lockDiff&_
                " דקות. כנראה שמישהי אחרת עורכת אותו כרגע. אנא נסו שוב עוד מאוחר יותר"
                response.redirect "word.asp?id="&wordID
            end if
        end if
    end if

    if session("role") > 6 then
        ok = true
    else
        if session("role") < 3 then
            session("msg") = "התחבר/י למערכת על מנת לערוך"
        else
            if (res("creatorID")=session("userID")) AND (res("status")<>1) then
                ok=true
            else
                session("msg") = "אין לך הרשאה לערוך מילה זו. סיבות אפשריות: אין לך הרשאת עורך ; זו לא מילה שאתה הוספת למילון ; אתה הוספת את המילה, אך היא כבר אושרה."
            end if
        end if
    end if
res.close


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","word.edit.asp","permission",durationMs,""




if ok=false then Response.Redirect "login.asp?returnTo=word.asp?id="&wordID 


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","word.edit.asp","lock",""


mySQL = "UPDATE words SET lockedUTC='"&AR2UTC(now())&"_uid"&session("userID")&"' WHERE id="&wordID
res.open mySQL, con
    ' response.write "mySQL = "&mySQL
    ' response.end
    cmd.CommandType=1
    cmd.CommandText=mySQL
    Set cmd.ActiveConnection=con
    cmd.execute ,,128
'res.close


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","word.edit.asp","lock",durationMs,""


%>
<!DOCTYPE html>
<html>
<head>
	<title>עריכת מילה</title>
    <META NAME="ROBOTS" CONTENT="NONE">
    <script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js"></script>
<!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="team/inc/arabicTeam.css" />
    <link rel="stylesheet" href="team/inc/guide.css" />
    <link rel="stylesheet" href="team/inc/edit.css?v2" />
    <script src="team/js/jquery.new.edit.js"></script> <!-- THIS HAS THE JSON CODE-->
</head>
<body>
<!--#include file="inc/top.asp"-->

<h1 style="text-align:center; margin:0;">עריכת מילה</h1>
<div id="page">

    <div style="text-align:center; margin: 0 auto 5px auto; max-width:500px;">
        <div id="toggleFirst" class="button" style="width:45%;">
            <div style="font-weight:bold;">פעם ראשונה?</div>
            <div>לחצו כאן</div></div>
        <div id="toggle20" class="button" style="width:45%;color:rgb(230, 89, 89);">
            <div style="font-weight:bold;">יש לכם 20 דקות</div>
            <div>לחצו להסבר</div>
        </div>
    </div>
    <div class="boxes" id="firstTimer" style="border:1px solid #cccccc; margin: 0 auto 10px auto; padding:10px; width:90%; max-width:500px; background-color:#ffffff75; ">
        <ol style="line-height: 15px; margin-bottom:10px;">
            <li style="margin-bottom:10px;">קראו את <a href="https://rothfarb.info/ronen/arabic/guideTeam.asp" target="guideTeam">מדריך הוספה ועריכת מילה</a></li>
        </ol>
    </div>
    <div class="boxes" id="20min" style="border:1px solid #cccccc; margin: 0 auto 10px auto; padding:10px; width:90%; max-width:500px; background-color:#fbdcdc75;color:rgb(230, 89, 89); ">
        <ul>
            <li>מטעמי אבטחה, אחרי <b><%=Session.Timeout%></b> דקות מרגע שדף זה נטען, לא ניתן יהיה להזין את המידע מהדף.</li>
            <br/>
            <li>על מנת שעבודתכם לא תהיה לחינם, אנא הקפידו לסיים וללחוץ על כפתור 'עדכן מילה' במסגרת זמן זה.</li>
        </ul>
    </div>

    <form action="team/edit.update.asp?id=<%=wordID%>" method="post" id="edit" name="edit">
    <input type="HIDDEN" id="wordID" value="<%=wordID%>"><%


    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","word.edit.asp","word details",""


    mySQL = "SELECT * FROM words WHERE id="&wordID
	res.open mySQL, con
	    if res.EOF then
            session("msg")="Error. ID not in Database."
            response.redirect "default.asp"
        else %>
            <div style="width:100%;border:5px solid #6ea9d470; box-sizing:border-box;">
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input REQUIRED maxlength="50" value="<%=server.htmlencode(res("hebrewTranslation"))%>" id="hebrew" placeholder="עברית" type="text" class="nikud" name="hebrewTranslation" onkeypress="nikudTyper(this,event)">
                    </div>
                    <div class="line" style="color:#1988cc; line-height:.5;">
                        <input maxlength="50" id="hebDef" value="<%=res("hebrewDef")%>" placeholder="פירושון" type="text" class="nikud hebDef" name="hebDef" style="font-size:.5em; line-height:.5;">
                    </div>
                    <div class="line" style="color:#2ead31;">
                        <input REQUIRED maxlength="50" value="<%=res("arabic")%>" id="arabic" placeholder="ערבית" type="text" class="nikud" style="text-align:center;" name="arabic">
                    </div>
                    <div class="line" style="color:#2ead31;">
                        <input REQUIRED maxlength="50" value="<%=res("arabicWord")%>" id="arabicWord" placeholder="תעתיק עברי" type="text" class="nikud" style="text-align:center;" name="arabicWord" onkeypress="nikudTyper(this,event)">
                    </div>
                    <div id="anchor" class="line" style="color:#d17111;">
                        <input REQUIRED maxlength="50" value="<%=res("pronunciation")%>" id="english" placeholder="הגייה באנגלית" type="text" dir="ltr" name="pronunciation" />
                    </div>
                </div>
            </div>
            <div>
                <div style="padding:5px 8px; border:0;">
                    <div class="boxSub" style="text-align:center;">
                        <div class="button" id="toggleAttrs">מאפיינים</div>
                        <div class="button" id="toggleTags">תגיות</div>
                        <div class="button" id="toggleRelations">קשרים</div>
                        <div class="button" id="toggleNotes">הערות</div>
                        <div class="button" id="toggleExactMore" style="background:#e2fbe2; color:#55ad4f; border-color:#acda9d;">תוצאות מדויקות</div>
                        <div class="button" id="toggleSearch" style="background:#e2fbe2; color:#55ad4f; border-color:#acda9d;">מילות חיפוש</div>
                        <div class="button info" id="toggleGuide">כללי תעתיק</div>
                        <div class="button info" id="toggleNikud">איך לנקד</div><%
                        '1=ronen ; 73=yaniv ; 77=hadar ; 129 = sharon'
                        if (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=129) then %>
                        <div class="button admin" id="toggleVideo">וידאו</div><%
                        end if
                        if session("userID")=1 or session("userID")=73 then %>
                        <div class="button admin" id="toggleImage">תמונה</div>
                        <div class="button" id="toggleExamples" style="background:#eee; color:#aaa;">דוגמאות</div><%
                        end if
                        if session("userID")=1 then %>
                        <div class="button admin" id="toggleDialect">ניב</div>
                        <div class="button admin" id="toggleOrigin">מקור</div><%
                        end if%>
                    </div>
                </div>                    
            </div>                    
            <div class="boxes">
                <div class="boxSub" id="nikud">
                    <!--#include file="team/guide.embed.nikud.asp"-->
                </div>
                <div class="boxSub" id="guide">
                    <!--#include file="team/guide.embed.asp"-->
                </div>

                <div class="boxSub" id="exactMore">
                    <h2>תוצאות מדויקות</h2>
                    <p>בנוסף למה שמוצג למשתמש, הוסיפו שרשראות חיפוש שיביאו את הערך הנ"ל כתוצאה מדויקת. לדוגמא: כתיב חסר, תעתיק שונה משלנו...</p>
                    <mark>עד 250 תווים. ללא ניקוד. להפריד כל שרשרת בפסיק</mark>
                    <div>
                        <div style="display: inline-block;min-width:100%;">
                            <label>עברית</label>
                            <textarea id="hebrewCleanMore" name="hebrewCleanMore" maxlength="250" placeholder="תוצאות מדויקות נוספות - עברית"><%=res("hebrewCleanMore")%></textarea>
                        </div>
                        <div style="display: inline-block;min-width:100%;">
                            <label>ערבית</label>
                            <textarea id="arabicCleanMore" name="arabicCleanMore" maxlength="250" placeholder="תוצאות מדויקות נוספות - ערבית"><%=res("arabicCleanMore")%></textarea>
                        </div>
                        <div style="display: inline-block;min-width:100%;">
                            <label>תעתיק עברי</label>
                            <textarea id="arabicHebCleanMore" name="arabicHebCleanMore" maxlength="250" placeholder="תוצאות מדויקות נוספות - תעתיק עברי"><%=res("arabicHebCleanMore")%></textarea>
                        </div>
                    </div>
                </div>

                <div class="boxSub" id="searchS">
                    <h2>מילות חיפוש<label>בנוסף למילה בערבית ובעברית, ניתן להוסיף צורות נוספות שיביאו למילה בעת חיפושן. למשל מילים נרדפות, או איות שגוי של המילה.</label></h2>
                    <div>
                        <div style="display: inline-block;min-width:100%;"><textarea id="searchString" name="searchString" maxlength="100" placeholder="עד 100 תווים יחד עם המילה בערבית ובעברית"><%=res("searchString")%></textarea></div>
                    </div>
                </div>

                <div class="boxSub" id="notes">
                    <h2>הערות<label>מידע נוסף שאתם רוצים לתת לצופה, שלא ניתן לציין במקום אחר</label></h2>
                    <div style="text-align: center;">
                        <textarea maxlength="220" rows=4 cols=40 id="textarea1" class="nikud" name="info"><%=res("info")%></textarea>
                        <div id="textarea1_feedback"></div>
                    </div>
                </div>
                <div class="boxSub" id="examples">
                    <h2>דוגמאות</h2>
                    <div style="text-align: center;">
                        <textarea maxlength="220" rows=4 cols=40 id="textarea2" class="nikud" name="example"><%=res("example")%></textarea>
                        <div id="textarea2_feedback"></div>
                    </div>
                </div>
                <div class="boxSub" id="subjects">
                    <h2>תגיות / נושאים<label>ניתן לסמן יותר מאחד, אך חשוב לשמור על רלוונטיות</label></h2>
                    <div class="tags"><%
                        dim inUse
                        mySQL = "SELECT * FROM labels ORDER BY labelName"
                        res2.open mySQL, con
                            Do until res2.EOF
                                mySQL = "SELECT * FROM wordsLabels WHERE wordID="&wordID
                                res3.open mySQL, con
                                    inUse = ""
                                    while not res3.EOF
                                        if res2("id") = res3("labelID") then inUse="checked"
                                        res3.moveNext
                                    wend
                                res3.close %>
	                            <div>
                                    <input <%=inUse%> name="label<%=res2("id")%>" id="label<%=res2("id")%>" type="checkbox"/> <%=res2("labelName")%>
                                </div><%
	                            res2.moveNext
                            Loop
                            res2.close
                        %>
                    </div>
                </div>
                <div class="boxSub" id="attributes">
                    <h2>מאפייני המילה</h2>
                    <div style="display:table-row;">
                        <div style="display:table-cell;">חלק דיבר</div>
                        <div style="display:table-cell;">
                            <select id="partOfSpeach" name="partOfSpeach" style="padding:4px; margin-bottom:5px;">
                                <option value="0" id="partOfSpeach0" <%if res("partOfSpeach")=0 then%>selected<%end if%>>לא ידוע / אחר</option>
                                <option value="1" id="partOfSpeach1" <%if res("partOfSpeach")=1 then%>selected<%end if%>>שם עצם</option>
                                <option value="2" id="partOfSpeach2" <%if res("partOfSpeach")=2 then%>selected<%end if%>>שם תואר</option>
                                <option value="3" id="partOfSpeach3" <%if res("partOfSpeach")=3 then%>selected<%end if%>>פועל</option>
                                <option value="4" id="partOfSpeach4" <%if res("partOfSpeach")=4 then%>selected<%end if%>>תואר הפועל</option>
                                <option value="7" id="partOfSpeach7" <%if res("partOfSpeach")=7 then%>selected<%end if%>>מילת קריאה</option>
                                <option value="5" id="partOfSpeach5" <%if res("partOfSpeach")=5 then%>selected<%end if%>>מילית יחס</option>
                                <option value="6" id="partOfSpeach6" <%if res("partOfSpeach")=6 then%>selected<%end if%>>מילית חיבור</option>
                                <option value="8" id="partOfSpeach8" <%if res("partOfSpeach")=8 then%>selected<%end if%>>תחילית</option>
                                <option value="9" id="partOfSpeach9" <%if res("partOfSpeach")=9 then%>selected<%end if%>>סופית</option>
                            </select>
                        </div>
                    </div>
                    <div id="pos3" class="pos" style="display:table-row;">
                        <div style="display:table-cell;">בניין</div>
                        <div style="display:table-cell;">
                            <select name="binyan" style="padding:4px; margin-bottom:5px;">
                                <option value="0" id="binyan0" <%if res("binyan")=0 then%>selected<%end if%>>לא נבחר</option>
                                <option value="1" id="binyan1" <%if res("binyan")=1 then%>selected<%end if%>>1</option>
                                <option value="2" id="binyan2" <%if res("binyan")=2 then%>selected<%end if%>>2</option>
                                <option value="3" id="binyan3" <%if res("binyan")=3 then%>selected<%end if%>>3</option>
                                <option value="4" id="binyan4" <%if res("binyan")=4 then%>selected<%end if%>>4</option>
                                <option value="5" id="binyan5" <%if res("binyan")=5 then%>selected<%end if%>>5</option>
                                <option value="6" id="binyan6" <%if res("binyan")=6 then%>selected<%end if%>>6</option>
                                <option value="7" id="binyan7" <%if res("binyan")=7 then%>selected<%end if%>>7</option>
                                <option value="8" id="binyan8" <%if res("binyan")=8 then%>selected<%end if%>>8</option>
                                <option value="9" id="binyan9" <%if res("binyan")=9 then%>selected<%end if%>>9</option>
                                <option value="10" id="binyan10" <%if res("binyan")=10 then%>selected<%end if%>>10</option>
                            </select>
                        </div>
                    </div>
                    <div style="display:table-row;">
                        <div style="display:table-cell;">מין (בערבית)</div>
                        <div style="display:table-cell;">
                            <select name="gender" style="padding:4px; margin-bottom:5px;">
                                <option value="1" id="gender1" <%if res("gender")=1 then%>selected<%end if%>>זכר</option>
                                <option value="2" id="gender2" <%if res("gender")=2 then%>selected<%end if%>>נקבה</option>
                                <option value="0" id="gender0" <%if res("gender")=0 then%>selected<%end if%>>נטרלי</option>
                                <option value="3" id="gender3" <%if res("gender")=3 then%>selected<%end if%>>לא ידוע / לא רלוונטי</option>
                            </select>
                        </div>
                    </div>
                    <div style="display:table-row;">
                        <div style="display:table-cell; padding-left:5px;">מספר (בערבית)</div>
                        <div style="display:table-cell;">
                            <select name="number" style="padding:4px; margin-bottom:5px;">
                                <option value="4" id="number4" <%if res("number")=4 then%>selected<%end if%>>לא נבחר</option>
                                <option value="1" id="number1" <%if res("number")=1 then%>selected<%end if%>>יחיד</option>
                                <option value="2" id="number2" <%if res("number")=2 then%>selected<%end if%>>זוגי</option>
                                <option value="3" id="number3" <%if res("number")=3 then%>selected<%end if%>>רבים</option>
                                <option value="6" id="number6" <%if res("number")=6 then%>selected<%end if%>>שם קיבוצי</option>
                                <option value="0" id="number0" <%if res("number")=0 then%>selected<%end if%>>בלתי ספיר</option>
                                <option value="5" id="number5" <%if res("number")=5 then%>selected<%end if%>>לא רלוונטי</option>
                            </select>
                        </div>
                    </div>
                </div>
                <!--WORD RELATIONS-->
                <div class="boxSub" id="wordsRelations">
                    <div>
                        <h2>קשרים בין מילים</h2><%
                        mySQL = "SELECT word1,word2,relationType FROM wordsRelations WHERE word1="&wordID&" OR word2="&wordID&" ORDER BY relationType"
                        res2.open mySQL, con
                        if res2.EOF then %>
                            לא קיימים קשרים לערך זה <%
                        else
                            do until res2.EOF  %>
                                <span style="font-size:small;color:#d5595e;">הסרת הסימון לצד הקשר, יבטל את הקשר</span>
                                <div class="crntRelDiv">
                                    <input name="rel" value="<%=res2("word1")%>b<%=res2("word2")%>b<%=res2("relationType")%>" type="checkbox" checked><%
                                    mySQL = "SELECT id,hebrewTranslation,arabic,arabicWord FROM words WHERE id="
                                    if cstr(res2("word1"))<>wordID then mySQL = mySQL&res2("word1")
                                    if cstr(res2("word2"))<>wordID then mySQL = mySQL&res2("word2")
                                    if cstr(res2("word2"))=wordID and cstr(res2("word1"))=wordID then mySQL = mySQL&res2("word2")
                                    'response.write mySQL

                                    res3.open mySQL, con %>
                                    <input type="text" DISABLED value="<%=res3("hebrewTranslation")%> - <%=res3("arabic")%> - <%=res3("arabicWord")%>" title="ID = <%=res3("id")%>">
                                    <br><%
                                    res3.close
                                    SELECT CASE res2("relationType")
                                        case 0 %>קשר אחר<%
                                        case 1 %>מילה נרדפת בעברית<%
                                        case 2 %>מילה נרדפת בערבית<%
                                        case 3 
                                            if cstr(res2(0))<>wordID then %>
                                                יחיד <%
                                            else %>
                                                רבים <%
                                            end if
                                        case 4
                                            if cstr(res2(0))<>wordID then %>
                                                זכר <%
                                            else %>
                                                נקבה <%
                                            end if
                                        case 5 %>הפכים<%
                                        case 6 %>דומה בערבית (להבדיל מ...)<%
                                        case 7 %>דומה בעברית (להבדיל מ...)<%
                                        case 8
                                            if cstr(res2(0))<>wordID then %>
                                                הערך הנ"ל (<%=res("arabicWord")%>) הוא - תגובה לקשר זה <%
                                            else %>
                                                תגובה <%
                                            end if
                                        case 10
                                            if cstr(res2(0))<>wordID then %>
                                                חלק מצירוף המילים <%
                                            else %>
                                                צירוף מילים <%
                                            end if
                                        case 12 %>משמעות נוספת בעברית<%                                        
                                        case 13 %>משמעות נוספת בערבית<%
                                        case 20
                                            if cstr(res2(0))<>wordID then %>
                                                צורת מקור<%
                                            else %>
                                                נגזרת<%
                                            end if
                                        case 50
                                            if cstr(res2(0))<>wordID then %>
                                                צורת היסוד<%
                                            else %>
                                                בינוני פועל<%
                                            end if
                                        case 52
                                            if cstr(res2(0))<>wordID then %>
                                                צורת היסוד<%
                                            else %>
                                                בינוני פעול<%
                                            end if
                                        case 54
                                            if cstr(res2(0))<>wordID then %>
                                                צורת היסוד<%
                                            else %>
                                                מַצְדַר (שם פעולה)<%
                                            end if
                                        case 60
                                            if cstr(res2(0))<>wordID then %>
                                                פעיל<%
                                            else %>
                                                סביל<%
                                            end if                                            
                                        case 99 %>כפילות<%
                                    END SELECT %>
                                </div><%
                                res2.moveNext
                            loop
                        end if
                        res2.close %>
                    </div>
                    <div id="newRelations">
                        <h3>הוספת קשרים חדשים:</h3>
                        <div class="newReldiv" data-ready="no">
                            <span class="relRemove">הסר קשר</span>
                            <input style="DISPLAY:NONE;" type="text" value="" name="relID" class="newRelID" /> 
                            <input style="DISPLAY:NONE;" type="text" value="" name="newRelType" class="relType" /> 
                            <input class="newRelInput" name="words" autocomplete="off" placeholder="הקלידו מילה..." />
                            <input class="newRelWord" type="text" value="" DISABLED /> 
                            <br>
                            <ul class="newRelSelect">
                            </ul> 
                            <br>
                            <select class="selectRel">
                                <option>בחר סוג קשר</option>
                                <option data-relType="1" class="rel-1">מילה נרדפת</option>
                                <option data-relType="2" class="rel-2">יחיד - רבים</option>
                                <option data-relType="3" class="rel-3">זכר - נקבה</option>
                                <option data-relType="4" class="rel-4">נשמע כמו / להבדיל מ...</option>
                                <option data-relType="14" class="rel-14">תגובה</option>
                                <option data-relType="6" class="rel-6">צירופים</option>
                                <option data-relType="7" class="rel-7">משמעות נוספת</option>
                                <option data-relType="8" class="rel-8">נגזרת</option>
                                <option data-relType="9" class="rel-9">בינוני פועל</option>
                                <option data-relType="10" class="rel-10">בינוני פעול</option>
                                <option data-relType="11" class="rel-11">מַצְדַר (שם פעולה)</option>
                                <option data-relType="5" class="rel-5">הפכים</option>
                                <option data-relType="13" class="rel-13">פעיל - סביל</option>
                                <option data-relType="99" class="rel-99">כפילות</option>
                                <option data-relType="0" class="rel-0">אחר</option>
                            </select>
                            <div class="newRelType">
                                <div class="rel-1-div">
                                    <input name="radio1" type="radio" value="1"><span>נרדפות עברית</span><br/>
                                    <input name="radio1" type="radio" value="2"><span>נרדפות ערבית</span>
                                </div>
                                <div class="rel-2-div">
                                    <input name="radio1" type="radio" value="31"><span>ערך זה (<i class="typedWord"></i>) הוא צורת הרבים</span><br/>
                                    <input name="radio1" type="radio" value="32"><span>ערך זה (<i class="typedWord"></i>) הוא צורת היחיד</span>
                                </div>
                                <div class="rel-3-div">
                                    <input name="radio1" type="radio" value="41"><span>ערך זה (<i class="typedWord"></i>) הוא צורת הנקבה</span><br/>
                                    <input name="radio1" type="radio" value="42"><span>ערך זה (<i class="typedWord"></i>) הוא צורת הזכר</span>
                                </div>
                                <div class="rel-4-div">
                                    <input name="radio1" type="radio" value="6"><span>דומה בערבית (להבדיל מ...)</span><br/>
                                    <input name="radio1" type="radio" value="7"><span>דומה בעברית (להבדיל מ...)</span>
                                </div>
                                <div class="rel-14-div">
                                    <input name="radio1" type="radio" value="81"><span>ערך הזה (<i class="typedWord"></i>) הוא התגובה לערך המקושר</span><br/>
                                    <input name="radio1" type="radio" value="82"><span>הערך המקושר הוא תגובה לערך זה (המילה החדשה)</span>
                                </div>
                                <div class="rel-6-div">
                                    <input name="radio1" type="radio" value="10"><span>ערך זה (<i class="typedWord"></i>) הוא צירוף המילים</span><br/>
                                    <input name="radio1" type="radio" value="11"><span>ערך זה (<i class="typedWord"></i>) הוא חלק מצירוף המילים</span>
                                </div>
                                <div class="rel-7-div">
                                    <input name="radio1" type="radio" value="12"><span>משמעות נוספת בעברית למילה (<i class="typedWord"></i>)</span><br/>
                                    <input name="radio1" type="radio" value="13"><span>משמעות נוספת בערבית למילה (<i class="typedWord2"></i>)</span>
                                </div>
                                <div class="rel-8-div">
                                    <input name="radio1" type="radio" value="21"><span>ערך זה (<i class="typedWord"></i>) הוא צורת המקור</span><br/>
                                    <input name="radio1" type="radio" value="20"><span>ערך זה (<i class="typedWord"></i>) הוא נגזרת של הערך המקושר</span>
                                </div>
                                <div class="rel-9-div">
                                    <input name="radio1" type="radio" value="51"><span>ערך זה (<i class="typedWord"></i>) הוא צורת היסוד</span><br/>
                                    <input name="radio1" type="radio" value="50"><span>ערך זה (<i class="typedWord"></i>) הוא בינוני פועל</span>
                                </div>
                                <div class="rel-10-div">
                                    <input name="radio1" type="radio" value="53"><span>ערך זה (<i class="typedWord"></i>) הוא צורת היסוד</span><br/>
                                    <input name="radio1" type="radio" value="52"><span>ערך זה (<i class="typedWord"></i>) הוא בינוני פעול</span>
                                </div>
                                <div class="rel-11-div">
                                    <input name="radio1" type="radio" value="55"><span>ערך זה (<i class="typedWord"></i>) הוא צורת היסוד</span><br/>
                                    <input name="radio1" type="radio" value="54"><span>ערך זה (<i class="typedWord"></i>) הוא מַצְדַר (שם פעולה)</span>
                                </div>
                                <div class="rel-13-div">
                                    <input name="radio1" type="radio" value="61"><span>ערך זה (<i class="typedWord"></i>) הוא צורת הפעיל</span><br/>
                                    <input name="radio1" type="radio" value="60"><span>ערך זה (<i class="typedWord"></i>) הוא צורת הסביל</span>
                                </div>
                                <div class="rel-5-div">
                                    <input name="radio1" type="radio" value="5"><span>הפכים</span>
                                </div>
                                <div class="rel-99-div">
                                    <input name="radio1" type="radio" value="99"><span>כפילות</span>
                                </div>
                                <div class="rel-0-div">
                                    <input name="radio1" type="radio" value="0"><span>אחר</span>
                                </div>
                            </div>
                            <input id="relCount" name="relCount" type="hidden" value="0"/>
                        </div>
                    </div>
                </div>
                <div class="boxSub" id="image">
                    <h2>קישור לתמונה</h2>
                    <p>הוסיפו קישור אך ורק לתמונות Common Creative.
                    <br/><span style="color:#d5595e;">אם אתם לא בטוחים לגבי זכויות היוצרים, בררו מולנו ובינתיים המשיכו בלי תמונה.</span>
                    <br/>קשרו לרזולוציה בינונית (מעל 250-250, מתחת ל-800-800)</p>
                    <div><input type="text" dir="ltr" value="<%=res("imgLink")%>" name="imgLink" style="width:95%;" placeholder="קישור לתמונה" maxlength="254" /></div>
                    <p>חובה לשים קרדיט בהתאם לדרישות בעל הזכויות:</p>
                    <div><input type="text" dir="ltr" value="<%=res("imgCredit")%>" name="imgCredit" style="width:95%;" placeholder="זכויות יוצרים של התמונה" maxlength="254" /></div>
                </div><%
            If (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=103 or session("userID")=118 or session("userID")=129)  then %>
                <div class="boxSub" id="video" style="border:2px dotted #d5595e; padding: 5px;">
                    <h2>קישור לוידאו או אודיו</h2>
                    <span style="color:#d5595e;font-size:small;">מוצג כרגע רק לרונן, יניב, הדר ושרון.</span>
                    <h3>קישורים קיימים:</h3><%

                    mySQL = "SELECT * FROM media LEFT JOIN wordsMedia ON media.id = wordsMedia.mediaID WHERE wordID="&wordID
                    'response.write mySQL
                    'response.end
                    res2.open mySQL, con
                    if res2.EOF then
                        response.write "<br/>לא נמצאה מדיה מקושרת לערך זה."
                    else
                        do until res2.EOF %>
                            <div class="mediaLinked">
                                <div><input name="mediaCheck<%=res2("mediaID")%>" type="checkbox" checked></div>
                                <div><%=res2("mediaID")%></div>
                                <div><%
                                    SELECT CASE res2("mType")
                                        case 1 response.write "YouTube"
                                        case 21 response.write "clyp.it"
                                        case 22 response.write "soundcloud"
                                    END SELECT %>
                                </div>
                                <div><%=res2("description")%></div>
                            </div><%
                            res2.moveNext
                        loop
                    end if
                    res2.close %>
                    <p>קישור מדיה לערך זה:
                    <div style="color:#d5595e;font-size:small;">
                    בכל עריכה ניתן לקשר מדיה אחת בלבד. ניתן לקשר מדיה נוספת בעריכה נפרדת.
                    </div>          </p>                      
                    <select name="mediaNew" style="width:95%;">
                        <option value="">בחר מדיה</option><%
                    mySQL = "SELECT * FROM media ORDER BY id DESC"
                    res2.open mySQL, con
                    do until res2.EOF %>
                        <option value="<%=res2("id")%>" style="font-size:small;"><%=res2("id")%> | <%=res2("description")%> | <%=res2("credit")%></option><%
                        res2.moveNext
                    loop
                    res2.close %>
                    </select>
                    <p style="text-align:left; margin-top:15px;"><a href="mediaControl.asp" target="mediaBank">הצג את בנק המדיה</a></p>
                </div><%
            end if%>
                    
            <div class="boxSub" id="dialect">
                <div>ניב</div>
                <div><span>בחר את הניבים הרלוונטים להגייה הזו</span></div>
                <div class="tags">
                    <div><input disabled name="#" id="#" type="checkbox"/> משולש</div>
                    <div><input disabled name="#" id="#" type="checkbox"/> ירושלמי</div>
                    <div><input disabled name="#" id="#" type="checkbox"/> לבנטינית / פלסטינית כפרית</div>
                    <div><input disabled name="#" id="#" type="checkbox"/> לבנטינית / פלסטינית עירונית</div>
                    <div><input disabled name="#" id="#" type="checkbox"/> לבנטינית / פלסטינית בדואית</div>
                    <div><input disabled name="#" id="#" type="checkbox"/> לבנטינית / לבנונית</div>
                    <div><input disabled name="#" id="#" type="checkbox"/> לבנטינית / סורית</div>
                </div>
                <div><span>לתת דוגמאות לאזורים / ישובים בארץ בהם נעשה שימוש בכל ניב וניב [רונן, 5/2015]</span></div>
            </div>

            <div class="boxSub" id="origin">
                <div>צורת המקור</div>
                <div><input disabled type="radio" value="0" name="originWord" id="originWord0" /><label for="originWord0">זו צורת המקור</label></div>
                <!-- להוסיף גם אופציה למי שלא יודע מה היא צורת המקור -->
                <div><input disabled type="radio" value="1" name="originWord" id="originWord1" /><label for="originWord1">צורת המקור היא</label> <input type="text" name="originWord" xonkeyup="updateSelect(value)" id="originWord" /></div>
            </div>
        </div>
        <div>
            <div style="margin-top:20px; border:1px dotted gray; padding:5px 5px 15px 5px;">
                <span>עדכנו את סטטוס המילה במידת הצורך.</span>
                <div style="display:table-row; line-height:2;">
                    <div style="display:table-cell;">סטטוס ערך:</div>
                    <div style="display:table-cell;">
                        <select name="status" style="margin-right:20px;" <%if session("role")<6 then %> disabled="disabled" title="אין לך הרשאה לשנות סטטוס ערך" <%end if%>>
                            <option value="0" id="status0" <%if res("status")=0 then%>selected<%end if%>>טרם נבדק</option>
                            <option value="1" id="status1" <%if res("status")=1 then%>selected<%end if%>>תקין</option>
                            <option value="-1" id="status-1" <%if res("status")=-1 then%>selected<%end if%>>חשד לטעות</option>
                        </select>
                    </div>
                </div>
                <div style="display:table-row;">
                    <div style="display:table-cell;">הצגה / הסתרה:</div>
                    <div style="display:table-cell;">
                        <select name="show" style="margin-right:20px;">
                            <option value="on" id="showOn" <%if res("show")=1 then%>selected<%end if%>>הצגה</option>
                            <option value="off" id="showOff" <%if res("show")=0 then%>selected<%end if%>>הסתרה</option>
                        </select>
                    </div>
                </div>
            </div>
            <div>
                <div class="box" style="margin-top: 20px;">
                    <div>
                        <h2>הסיבה לעריכה <span style="color:#d5595e;font-size:small; font-weight:100;">שדה חובה</span></h2>
                        
                        <textarea required maxlength="255" rows=4 cols=40 id="explain" class="nikud" name="explain" placeholder="ציינו כאן את הסיבה לעריכה"></textarea>
                        <div id="errMSG" style="color:red;"></div>
                    </div>
                </div>
            </div>

	
            <div style="width:90%; margin:20px auto; text-align: center;">
                <input style="border:0; color:white; background:#4d6bfd; padding:20px 80px; font-size:xx-large;" type="submit" value="עדכן מילה" name="Submit1" id="Submit1" />
                <br>
                <br>
                <button style="border:0; color:white; background:#fd4d4d; padding:10px 40px;" type="button" id="cancel" onclick="window.location.href='word.asp?id=<%=wordID%>'">
                    חזרה לדף מילה
                    <br>(ללא שמירה)
                </button>                
            </div><%
        end if
	res.close
    
    
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicWords","C","word.edit.asp","word details",durationMs,""
    
    
    %>
    </form>
</div>

<div id="loadingAnm" style="display:none; text-align:center;">
    <div class="lds-ring">
        <div></div>
        <div></div>
        <div></div>
        <div></div>
    </div>
    <div style="color:#82b1de; font-size:x-large;">אנא העזרו בסבלנות...</div>
</div>




<%
if session("userID")=1 then %>
<br><br>
<h3 style="color:#a94e00; line-height:0em;">משימות לדף זה</h3>
<ol style="border:1px solid #ff7600; color:#a94e00; background:white; padding:10px 40px;">
    <li>להציג 'ראו גם' בסוף הקישורים
    <li>קשרים - להציג תוצאות מדויקות בראש</li>
    <li>להציג משימות פתוחות כפי שמוצג בדף מילה</li>
    <li>הצעה אוטומטית לתעתיק</li>
    <li>סיכום שינויים אוטומטי + להפוך שדה נוכחי להערות נוספות</li>
    <li>ולידציה</li>
    <li>למנוע תצוגה רגעית של אזורים מוסתרים בעת עליית הדף</li>
</ol>

<%
end if %>







<!--#include file="inc/trailer.asp"-->
<script type="text/javascript" src="js/scripts.js"></script>

<script>
    $("#edit").on("submit",function(){
        $("#errMSG").empty();

        if ($("#hebrew").val() == "") {$("#errMSG").html("ERROR!"); return false; };
        if ($("#arabic").val() == "") {$("#errMSG").html("ERROR arabic!"); return false; };
        if ($("#arabicWord").val() == "") {$("#errMSG").html("ERROR arabicWord!"); return false; };
        if ($("#english").val() == "") {$("#errMSG").html("ERROR english!"); return false; };
        if ($("#explain").val().length < 4) {$("#errMSG").html("יש לכתוב מעל 3 תווים בהסבר"); return false; };      
        
        $("#loadingAnm").show();
        return true;
    });
</script>

</body>
</html>