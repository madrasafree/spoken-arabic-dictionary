<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
If (session("role") and 2) = 0 then Response.Redirect "login.asp"

dim countme,cID
cID = request("cID")
countme = 0
%>
<!DOCTYPE html>
<html>
<head>
	<title>עריכת פרטי קורס</title>
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

<h1 style="text-align:center; font-size:2em; margin:0.67em 0;">עריכת פרטי קורס קיים</h1><%
if len(cID)=0 then %>
        <div style="text-align:center;">
            <div style="color:#cc5555;font-size: 1.5em; padding: 5px;">מספר קורס חסר בכתובת הדף</div>
            <a href="../where2learn.asp">חזרה לרשימת הקורסים הקרובים</a>
        </div><%
    response.end
end if %>
<div style="width:100%;text-align: center; margin-bottom:20px;">
    <h2 style="margin-bottom:2px;">הרשאות</h2><%

startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","courseEdit.asp","single",""
    

    mySQL = "SELECT * from schools WHERE adminID="&session("userID")
    res.open mySQL, con
    if res.EOF then
        if session("role")=15 then
            Response.write "מנהל האתר. רשאי להוסיף קורסים לכל בתי הספר"
        else %>
            <div style="color:#cc5555;">
                <div style="font-weight:bold;">אין לך הרשאה להוסיף קורסים באף בית ספר.</div>
                על מנת לקבל הרשאה, יש לשלוח מייל למנהל האתר - yaniv@madrasafree.com
            </div><%
        end if
    else
        do until res.EOF
            Response.write "נציג בית-ספר : "&res("school")&"<Br/>"
            res.movenext
        loop
    end if
    res.close %>
</div>

<div id="page">

    <form action="courseEdit.update.asp" method="post" id="edit" name="edit" onsubmit="return CheckFields(this);">
    <input type="hidden" name="cID" value="<%=cID%>" />
    <%
    mySQL = "SELECT * from courses WHERE id="&cID
    res.open mySQL, con
    if res.EOF then %>
        <div style="text-align:center;">
            <div style="color:#cc5555;font-size: 1.5em; padding: 5px;">מספר קורס לא קיים במערכת</div>
            <a href="../where2learn.asp">חזרה לרשימת הקורסים הקרובים</a>
        </div><%
    else %>
    
    <div class="boxes">
        <div class="box" style="background-color:rgba(212, 234, 255, 0.5);">
            <div>
                <div>בחירת בית ספר <span class="req"></span></div>
                <div>
                    <select name="school" style="width:100%; font-size:2em;" required>
                    <option value="" style="color:#ddd;"></option><%
                        if session("role")=15 then
                            mySQL = "SELECT id,school FROM schools ORDER BY school"
                        else
                            mySQL = "SELECT id,school FROM schools WHERE adminID="&session("userID")&" ORDER BY school"
                        end if
                        res2.open mySQL, con
                        do until res2.EOF %>
                            <option value="<%=res2("id")%>" <%if res2("id")=res("school") then%> selected<%end if%> id="school<%=res2("id")%>"><%=res2("school")%></option><%
                            res2.moveNext
                        loop
                        res2.close %>
                    </select>
                </div>
            </div>
            <!--CHECK DATE IS IN THE FUTURE-->
            <div class="boxSub">
                <div>תאריך פתיחה <span class="req"></span></div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="startDate" type="date" class="nikud" name="startDate" required autofocus="true" value="<%=left(dateToStr(res("startDate")),10)%>">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>שם הקורס <span class="req"></span></div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="cTitle" value="<%=res("cTitle")%>" type="text" class="nikud" name="cTitle" required>
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>
                    ימים
                </div>
                <div>
                    <input type="checkbox" <%if (InStr(1,res("days"),"1"))>0 then%>checked<%end if%> name="days" value="1">א'
                    <input type="checkbox" <%if (InStr(1,res("days"),"2"))>0 then%>checked<%end if%> name="days" value="2">ב'
                    <input type="checkbox" <%if (InStr(1,res("days"),"3"))>0 then%>checked<%end if%> name="days" value="3">ג'
                    <input type="checkbox" <%if (InStr(1,res("days"),"4"))>0 then%>checked<%end if%> name="days" value="4">ד'
                    <input type="checkbox" <%if (InStr(1,res("days"),"5"))>0 then%>checked<%end if%> name="days" value="5">ה'
                    <input type="checkbox" <%if (InStr(1,res("days"),"6"))>0 then%>checked<%end if%> name="days" value="6">שישי
                    <input type="checkbox" <%if (InStr(1,res("days"),"7"))>0 then%>checked<%end if%> name="days" value="7">שבת
                </div>
            </div>
            <div class="boxSub">
                <div>
                    מיקום <span class="req"></span>
                </div>
                <div>
                    <select name="area" style="font-size:2em;">
                        <option value="1" <%if res("area")=1 then%>selected<%end if%> id="area1">מרכז</option>
                        <option value="2" <%if res("area")=2 then%>selected<%end if%> id="area2">צפון</option>
                        <option value="3" <%if res("area")=3 then%>selected<%end if%> id="area3">דרום</option>
                    </select>
                </div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="city" value="<%=res("city")%>" type="text" class="nikud" name="city" required>
                    </div>
                </div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="180" id="address" value="<%=res("address")%>" type="text" class="nikud" name="address" required>
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>קישור לדף הקורס באתרכם</div>
                <div class="words">
                    
                    <div class="line" style=" color:#1988cc; font-size:initial;" dir="ltr">
                        <label style="color:gray;">http://</label>
                        <input maxlength="180" id="sourceL" value="<%=res("sourceLink")%>" placeholder="www.yourwebsite.co.il" type="text" class="nikud" name="sourceL" style="width:auto;">
                    </div>
                </div>
            </div>

        </div>
        <div class="box" style="background-color:rgba(212, 234, 255, 0.5);">

            <div>
                <div>שם המורה</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="tutor" value="<%=res("tutor")%>" placeholder="..." type="text" class="nikud" name="tutor">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>רמה <span class="req"></span>
                    <span style="display:block;">מ-1 עד 5, כאשר 1 הרמה הכי בסיסית ו-5 הכי מתקדמת.</span>
                </div> 
                <div>
                    <select name="level" style="font-size:2em;">
                        <option value="1" <%if res("level")=1 then%>selected<%end if%> id="level1">1 - מתחילים</option>
                        <option value="2" <%if res("level")=2 then%>selected<%end if%> id="level2">2</option>
                        <option value="3" <%if res("level")=3 then%>selected<%end if%> id="level3">3</option>
                        <option value="4" <%if res("level")=4 then%>selected<%end if%> id="level4">4</option>
                        <option value="5" <%if res("level")=5 then%>selected<%end if%> id="level5">5 - מתקדמים</option>
                    </select>
                </div>
            </div>
            <div class="boxSub">
                <div>מספר מפגשים</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="meetings" type="number" class="nikud" name="meetings" min="1" value="<%=res("meetings")%>">
                    </div>
                </div>
                <div>אורך כל מפגש (בשעות)</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="hours" type="number" class="nikud" name="hours" step="any" value="<%=res("hours")%>">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>עלות (ש"ח)</div>
                <div class="words">
                    <div class="line" style="color:#1988cc;">
                        <input maxlength="80" id="price" type="number" class="nikud" name="price" value="<%=res("price")%>">
                    </div>
                </div>
            </div>
            <div class="boxSub">
                <div>
                    הערות
                </div>
                <div style="text-align:center;"><textarea maxlength="255" rows=4 cols=40 id="info" class="nikud" name="info"><%=res("info")%></textarea></div>
            </div>
            <div class="boxSub">
                מקור המידע <span class="req"></span>
            </div>
            <div>
                <select name="source" style="font-size:2em;">
                    <option value="1" <%if res("source")=1 then%>selected<%end if%> id="source1">נציג בית הספר</option><%
                    if session("role")=15 then %>
                    <option value="2" <%if res("source")=2 then%>selected<%end if%> id="source2">אתר האינטרנט</option>
                    <option value="3" <%if res("source")=3 then%>selected<%end if%> id="source3">דף הפייסבוק</option><%
                    end if %>
                </select>
            </div>

            <div class="boxSub">
                הצג / הסתר קורס <span class="req"></span>
            </div>
            <div>
                <select name="cStatus" style="font-size:2em;">
                    <option value="1" <%if res("cStatus")=1 then%>selected<%end if%> id="cStatus1">הצג</option>
                    <option value="33" <%if res("cStatus")=33 then%>selected<%end if%> id="cStatus33">הסתר</option>
                </select>
            </div>

        </div>
    </div>
    <div style="width:90%; margin:20px auto; text-align: center;">
        <input style="font-size: large;padding: 10px;" type="submit" value="עדכן קורס" name="Submit1" id="Submit1" />
        <span style="float:left;"><a href="../where2learn.asp">חזרה ללא שמירה</a></span>
    </div>
    </form>
</div><%

end if 

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSchools","C","courseEdit.asp","single",durationMs,""


%>


<!--#include file="inc/trailer.asp"-->
<script type="text/javascript" src="js/scripts.js"></script>
</body>
</html>