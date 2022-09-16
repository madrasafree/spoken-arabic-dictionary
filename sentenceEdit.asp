<!--#include file="inc/inc.asp"--><%
if session("role") < 7 then
    session("msg") = "אינך מחובר/ת או שאין לך הרשאה מתאימה לערוך משפטים"
    response.redirect "test.sentences.asp" 
end if 


openDB "arabicUsers"
    'Checks if READ ONLY mode is Enabled
    mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readonly'"
    res.open mySQL, con
    if res(0) = true then
        session("msg") = "אין כרגע אפשרות לערוך משפטים. אנא נסו שנית מאוחר יותר"
        Response.Redirect Request.ServerVariables("HTTP_REFERER")
    end if
    res.close
closeDB

%>
<!DOCTYPE html>
<html>
<head>
    <meta name="ROBOTS" content="NONE">
	<title>עריכת משפט</title>
    <script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js"></script>
<!--#include file="inc/header.asp"-->
    <link rel="stylesheet" href="inc/guide.css" />
    <link rel="stylesheet" href="team/inc/edit.css" />
    <script>
        $(function() {

            //check that textareas don't exceed DB limit
            var text_max = 255;
            $('#textarea1').keyup(function() {
                var text_length = $('#textarea1').val().length;
                var text_remaining = text_max - text_length;

                $('#textarea1_feedback').html('נותרו עוד ' + text_remaining + ' תוים');
            });

            $('#textarea2').keyup(function() {
                var text_length = $('#textarea2').val().length;
                var text_remaining = text_max - text_length;

                $('#textarea2_feedback').html('נותרו עוד ' + text_remaining + ' תוים');
            });


            //animate movement to anchor
            var navigationFn = {
                goToSection: function(id) {
                    $('html, body').animate({
                        scrollTop: $(id).offset().top
                    }, 250);
                }
            }

            //hide stuff...
            $("#firstTimer").hide();
            $("#20min").hide();

            function hideall(){
                $("#notes").hide();
                $("#connect").hide();
                $("#guide").hide();
                $("#nikud").hide();
                return false;
            };

            hideall();
            $("#notes").show();


            //show stuff (THIS COULD REALLY USE A SHORTER VERSION)
            $("#toggleFirst").click(function() {
                $("#firstTimer").toggle(function(){
                    return false;
                });
            });

            $("#toggle20").click(function() {
                $("#20min").toggle(function(){
                    return false;
                });
            });

            $("#toggleGuide").click(function() {
                hideall();
                $("#guide").toggle(function(){
                    navigationFn.goToSection('#anchor');
                    return false;
                });
            });

            $("#toggleNotes").click(function() {
                hideall();
                $("#notes").toggle(function(){
                    navigationFn.goToSection('#anchor');
                    return false;
                });
            });

            $("#toggleConnect").click(function() {
                hideall();
                $("#connect").toggle(function(){
                    navigationFn.goToSection('#anchor');
                    return false;
                });
            });            

            $("#toggleNikud").click(function() {
                hideall();
                $("#nikud").toggle(function(){
                    navigationFn.goToSection('#anchor');
                    return false;
                });
            });

        });
    </script>
</head>
<!--#include file="inc/functions/functions.asp"-->
<body>
<!--#include file="inc/top.asp"-->

<h1 style="text-align:center;">עריכת משפט</h1>

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
    </div><%

    dim sID,hebrew,arabic,arabicHeb,info
    dim words,wordLocation,current,i,curWord,merge

    sID = request("sID")

    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","sentenceEdit.asp","single",""

    mySQL = "SELECT * FROM sentences WHERE id="&sID
    res.open mySQL, con
        hebrew = res("hebrew")
        arabic = res("arabic")
        arabicHeb = res("arabicHeb")
        info = res("info")
    res.close %>
    

    <form action="sentenceEdit.update.asp" method="post" id="edit" name="edit" onsubmit="return CheckFields(this);">
    <input style="display:none;" id="sID" name="sID" type="number" value="<%=sID%>"/>
    <div style="width:100%;border:5px solid #6ea9d470; box-sizing:border-box;">
        <div class="words">
            <div class="line" style="color:#1988cc;">
                <input maxlength="255" id="hebrew" placeholder="פירוש בעברית" value="<%=hebrew%>" type="text" class="nikud" name="hebrew" onkeypress="nikudTyper(this,event)" onchange="makeSearchStr()" onkeyup="makeSearchStr()" onblur="makeSearchStr()" required autofocus="true">
            </div>
            <div class="line" style="color:#2ead31;">
                <input maxlength="255" id="arabic" placeholder="כתב ערבי" value="<%=arabic%>" type="text" class="nikud" style="text-align:center;" name="arabic" onchange="makeSearchStr()" onkeyup="makeSearchStr()" onblur="makeSearchStr()">
            </div>
            <div class="line" style="color:#2ead31;">
                <input maxlength="255" id="arabicHeb" placeholder="תעתיק עברי" value="<%=arabicHeb%>" type="text" class="nikud" style="text-align:center;" name="arabicHeb" onkeypress="nikudTyper(this,event)" onchange="makeSearchStr()" onkeyup="makeSearchStr()" onblur="makeSearchStr()" required>
            </div>
        </div>
    </div>
    <div class="boxSub" style="text-align:center;padding:5px 8px;">
        <div class="button" id="toggleNotes">הערות</div>
        <div class="button" id="toggleConnect">שיוך למילים</div>
        <div class="button info" id="toggleGuide">כללי תעתיק</div>
        <div class="button info" id="toggleNikud">איך לנקד</div>
    </div>
    <div class="boxes">
        <div class="boxSub" id="nikud">
            <!--#include file="team/guide.embed.nikud.asp"-->
        </div>
        <div class="boxSub" id="guide">
            <!--#include file="team/guide.embed.asp"-->
        </div>
        <div class="boxSub" id="notes">
            <h2>הערות<label>מידע נוסף שאתם רוצים לתת לצופה, שלא ניתן לציין במקום אחר</label></h2>
            <div style="text-align: center;">
                <textarea maxlength="220" rows=4 cols=40 id="textarea1" class="nikud" name="info"><%=info%></textarea>
                <div id="textarea1_feedback"></div>
            </div>
        </div>
        <div class="boxSub" id="connect">
            <h2>שיוך המשפט למילים<label>הכנס מספר מילה, בהתאם למיקום המילה במשפט בערבית.</label></h2><%
            words = split(arabic," ") 
            current=0
            wordLocation = ""
            for i = current to ubound(words) %>
                <div style="display:inline-block; min-width:50px;">
                    <%=words(current)%>
                </div>
                <%=i%><%
                mySQL = "SELECT word,merge FROM wordsSentences WHERE sentence="&sID&" and location="&i
                res.open mySQL, con
                if res.EOF then
                    curWord = ""
                    merge = 1
                else
                    curWord = res("word")
                    merge = res("merge")
                end if
                res.close %>
                <input type="number" name="<%=i%>" value="<%=curWord%>" style="margin-bottom:4px; max-width:80px;"/>
                מיזוג תאים <input type="number" name="merge<%=i%>" value="<%=merge%>" style="margin-bottom:4px; max-width:40px;" />
                <br/><%                
                current = current+1
            next %>
        </div>
    </div>
	
    <div style="width:90%; margin:20px auto; text-align: center;">
        <input style="font-size: large;padding: 10px;" type="submit" value="עדכן משפט" name="Submit1" id="Submit1" />
    </div>
    </form><%
    
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicWords","C","sentenceEdit.asp","single",durationMs,""
    
    %>

</div>


<!--#include file="inc/trailer.asp"-->
<script type="text/javascript" src="js/scripts.js"></script>
</body>
</html>