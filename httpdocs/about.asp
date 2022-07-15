<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
	<title>אודות המילון</title>
	<meta name="Description" content="כמה מילים אודות המילון ואיך הוא עובד" />
<!--#include file="inc/header.asp"-->
    <style>

        #copyrights+div label {
            text-decoration:underline;
            }
        #copyrights+div li {
            margin-bottom:4px;
            }
        .divStats {
            text-align:center;
        }
        #people {
            list-style:none;
            padding:0;
            text-align:center;
        }

        #people li {
            display: inline-block;
            border: 1px solid gray;
            padding: 2px 7px;
            margin: 2px auto;
            border-radius: 5px;
        }
        .table {
            margin-bottom:10px;
            width: min(90%,500px);
            padding: 8px;
        }

    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<h1 class="pTitle">אודות</h1>

<div class="table divStats">
    <b>מילון ערבית מדוברת</b>
    <br>הוא שירות חינמי
    <br>שנועד לעזור לדוברי עברית
    <br>אשר מעוניינים לדבר ערבית
</div>
<div class="table divStats">
    <h3>מי מוסיף את המילים?</h3>
    <div style="font-weight:bold;">אתם!</div>
    <div style="font-size:small; line-height:1.4em;">המילון שלנו מבוסס תוכן קהילתי (כמו ויקיפדיה),
        <br>כך שהמשתמשים עצמם מוסיפים את המילים למילון
    </div>
</div>

<div class="table divStats">
    <h3>מי בודק את המילים שהוסיפו?</h3>
    <div style="font-size:small; line-height:1.4em;">
        את המילים בודקים משתמשים ותיקים, עם ידע רחב גם בעברית וגם בערבית מדוברת.
        <br>חפשו את הסימן <img src="img/site/correct.png" title="correct" style="width: 15px; opacity: 0.4;" /> לצד המילים שעברו את בדיקתם.
        <br>
        <br>נכון ל-1 בינואר 2020
        <br>96% מהמילים נבדקו ונמצאו תקינות
    </div>
</div>


<div class="table divStats">
    <h3>מה אנחנו מתכננים לעתיד?</h3>
    <div style="font-size:small; line-height:1.4em;">
        יש לנו רשימה כל-כך ארוכה של משימות ורעיונות, שזה יהיה מטורף להציג אותה כאן. אז הכנו לכם <b><a href="team.tasks.asp">דף משימות</a></b> יעודי שבו תוכלו לצפות בכל מה שכרגע בטיפול, מתוכנן להמשך, מתוכנן לעתיד הרחוק ועד לרעיונות הכי פרועים שקיבלנו.
        <br>
        <br>* משתמשים רשומים יכולים להצביע ולהשפיע על אילו משימות נטפל קודם
        <br>
        <br>בנוסף, יש לנו <b><a href="test.asp">ארגז חול</a></b> שבו אנחנו מנסים דברים חדשים
    </div>
</div>

<div class="table divStats">
    <h3>כמה אנשים משתמשים במילון?</h3>
    <div style="font-size:small; line-height:1.4em;">
        ב-2021 נעשו 996,000 כניסות לאתר ומעל 4,800,000 צפיות בדפים השונים
        <br>
        <br>לעוד מספרים מעניינים, הכנסו לדף <b><a href="stats.asp" data-gtm="goToStats">הסטטיסטיקה</a></b> היעודי
    </div>
</div>

<div class="table divStats">
    <h3>מי, מתי ולמה...?</h3>
    <div style="font-size:small; line-height:1.4em; text-align:justify;">
        <h4>מי עומד מאחורי המילון?</h4>
        אהלן חברים, קוראים לי רונן רוטפרב.
        אני מנהל את פרויקט המילון מאז הקמתו ב-2005.
        בעשור האחרון את רוב הקוד באתר אני עושה בעצמי
        (עם עזרתם האדיבה של מתנדבים ותיקים וחדשים)

        <h4>מתי זה התחיל?</h4>
        בשנת 2005 למדתי ערבית מדוברת באוניברסיטה הפתוחה.
        את המילים החדשות שלמדנו כתבתי כמו כולם במחברת.
        המחברת התמלאה במהרה, וככל שהתמלאה יותר
        כך היה לי קשה יותר למצוא בה את מה שאני מחפש.
        <br><br>
        חובב טבלאות שכמותי, הקלדתי את המילים לתוך טבלת אקסל.
        חובב גם בניית אתרים, החלטתי להנגיש את הטבלה עם חבריי לכיתה
        באמצעות אתר אינטרנט מינימליסטי, בסיוע מאחי, אלון רוטפרב.
        <br><br>
        הסתיים לו קורס המתחילים ואני המשכתי בחיי (לצערי, ללא הערבית)
        האתר, הוא נשאר לו שם בחלל האינטרנטי ללא שימוש.
        או כך לפחות חשבתי...

        <h4>למה זה המשיך?</h4>
        התחלתי לקבל מכתבים מתלמידים ומורים לערבית ברחבי הארץ.
        כולם פירגנו מאוד על המילון וחלקם הציעו לעזור ולהוסיף מילים.
        הבנתי שהמילון ממלא חלל בקרב לומדי הערבית בישראל,
        ובזכות אותן פניות החלטתי לחזור ולהשקיע במילון
        <br><br>
        הידיעה שהמילון מסייע לעשרות אלפי תלמידים גורמת לי אושר רב.
        מבחינתי הפרויקט הזה הוא השליחות הקטנה שלי.
        שליחות שמאפשרת לי לעשות משהו טוב בעולם הזה.
    </div>
</div>

<h2 class="pTitle" id="thanks" style="margin-top:80px;">תודות</h2>
<div class="table divStats" style="text-align:right;">
    <ul>
        <li>תודה למוסיפי המילים</li>
        <li>תודה לעורכי המילים</li>
        <li>תודה למצולמים</li>
        <li>תודה למפרגנים</li>
        <li>תודה לתורמים</li>
    </ul>
    <br>תודה מיוחדת ל<b>יניב גרשון</b>, שכבר מספר שנים לוקח חלק נכבד בכל מה שקשור לפרויקט המילון, החל מהוספה ועריכת מילים ועד תכנון המערכת והפקת התכנים
    <br>
    <br>מאז 2005 עזרו לי המון אנשים נפלאים לאורך הדרך... 
    תסלחו לי אם שכחתי מישהו ;)
    <ul id="people">
        <li>אדם גנשאפט</li>
        <li>אהרון ורדי</li>
        <li>אחלאס נסאר</li>
        <li>איציק קסאפו</li>
        <li>איתי כץ</li>
        <li>אלון רוטפרב</li>
        <li>אלעד בכר</li>
        <li>אמיליה רוטפרב</li>
        <li>אסיל ג'ורן</li>
        <li>אסיל מחאג'נה</li>
        <li>ארוא מסלחה</li>
        <li>ג'וליה הזימה</li>
        <li>גילעד סוויט</li>
        <li>גנאדי</li>
        <li>דוד מור</li>
        <li>דור ויטלין</li>
        <li>דין מוריאל</li>
        <li>דנה ענבר-איתמר</li>
        <li>דניאל ורנובסקי</li>
        <li><a href="https://ha-ambatia.com">האמבטיה ללימודי שפות</a></li>
        <li>הדר רובינזון</li>
        <li>הילה רוזנפלד</li>
        <li>יהושע רוטפרב</li>
        <li>יניב גרשון</li>
        <li>יעל ניצן</li>
        <li>ליאת קוזניץ</li>
        <li>מוחמד נופאל</li>
        <li>מוחמד עוידאת</li>
        <li>מיקה סמטנסקי</li>
        <li>מריה מיגל דה-פינה</li>
        <li>מרים ג'ייקובס</li>
        <li>נג'אח אטרש</li>
        <li>נועם רוזנטל</li>
        <li>ניצן קרימסקי</li>
        <li>סעיד כבהא</li>
        <li>ספאא בדרנה</li>
        <li><a href="https://www.facebook.com/ערביט-247705252430009">פרויקט 'ערביט'</a></li>
        <li>קנאן קאסם</li>
        <li>רועי נחמיאס</li>
        <li>רים פיומי</li>
        <li>שחר לוי</li>
        <li>שרון קומש</li>
        <li>שרית טמורה</li>
    </ul>
</div>

<h2 class="pTitle" id="copyrights" style="margin-top:80px;">זכויות יוצרים</h2>
<div class="table divStats">
    <div>לדיווח על חשד בפגיעה בזכויות יוצרים או קניין רוחני באתר, 
        אנא כתבו לי למייל וציינו את מהות הפגיעה בצירוף קישור לדף הרלוונטי. 
        <br>arabic4hebs@gmail.com
    </div>
    <ul style="text-align:right;">
        <li>טקסט</li>
        <ul>
            <li><label>מילים</label>
                <div style="font-size:small;">למיטב ידיעתי, מילה בפני עצמה היא נחלת הכלל</div>
            </li>
            <li><label>טקסט נלווה <span style="font-size:small;">(משפטים לדוגמא, הערות וכן הלאה...)</span></label>
                <div style="font-size:small;">
                    המשתמשים אשר מוסיפים תוכן טקסטואלי למילון מתבקשים להעלות טקסט מקורי שלהם, ובשום פנים שלא להעתיק טקסט ממקור אחר אשר מוגן בזכויות יוצרים.
                    <br>אם לא צוין אחרת, הזכויות שמורות למילון ולכותב הטקסט ואין לעשות בו שימוש ללא אישור פרטני בכתב.
                </div>
            </li>
        </ul>
        <li>גופנים</li>
        <ul>
            <li>
                <label>Keter YG</label>
                <div style="font-size:small;">
                    עיצוב: דר. יורם גנת ז"ל
                    <br>בשימוש תחת רישיון <a href="https://en.wikipedia.org/wiki/GPL_font_exception">GPL+FE</a>
                </div>
            </li>
            <li>
                <label>Alef / אָלֶף</label>
                <div style="font-size:small;">
                    עיצוב: מושון זר-אביב, <a href="https://hagilda.com/">הגילדה</a>
                    <br>בשימוש תחת רישיון <a href="https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL">SIL Open Font License</a>
                </div>
            </li>
            <li>
                <label>Harmattan</label>
                <div style="font-size:small;">בשימוש תחת רישיון <a href="https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL">SIL Open Font License</a></div>
            </li>
        </ul>
        <li>תמונות</li>
        <ul>
            <li><label>רונן רוטפרב</label>
                <div style="font-size:small;">בחלק מהערכים מופיעות תמונות שאני צילמתי. כל הזכויות שמורות ואין לעשות בהן שימוש ללא אישור פרטני בכתב.</div>
            </li>
            <li><label>ויקימדיה</label>
                <div style="font-size:small;">בחלק מהערכים מופיעות תמונות מתוך אתר ויקימדיה. כל התמונות חופשיות לשימוש, כל אחת בהתאם לרישיון שלה אשר מצוין בקרדיט של התמונה.</div>
            </li>
            <li><label>אחרים</label>
                <div style="font-size:small;">במקרים בהם מופיעות תמונות מאתרים אחרים, סוג הרישיון יופיע עם הקרדיט לצד התמונה.</div>            
            </li>
        </ul>
        <li>וידאו</li>
        <ul>
            <li><label>מילון ערבית מדוברת</label>
                <div style="font-size:small;">סרטונים של המילון מוטמעים מערוץ היו-טיוב של המילון. הרישיון הוא בהתאם למופיע בתיאור הסרטון ביו-טיוב. אם לא צוין אחרת, כל הזכויות שמורות לרונן רוטפרב ואין לעשות שימוש בסרטונים ללא אישור פרטני בכתב.</div>
            </li>
            <li><label>אחרים</label>
                <div style="font-size:small;">במידה ומוצגים סרטונים של יוצרים אחרים, מידע לגבי זכויות יופיע לצד הסרטון</div>
            </li>
        </ul>
        <li>אודיו</li>
        <ul>
            <li><label>מילון ערבית מדוברת</label>
                <div style="font-size:small;">במילון מוטמעים קטעי אודיו שהוקלטו על ידי מתנדבים במסגרת הפרויקט. אין לעשות שימוש בקטעים אלה ללא אישור פרטני בכתב מרונן רוטפרב או מהמתנדב שהקליט את הקטע.</div>
            </li>
            <li><label><a href="https://www.facebook.com/ערביט-247705252430009">ערביט</a></label>
                <div style="font-size:small;">במילון מוטמעים קטעי אודיו ששייכים לפרויקט 'ערביט'. קטעים אלה הוטמעו באישורם. כל הזכויות שמורות ל'ערביט'.</div>
            </li>
            <li><label><a href="https://www.facebook.com/Kilme.A.Word.A.Day">כלמה/מילה אחת ביום</a></label>
                <div style="font-size:small;">במילון מוטמעים קטעי אודיו ששייכים לפרויקט 'כלמה/מילה אחת ביום'. קטעים אלה הוטמעו באישורם. כל הזכויות שמורות ל'כלמה/מילה אחת ביום'.</div>
            </li>
        </ul>
    </ul>
</div>

<!--#include file="inc/trailer.asp"-->