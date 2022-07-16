<!--#include file="inc/inc.asp"-->

<!--
ISSUES
2020-09-21: JQUERY toggle repeats too many times. ask Yaniv to make shorter
--> <%
if (session("role") and 2) = 0 then
    session("msg") = "יש להתחבר על מנת להוסיף מילים"
    response.Redirect "login.asp"
end if

dim countme
countme = 0 %>
<!DOCTYPE html>
<html>
<head>
	<title>הוספת מילה</title>
    <meta name="ROBOTS" content="NONE">
    <script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js"></script>
<!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="inc/guide.css" />
    <link rel="stylesheet" href="inc/edit.css" />
    <script src="js/jquery.new.edit_tmp.js"></script>
</head>
<!--#include file="inc/functions.asp"-->
<body>

<!--#include file="inc/top.asp"-->
<!--#include file="inc/topTeam.asp"-->

<h1 style="text-align:center;">הוספת מילה חדשה</h1>

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
            <li style="margin-bottom:10px;">ודאו שהמילה לא מופיעה כבר במילון
                <br/><span>ניתן להעזר ב<a href="https://rothfarb.info/ronen/arabic/list.asp" target="allWords">רשימת כל המילים במילון</a></span></li>
        </ol>
    </div>
    <div class="boxes" id="20min" style="border:1px solid #cccccc; margin: 0 auto 10px auto; padding:10px; width:90%; max-width:500px; background-color:#fbdcdc75;color:rgb(230, 89, 89); ">
        <ul>
            <li>מטעמי אבטחה, אחרי <b><%=Session.Timeout%></b> דקות מרגע שדף זה נטען, לא ניתן יהיה להזין את המידע מהדף.</li>
            <br/>
            <li>על מנת שעבודתכם לא תהיה לחינם, אנא הקפידו לסיים וללחוץ על כפתור 'הוסף מילה' במסגרת זמן זה.</li>
        </ul>
    </div>

    <form action="new.insert.asp" method="post" id="new" name="new" onsubmit="return validateForm()">
    <input type="HIDDEN" id="wordID" value="0"><!-- THIS IS SENT TO RELATIONS MAKER jquery.new.edit.js / json.asp -->
    <div style="width:100%;border:5px solid #6ea9d470; box-sizing:border-box;">
        <div class="words">
            <div class="line" style="color:#1988cc;">
                <input REQUIRED maxlength="50" id="hebrew" placeholder="עברית" type="text" class="nikud" name="hebrewTranslation" onkeypress="nikudTyper(this,event)" autocomplete="off" autofocus="true">
            </div>
            <div class="line" style="color:#1988cc; line-height:.5;">
                <input maxlength="50" id="hebDef" placeholder="פירושון" type="text" class="nikud hebDef" name="hebDef" style="font-size:.5em; line-height:.5;" autocomplete="off">
            </div>
            <div class="line" style="color:#2ead31;">
                <input REQUIRED maxlength="50" id="arabic" placeholder="ערבית" type="text" class="nikud" style="text-align:center;" name="arabic" autocomplete="off">
            </div>
            <div class="line" style="color:#2ead31;">
                <input REQUIRED maxlength="50" id="arabicWord" placeholder="תעתיק" type="text" class="nikud" style="text-align:center;" name="arabicWord" onkeypress="nikudTyper(this,event)" autocomplete="off">
            </div>
            <div id="anchor" class="line" style="color:#d17111;">
                <input REQUIRED maxlength="50" id="english" placeholder="הגייה באנגלית" type="text" dir="ltr" name="pronunciation" autocomplete="off" />
            </div>
        </div>
    </div>
    <div class="boxSub" style="text-align:center;padding:5px 8px;">
        <div class="button" id="toggleAttrs">מאפיינים</div>
        <div class="button" id="toggleTags">תגיות</div>
        <div class="button" id="toggleRelations">קשרים</div>
        <div class="button" id="toggleNotes">הערות</div>
        <div class="button" id="toggleExactMore" style="background:#e2fbe2; color:#55ad4f; border-color:#acda9d;">תוצאות מדויקות</div>
        <div class="button info" id="toggleGuide">כללי תעתיק</div>
        <div class="button info" id="toggleNikud">איך לנקד</div><%
        '1=ronen ; 73=yaniv ; 77=hadar ; 129 = sharon'
        if (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=129) then %>
        <div class="button admin" id="toggleVideo">וידאו</div><%
        end if
        if (session("userID")=1 or session("userID")=73) then %>
        <div class="button admin" id="toggleImage">תמונה</div><%
        end if
        if session("userID")=1 then %>
        <div class="button admin" id="toggleDialect">ניב</div>
        <div class="button admin" id="toggleOrigin">מקור</div><%
        end if%>
    </div>
    <div class="boxes">
        <div class="boxSub" id="nikud">
            <!--#include file="guide.embed.nikud.asp"-->
        </div>
        <div class="boxSub" id="guide">
            <!--#include file="guide.embed.asp"-->
        </div>

        <div class="boxSub" id="exactMore">
            <h2>תוצאות מדויקות</h2>
            <p>בנוסף למה שמוצג למשתמש, הוסיפו שרשראות חיפוש שיביאו את הערך הנ"ל כתוצאה מדויקת. לדוגמא: כתיב חסר, תעתיק שונה משלנו...</p>
            <mark>עד 250 תווים. ללא ניקוד. להפריד כל שרשרת בפסיק</mark>
            <div>
                <div style="display: inline-block;min-width:100%;">
                    <label>עברית</label>
                    <textarea id="hebrewCleanMore" name="hebrewCleanMore" maxlength="250" placeholder="תוצאות מדויקות נוספות - עברית"></textarea>
                </div>
                <div style="display: inline-block;min-width:100%;">
                    <label>ערבית</label>
                    <textarea id="arabicCleanMore" name="arabicCleanMore" maxlength="250" placeholder="תוצאות מדויקות נוספות - ערבית"></textarea>
                </div>
                <div style="display: inline-block;min-width:100%;">
                    <label>תעתיק עברי</label>
                    <textarea id="arabicHebCleanMore" name="arabicHebCleanMore" maxlength="250" placeholder="תוצאות מדויקות נוספות - תעתיק עברי"></textarea>
                </div>
            </div>
        </div>

        <div class="boxSub" id="notes">
            <h2>הערות<label>מידע נוסף שאתם רוצים לתת לצופה, שלא ניתן לציין במקום אחר</label></h2>
            <div style="text-align: center;">
                <textarea maxlength="220" rows=4 cols=40 id="textarea1" class="nikud" name="info"></textarea>
                <div id="textarea1_feedback"></div>
            </div>
        </div>

        <div class="boxSub" id="subjects">
            <h2>תגיות / נושאים<label>ניתן לסמן יותר מאחד, אך חשוב לשמור על רלוונטיות</label></h2>
            <div class="tags"><%
                dim LID, LName

                startTime = timer()
                'openDB "arabicWords"
                openDbLogger "arabicWords","O","new.asp","labels",""

                mySQL = "SELECT * FROM labels ORDER BY labelName"
                res.open mySQL, con
                    Do until res.EOF
                        If LID = res("id") then
                            LName = res("labelName") 
                        End If
	                    %><div><input name="label<%=res("id")%>" id="label<%=res("id")%>" type="checkbox"/> <%=res("labelName")%></div>
	                    <%
	                    res.moveNext
                        countme = countme + 1
                        if countme mod 2 = 0 then
                        %><%
                        End if
                    Loop
                res.close

                endTime = timer()
                durationMs = Int((endTime - startTime)*1000)
                'closeDB
                closeDbLogger "arabicWords","C","new.asp","labels",durationMs,""
                
                %>
            </div>
        </div>

        <div class="boxSub" id="attributes">
            <h2>מאפייני המילה</h2>
            <div style="display:table-row;">
                <div style="display:table-cell;">חלק דיבר</div>
                <div style="display:table-cell;">
                    <select id="partOfSpeach" name="partOfSpeach" style="padding:4px; margin-bottom:5px;">
                        <option value="1" id="partOfSpeach1">שם עצם</option>
                        <option value="2" id="partOfSpeach2">שם תואר</option>
                        <option value="3" id="partOfSpeach3">פועל</option>
                        <option value="4" id="partOfSpeach4">תואר הפועל</option>
                        <option value="7" id="partOfSpeach7">מילת קריאה</option>
                        <option value="5" id="partOfSpeach5">מילית יחס</option>
                        <option value="6" id="partOfSpeach6">מילית חיבור</option>
                        <option value="8" id="partOfSpeach8">תחילית</option>
                        <option value="9" id="partOfSpeach9">סופית</option>
                        <option value="0" id="partOfSpeach0" selected>לא ידוע / אחר</option>
                    </select>
                </div>
            </div>

            <div id="pos3" class="pos" style="display:table-row;">
                <div style="display:table-cell;">בניין</div>
                <div style="display:table-cell;">
                    <select name="binyan" style="padding:4px; margin-bottom:5px;">
                        <option value="0" id="binyan0">לא נבחר</option>
                        <option value="1" id="binyan1">1</option>
                        <option value="2" id="binyan2">2</option>
                        <option value="3" id="binyan3">3</option>
                        <option value="4" id="binyan4">4</option>
                        <option value="5" id="binyan5">5</option>
                        <option value="6" id="binyan6">6</option>
                        <option value="7" id="binyan7">7</option>
                        <option value="8" id="binyan8">8</option>
                        <option value="9" id="binyan9">9</option>
                        <option value="10" id="binyan10">10</option>
                    </select>
                </div>
            </div>

            <div style="display:table-row;">
                <div style="display:table-cell;">מין (בערבית)</div>
                <div style="display:table-cell;">
                    <select name="gender" style="padding:4px; margin-bottom:5px;">
                        <option value="1" id="gender1">זכר</option>
                        <option value="2" id="gender2">נקבה</option>
                        <option value="0" id="gender0">נטרלי</option>
                        <option value="3" id="gender3" selected>לא ידוע / לא רלוונטי</option>
                    </select>
                </div>
            </div>

            <div style="display:table-row;">
                <div style="display:table-cell; padding-left:5px;">מספר (בערבית)</div>
                <div style="display:table-cell;">
                    <select name="number" style="padding:4px; margin-bottom:5px;">
                        <option value="4" id="number4" selected>לא נבחר</option>
                        <option value="1" id="number1">יחיד</option>
                        <option value="2" id="number2">זוגי</option>
                        <option value="3" id="number3">רבים</option>
                        <option value="6" id="number6">שם קיבוצי</option>
                        <option value="0" id="number0">בלתי ספיר</option>
                        <option value="5" id="number5">לא רלוונטי</option>
                    </select>
                </div>
            </div>
        </div>
        <!--WORD RELATIONS-->
        <div class="boxSub" id="wordsRelations">
            <div id="newRelations">
                <h2>יצירת קשרים בין מילים</h2>
                <p><small>התחילו להקליד, ואז בחרו מתוך התוצאות</small></p>
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
                </div>
                <input id="relCount" name="relCount" type="hidden" value="0"/>
            </div>
        </div><%
        if session("role")=15 then%>
        <div class="boxSub" id="image">
            <h2>קישור לתמונה</h2>
            <p>הוסיפו קישור אך ורק לתמונות Common Creative.
            <br/><span style="color:#d5595e;">אם אתם לא בטוחים לגבי זכויות היוצרים, בררו מולנו ובינתיים המשיכו בלי תמונה.</span>
            <br/>קשרו לרזולוציה בינונית (מעל 250-250, מתחת ל-800-800)</p>
            <div><input type="text" dir="ltr" name="imgLink" style="width:95%;" placeholder="קישור לתמונה" maxlength="254" /></div>
            <p>חובה לשים קרדיט בהתאם לדרישות בעל הזכויות</p>
            <div><input type="text" dir="ltr" name="imgCredit" style="width:95%;" placeholder="זכויות יוצרים של התמונה" maxlength="254" /></div>
        </div><%
            '1=ronen ; 73=yaniv ; 77=hadar ; 129 = sharon'
            if (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=129) then %>

                <div class="boxSub" id="video" style="border:2px dotted #d5595e; padding: 5px;">
                    <h2>קישור לוידאו או אודיו</h2>
                    <span style="color:#d5595e;font-size:small;">מוצג כרגע רק לרונן, יניב, הדר ושרון.
                        <br/><b>טרם נבדק שזה עובד. רוב הסיכויים שצריך לעדכן קובץ הזנה למסד נתונים</b></span>

                    <p>קישור מדיה לערך זה:
                    <div style="color:#d5595e;font-size:small;">
                    בכל עריכה ניתן לקשר מדיה אחת בלבד. ניתן לקשר מדיה נוספת בעריכה נפרדת.
                    </div>          </p>                      
                    <select name="mediaNew" style="width:95%;">
                        <option value="">בחר מדיה</option><%

                    startTime = timer()
                    'openDB "arabicWords"
                    openDbLogger "arabicWords","O","new.asp","media",""

                    mySQL = "SELECT * FROM media ORDER BY id DESC"
                    res.open mySQL, con
                    do until res.EOF %>
                        <option value="<%=res("id")%>" style="font-size:small;"><%=res("id")%> | <%=res("description")%> | <%=res("credit")%></option><%
                        res.moveNext
                    loop
                    res.close 
                    
                    endTime = timer()
                    durationMs = Int((endTime - startTime)*1000)
                    'closeDB
                    closeDbLogger "arabicWords","C","new.asp","media",durationMs,""
                    
                    %>
                    </select>
                    <p style="text-align:left; margin-top:15px;"><a href="mediaControl.asp" target="mediaBank">הצג את בנק המדיה</a></p>
                </div><%
            end if%>

        <div class="boxSub" id="dialect">
            <div>ניב</div>
            <h2>לא פעיל עדיין</h2>
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
            <h2>לא פעיל עדיין</h2>
            <div><input disabled type="radio" value="0" name="originWord" id="originWord0" /><label for="originWord0">זו צורת המקור</label></div>
            <!-- להוסיף גם אופציה למי שלא יודע מה היא צורת המקור -->
            <div><input disabled type="radio" value="1" name="originWord" id="originWord1" /><label for="originWord1">צורת המקור היא</label> <input type="text" name="originWord" xonkeyup="updateSelect(value)" id="originWord" /></div>
        </div><%
    end if %>
    </div>
	
    <div style="width:90%; margin:20px auto; text-align: center;">
        <input style="font-size: large;padding: 10px;" type="submit" value="הוסף מילה" name="Submit1" id="Submit1" />
    </div>

    </form>
</div>


<!--#include file="inc/trailer.asp"-->
<script src="js/scripts.js"></script>
</body> 
</html>