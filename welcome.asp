<!--#include file="inc/inc.asp"-->
<!--#include file="team/inc/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">
	<title>ברוכים הבאים</title>
    <!--#include file="inc/header.asp"-->
    <style>
        h2 {}
        legend {padding:4px;}
        fieldset {margin-top:20px;}

        .msgInfo {margin:20px; padding:5px 5px; background:#0066ff20; text-align:center; border-radius:8px;}
        .msgAlert {margin:20px; padding:5px 5px; background:#ff000020; text-align:center; border-radius:8px;}
        .jumper {cursor:pointer;}
    </style>
    <script>
    $("document").ready(function () {
        $("#smallMenu").find("a").click(function(e) {
            e.preventDefault();
            var section = $(this).attr("name");
            $("html, body").animate({
                scrollTop: $(section).offset().top -60
          }, 1000);
        });
    });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">ברוכים הבאים</div>
    <div style="max-width:500px;margin:0 auto;">
        <div class="msgAlert">
            חברים יקרים,
            <br/><b>אנא קראו דף זה לפני שאתם מתחברים בפעם הראשונה למילון</b>
        </div>
        <fieldset>
            <legend>תפריט</legend>
            <ol id="smallMenu">
                <li><a name="#login" href="">התחברות לאתר</a></li>
                <li><a name="#lists" href="">רשימות אישיות</a></li>
                <li><a name="#new" href="">הוספת מילה</a></li>
                <li><a name="#edit" href="">עריכת מילה</a></li>
                <li><a name="#links" href="">קישורים</a></li>
            </ol>
        </fieldset>

        <h2 id="login">התחברות לאתר</h2>        
        <fieldset>
            <ul>
                <li>מכל מקום באתר, לחצו על האייקון הכתום בסרגל התחתון <img style="max-width:20px;" src="assets/images/team/teamLogo.png" alt="t"/></li>
                <li>הזינו את שם המשתמש והסיסמא שלכם ולחצו 'יאללה'</li>
            </ul>
            <div class="msgInfo">
                עכשיו כשאתם מחוברים, אתם יכולים להשפיע על תוכן האתר
            </div>
        </fieldset>

        <h2 id="lists">רשימות אישיות</h2>
        <fieldset>
            <div class="msgInfo">כל משתמש יכול ליצור לעצמו רשימות, ולאסוף לתוכן מילים.</div>
            <div class="msgAlert">בשלב זה, רק יוצר הרשימה יכול להוסיף לתוכה מילים. כמו כן, כל הרשימות פומביות וכל מי שגולש לאתר המילון יכול לצפות בהן.</div>
            <h3>יצירת רשימה חדשה</h3>
            <ul>
                <li>גלשו לדף הרשימות הראשי.</li>
                <li>בחלון 'הרשימות שלי' בחרו באופציה 'רשימה חדשה'.</li>
            </ul>
            <h3>הוספה והסרה של מילים מרשימה</h3>
            <ul>
                <li>גלשו לדף המילה הרלוונטית.</li>
                <li>בתחתית הדף, לחצו על 'רשימות'.</li>
                <li>לחצו על 'הסר' על מנת להסיר מילה מרשימה מסוימת.</li>
                <li>לחצו על 'הוסף לרשימה שלך' על מנת להוסיף מילה לרשימה מסוימת.</li>
            </ul>
        </fieldset>

        <h2 id="new">הוספת מילה</h2>
        <fieldset>
            <div class="msgInfo">כל משתמש יכול להוסיף מילים. אל תחששו :)</div>
            <div class="msgAlert">בפעם הראשונה, קראו גם את '<a href="guideTeam.asp" target="new">מדריך הוספת ועריכת מילים</a>'</div>
            <div class="msgAlert">לפני שמתחילים, בדקו שהתרגום המבוקש אינו מופיע כבר במילון</div>
            <ul>
                <li>מכל מקום באתר, לחצו על האייקון + בסרגל התחתון <img style="max-width:20px;" src="assets/images/site/add-square.png" alt="+"/></li>
                <li>מלאו את הטופס בהתאם להוראות המדריך</li>
                <li>לסיום לחצו 'הוסף מילה'</li>
            </ul>
        </fieldset>

        <h2 id="edit">עריכת מילה</h2>
        <fieldset>
            <div class="msgInfo">כל משתמש יכול לערוך את המילים שהוא עצמו הוסיף</div>
            <div class="msgAlert">על מנת לערוך ולאשר מילים שאחרים הוסיפו, יש לקבל הרשאת עורך</div>
            <ul>
                <li>גלשו לדף המילה הרלוונטית</li>
                <li>בתחתית הדף - לחצו על 'עריכה'</li>
                <li>ערכו את התוכן הרלוונטי</li>
                <li>לסיום לחצו 'עדכן מילה'</li>
            </ul>
        </fieldset>


        <h2 id="links">קישורים</h2>
        <fieldset>
            <ul>
                <li><a target="profile" href="profile.asp?id=<%=session("userID")%>">דף הפרופיל שלך במילון</a> <span style="font-size:small;">(אחרי התחברות)</span></li>
                <li><a target="fbGroup" href="https://www.facebook.com/groups/arabic4hebsTeam/">קבוצת פייסבוק למתנדבי המילון</a></li>
                <li><a target="fbPage" href="https://www.facebook.com/spoken.arabic.dictionary">דף הפייסבוק של המילון</a></li>
                <li><a target="new" href="guide.asp">מדריך תעתיק והגייה</a></li>
                <li><a target="new" href="guideTeam.asp">מדריך הוספה ועריכה</a></li>
                <li><span style="color:#bbb;">טבלת 'משימות פתוחות'</span> <span style="font-size:small;"> (בשיפוצים. קישור יוחזר בהמשך)</span></li>
            </ul>
        </fieldset>

        <h2>לסיום...</h2>
        <fieldset>
            <div class="msgInfo">תוסיפו ותערכו את המילון בכיף שלכם. בלי לחץ. רק מתי שבא לכם ויש לכם זמן לזה...</div>
            <div class="msgInfo">אם אתם נתקלים בקשיים - תגידו לנו בבקשה כד שנוכל לשפר את הממשק ולהקל עליכם</div>
            <div class="msgInfo">בכל שאלה, בקשה, הערה, מחשבה - כתבו לנו בקבוצת המתנדבים בפייסבוק (אפשר גם במייל).</div>
        </fieldset>
        
        <div style="margin-top:60px; text-align:center;">
            <h1 style="font-size:1.5em;">ברוכים הבאים לקהילת משתמשי המילון!</h1>
            :)
        </div>
    </div>
</div>
<br />
<!--#include file="inc/trailer.asp"-->