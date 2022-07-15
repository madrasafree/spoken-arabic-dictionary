<!--#include file="inc/inc.asp"--><%
If (session("role") and 2) = 0 then Response.Redirect "login.asp"

dim countme
countme = 0
%>
<!DOCTYPE html>
<html>
<head>
	<title>הוספת קורס</title>
    <meta name="robots" content="none">
    <script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js"></script>
<!--#include file="inc/header.asp"-->
    <style>
        a:link, a:visited {color: #1988cc;}
        a:hover {text-decoration: underline;}
        h2 {margin:0px 0px 15px 0px; font-size: 1.2em;}
        span {font-size:smaller;}

        .box {border: 1px solid rgba(0, 0, 0, 0.2); padding: 10px; margin-bottom: 20px; background-color: rgba(231, 237, 253, 0.25);}
        .box textarea {width:98%; border:dotted 1px;}
        .boxSub {  padding-top: 10px; margin-top: 10px; border-top: 1px solid rgba(0, 0, 0, 0.2);}
        .boxes {width:100%; margin-bottom: 20px;}
        .boxes > div {display: table-cell;min-width:200px;padding: 10px;background-color: rgba(231, 237, 253, 0.25); border: 1px solid rgba(0, 0, 0, 0.2);}
        .boxes > div:first-child {border-left: 0;}
        input[name=days] {margin: 0 6px 0 3px;}
        .line {width: 100%;}
        .line > div {display:inline-block;}
        .line > input {width: 100%; border: 0; background: none;}
        .nikudHelp { width:100%; text-align: center;}
        .nikudHelp, .nikudHelp2 {vertical-align: middle;}
        .nikudHelp td {height: 30px; width: 30px; border: 1px dotted; background-color: rgba(204, 204, 204, 0.5);}
        .nikudHelp th {font-weight: normal; border: 1px dotted; background-color: rgba(204, 204, 204, 0.5); padding: 0 4px;}
        .nikudHelp2 td {font-size: 3em; min-width: 40px; text-align: center; padding-bottom: 10px; border: 1px dotted;}
        #page {max-width: 842px; min-width: 320px; margin: 0 auto;}
        .tags > div {display: inline-block;padding:4px 8px; border: 1px dotted; margin-bottom:5px; background: white;}
        .trans {text-align: center; width:100%;}
        .trans td {border: 1px solid gray; padding: 3px;}
        .trans td:nth-child(2) {direction: ltr;}
        .trans span {display: block; font-size: small;}
        .words {font-size:xx-large;border: solid 1px #ddd; padding: 4px; background-color: white;}

        .req        {font-size:small; color:#cc5555;}
        .req:after  {content:"[חובה]";}

       
        @media (max-width:840px) {
            textarea {width:95%; min-width: 300px;}
            .box {border-width: 1px 0 0 0; margin: 0 auto; padding:5px; width: 95%;}
            .boxes {width:100%; min-width: 320px; margin: 0;}
            .boxes > div {display: block; width: 95%; padding: 5px; border-width: 1px 0 0 0; margin: 0 auto;}
            #nHelp {display: none;}
            .words {font-size:large;}
            .words input {line-height: 2;}
        }
    </style>
    <script>
        $(function() {
          $('#searchString2').focus(function() {
            left = $('#searchStringX').val().length;
            $('#searchString2').attr('maxlength', 250 - left)
          });
        });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->
<!--#include file="inc/topTeam.asp"-->

<h1 style="text-align:center; font-size:2em; margin:0.67em 0;">הוספת קורס חדש</h1>

<div style="width:100%;text-align: center; margin-bottom:20px;">
    <h2 style="margin-bottom:2px;">הרשאות</h2><%

    startTime = timer()
    'openDB "arabicSchools"
    openDbLogger "arabicSchools","O","courseNew.asp","permission",""
    

    mySQL = "SELECT * from schools WHERE adminID="&session("userID")
    res.open mySQL, con
    if res.EOF then
        if session("role")=15 then
            Response.write "מנהל האתר. רשאי להוסיף קורסים לכל בתי הספר"
        else %>
            <div style="color:#cc5555;">
                <div style="font-weight:bold;">אין לך הרשאה להוסיף קורסים באף בית ספר.</div>
                על מנת לקבל הרשאה, יש לשלוח מייל למנהל האתר - arabic4hebs@gmail.com
            </div><%
        end if
    else
        do until res.EOF
            Response.write "נציג בית-ספר : "&res("school")&"<Br/>"
            res.movenext
        loop
    end if
    res.close


    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicSchools","C","courseNew.asp","permission",durationMs,""
    
    %>
</div>

<div id="page">

    <form action="courseNew.insert.asp" method="post" id="new" name="new" onsubmit="return CheckFields(this);">

    <div class="boxes">
        <div class="box" style="background-color:rgba(212, 234, 255, 0.5);">
            <div>
                <div>בחירת בית ספר <span class="req"></span></div>
                <div>
                    <select name="school" style="width:100%; font-size:2em;" required>
                    <option value="" style="color:#ddd;"></option><%


                        startTime = timer()
                        'openDB "arabicSchools"
                        openDbLogger "arabicSchools","O","courseNew.asp","schools",""

                        if session("role")=15 then
                            mySQL = "SELECT id,school FROM schools ORDER BY school"
                        else
                            mySQL = "SELECT id,school FROM schools WHERE adminID="&session("userID")&" ORDER BY school"
                        end if
                        res.open mySQL, con
                        do until res.EOF %>
                            <option value="<%=res("id")%>" id="school<%=res("id")%>"><%=res("school")%></option><%
                            res.moveNext
                        loop
                        res.close

                        endTime = timer()
                        durationMs = Int((endTime - startTime)*1000)
                        'closeDB
                        closeDbLogger "arabicSchools","C","courseNew.asp","schools",durationMs,""
                        
                        %>
                    </select>
                </div>
            </div>
            <!--CHECK DATE IS IN THE FUTURE-->
            <div class="boxSub">
                <div>תאריך פתיחה <span class="req"></span></div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="startDate" type="date" class="nikud" name="startDate" required autofocus="true">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>שם הקורס <span class="req"></span></div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="cTitle" placeholder="..." type="text" class="nikud" name="cTitle" required>
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>
                    ימים
                </div>
                <div>
                    <input type="checkbox" name="days" value="1">א'
                    <input type="checkbox" name="days" value="2">ב'
                    <input type="checkbox" name="days" value="3">ג'
                    <input type="checkbox" name="days" value="4">ד'
                    <input type="checkbox" name="days" value="5">ה'
                    <input type="checkbox" name="days" value="6">שישי
                    <input type="checkbox" name="days" value="7">שבת
                </div>
            </div>
            <div class="boxSub">
                <div>
                    מיקום <span class="req"></span>
                </div>
                <div>
                    <select name="area" style="font-size:2em;">
                        <option value="1" id="area1">מרכז</option>
                        <option value="2" id="area2">צפון</option>
                        <option value="3" id="area3">דרום</option>
                    </select>
                </div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="city" placeholder="שם הישוב" type="text" class="nikud" name="city" required>
                    </div>
                </div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="180" id="address" placeholder="כתובת" type="text" class="nikud" name="address" required>
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>קישור לדף הקורס באתרכם</div>
                <div class="words">
                    
                    <div class="line" style=" color:#1988cc; font-size:initial;" dir="ltr">
                        <label style="color:gray;">http://</label>
                        <input maxlength="180" id="sourceL" placeholder="www.yourwebsite.co.il" type="text" class="nikud" name="sourceL" style="width:auto;">
                    </div>
                </div>
            </div>

        </div>
        <div class="box" style="background-color:rgba(212, 234, 255, 0.5);">

            <div>
                <div>שם המורה</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="tutor" placeholder="..." type="text" class="nikud" name="tutor">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>רמה <span class="req"></span>
                    <span style="display:block;">מ-1 עד 5, כאשר 1 הרמה הכי בסיסית ו-5 הכי מתקדמת.</span>
                </div> 
                <div>
                    <select name="level" style="font-size:2em;">
                        <option value="1" id="level1">1 - מתחילים</option>
                        <option value="2" id="level2">2</option>
                        <option value="3" id="level3">3</option>
                        <option value="4" id="level4">4</option>
                        <option value="5" id="level5">5 - מתקדמים</option>
                    </select>
                </div>
            </div>
            <div class="boxSub">
                <div>מספר מפגשים</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="meetings" type="number" class="nikud" name="meetings" min="1">
                    </div>
                </div>
                <div>אורך כל מפגש (בשעות)</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="hours" type="number" class="nikud" name="hours" step="any">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>עלות (ש"ח)</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="price" type="number" class="nikud" name="price">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>
                    הערות
                </div>
                <div style="text-align:center;"><textarea maxlength="255" rows=4 cols=40 id="info" class="nikud" name="info" placeholder="עלויות נוספות ; איזה להג אתם מלמדים? איזה רקע דרוש? האם אתם מלמדים כתיבה/קריאה או משתמשים רק בתעתיק?... וכל פרט שאתם רוצים להעביר לתלמידים פוטנציאלים."></textarea></div>
            </div>
            <!--If NOT admin, give only the choice of 'added by school'-->
            <div class="boxSub">
                מקור המידע <span class="req"></span>
            </div>
            <div>
                <select name="source" style="font-size:2em;">
                    <option value="1" id="source1">נציג בית הספר</option><%
                    if session("role")=15 then %>
                    <option value="2" id="source2">אתר האינטרנט</option>
                    <option value="3" id="source3">דף הפייסבוק</option><%
                    end if %>
                </select>
            </div>


        </div>
    </div>
    <div style="width:90%; margin:20px auto; text-align: center;">
        <input style="font-size: large;padding: 10px;" type="submit" value="הוסף קורס" name="Submit1" id="Submit1" />
    </div>
    </form>
</div>


<!--#include file="inc/trailer.asp"-->
<script type="text/javascript" src="js/scripts.js"></script>
</body>
</html>