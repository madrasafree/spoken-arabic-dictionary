<%-- DB connection; required by inc/trailer.asp for the logged-in user avatar query --%>
<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <title>אודות המילון</title>
    <meta name="description" content="כמה מילים אודות המילון ואיך הוא עובד" />
    <%-- Global CSS/JS, Google Analytics, jQuery --%>
    <!--#include file="inc/header.asp"-->
    <style>

        /* ── Layout ─────────────────────────────────────────────── */

        /* Centred info card shared by all sections on this page */
        .card {
            margin: 0 auto 10px;
            width: min(90%, 500px);
            padding: 8px;
            text-align: center;
        }

        /* RTL variant — history / contributors section (Hebrew reads right-to-left) */
        .card--rtl { text-align: right; }

        /* ── Typography within cards ─────────────────────────────── */

        .card p {
            line-height: 1.4;
            margin: 0.5em 0;
        }

        /* Fine-print: licence details, contributor credits */
        .card small { display: block; }

        /* ── Specific components ─────────────────────────────────── */

        /* Indented credits list inside the history card */
        .contributors {
            padding-right: 15px;
            margin-top: 10px;
        }

        /* "Correct" verification checkmark icon shown inline with text */
        .word-check-icon {
            width: 15px;
            opacity: 0.4;
            vertical-align: middle;
        }

        /* Explicit underline for the Rothfarb external link
           (global CSS may strip default link underlines) */
        .underlink { text-decoration: underline; }

        /* ── Copyright section ───────────────────────────────────── */

        #copyrights { margin-top: 80px; }

        /* Category label inside each copyright list item */
        #copyrights + div strong { text-decoration: underline; }

        #copyrights + div li { margin-bottom: 4px; }

    </style>
</head>
<body>
<%-- Navigation bar, search box, session handling (opens the page container div) --%>
<!--#include file="inc/top.asp"-->

<h1 class="pTitle">אודות</h1>

<!-- ── Section: What the dictionary is ── -->
<section class="card">
    <p><strong>מילון ערבית מדוברת</strong></p>
    <p>הוא שירות חינמי שנועד לעזור לדוברי עברית אשר מעוניינים לדבר ערבית</p>
</section>

<!-- ── Section: History & contributors ── -->
<section class="card card--rtl">
    <p>
        פרויקט 'מילון ערבית מדוברת' נוסד בשנת <time datetime="2005">2005</time> על ידי רונן רוטפרב
        ונוהל על ידו עד שעבר לידי עמותת 'מדרסה' בשנת <time datetime="2022">2022</time>.
    </p>
    <p>לפורטל ערבית מדוברת של רונן <a href="https://rothfarb.info/ronen/arabic/" class="underlink" target="_blank">לחצו כאן</a></p>
    <p>תודה רבה לאנשים שתרמו, תמכו וסייעו לרונן בפרויקט בין השנים <time datetime="2005">2005</time> – <time datetime="2022">2022</time>, ביניהם:</p>

    <div class="contributors">
        <p>
            אדם גנשאפט, אהרון ורדי, אחלאס נסאר, איציק קסאפו, אלון רוטפרב, אלעד בכר, אמיליה רוטפרב,
            אסיל ג'ורן, אסיל מחאג'נה, ארוא מסלחה, ג'וליה הזימה, גילעד סוויט, גנאדי, דוד מור, דור ויטלין,
            דין מוריאל, דנה ענבר-איתמר, דניאל ורנובסקי, האמבטיה ללימודי שפות, הדר רובינזון, הילה רוזנפלד,
            יהושע רוטפרב, ליאת קוזניץ, מוחמד נופאל, מוחמד עוידאת, מיקה סמטנסקי, מריה מיגל דה-פינה,
            מרים ג'ייקובס, נג'אח אטרש, נועם רוזנטל, ניצן קרימסקי, סעיד כבהא, ספאא בדרנה, פרויקט 'ערביט',
            קנאן קאסם, רועי נחמיאס, רים פיומי, שחר לוי, שרון קומש, שרית טמורה.
        </p>
        <p>תודה מיוחדת ל: יניב גרשון, איתי כץ ויעל ניצן.</p>
    </div>
</section>

<!-- ── Section: Who adds words ── -->
<section class="card">
    <h3>מי מוסיף את המילים?</h3>
    <p><strong>אתם!</strong></p>
    <p>המילון שלנו מבוסס תוכן קהילתי (כמו ויקיפדיה), כך שהמשתמשים עצמם מוסיפים את המילים למילון</p>
</section>

<!-- ── Section: Word review process ── -->
<section class="card">
    <h3>מי בודק את המילים שהוסיפו?</h3>
    <p>את המילים בודקים משתמשים ותיקים, עם ידע רחב גם בעברית וגם בערבית מדוברת.</p>
    <p>חפשו את הסימן <img src="img/site/correct.png" title="correct" class="word-check-icon" /> לצד המילים שעברו את בדיקתם.</p>
    <%-- TODO: stat hardcoded to Jan 2020 — consider pulling live percentage from DB --%>
    <p>נכון ל-<time datetime="2020-01-01">1 בינואר 2020</time>, 96% מהמילים נבדקו ונמצאו תקינות</p>
</section>

<!-- ── Section: Future plans ── -->
<section class="card">
    <h3>מה אנחנו מתכננים לעתיד?</h3>
    <p>
        יש לנו רשימה כל-כך ארוכה של משימות ורעיונות, שזה יהיה מטורף להציג אותה כאן.
        אז הכנו לכם <b><a href="team.tasks.asp">דף משימות</a></b> יעודי שבו תוכלו לצפות
        בכל מה שכרגע בטיפול, מתוכנן להמשך, מתוכנן לעתיד הרחוק ועד לרעיונות הכי פרועים שקיבלנו.
    </p>
    <p>* משתמשים רשומים יכולים להצביע ולהשפיע על אילו משימות נטפל קודם</p>
    <p>בנוסף, אנחנו מנסים דברים חדשים באופן שוטף</p>
</section>

<!-- ── Section: Usage statistics ── -->
<section class="card">
    <h3>כמה אנשים משתמשים במילון?</h3>
    <%-- TODO: stat hardcoded to 2021 — update annually or pull from analytics DB --%>
    <p>ב-<time datetime="2021">2021</time> נעשו 996,000 כניסות לאתר ומעל 4,800,000 צפיות בדפים השונים</p>
    <p>לעוד מספרים מעניינים, הכנסו לדף <b><a href="stats.asp" data-gtm="goToStats">הסטטיסטיקה</a></b> היעודי</p>
</section>

<!-- ── Section: Copyright ── -->
<h2 class="pTitle" id="copyrights">זכויות יוצרים</h2>
<section class="card">
    <address>
        לדיווח על חשד בפגיעה בזכויות יוצרים או קניין רוחני באתר,
        אנא כתבו לנו למייל וציינו את מהות הפגיעה בצירוף קישור לדף הרלוונטי.
        <br><a href="mailto:admin@madrasafree.com">admin@madrasafree.com</a>
    </address>
    <ul class="card--rtl">
        <li>טקסט
            <ul>
                <li><strong>מילים</strong>
                    <small>למיטב ידיעתנו, מילה בפני עצמה היא נחלת הכלל</small>
                </li>
                <li><strong>טקסט נלווה <small>(משפטים לדוגמא, הערות וכן הלאה...)</small></strong>
                    <small>
                        המשתמשים אשר מוסיפים תוכן טקסטואלי למילון מתבקשים להעלות טקסט מקורי שלהם,
                        ובשום פנים שלא להעתיק טקסט ממקור אחר אשר מוגן בזכויות יוצרים.
                        <br>אם לא צוין אחרת, הזכויות שמורות למילון ולכותב הטקסט ואין לעשות בו שימוש ללא אישור פרטני בכתב.
                    </small>
                </li>
            </ul>
        </li>
        <li>תמונות
            <ul>
                <li><strong>רונן רוטפרב</strong>
                    <small>בחלק מהערכים מופיעות תמונות שצילם רונן רוטפרב. כל הזכויות שמורות ואין לעשות בהן שימוש ללא אישורו.</small>
                </li>
                <li><strong>ויקימדיה</strong>
                    <small>בחלק מהערכים מופיעות תמונות מתוך אתר ויקימדיה. כל התמונות חופשיות לשימוש, כל אחת בהתאם לרישיון שלה אשר מצוין בקרדיט של התמונה.</small>
                </li>
                <li><strong>אחרים</strong>
                    <small>במקרים בהם מופיעות תמונות מאתרים אחרים, סוג הרישיון יופיע עם הקרדיט לצד התמונה.</small>
                </li>
            </ul>
        </li>
        <li>וידאו
            <ul>
                <li><strong>arabic4hebs</strong>
                    <small>סרטונים של arabic4hebs מופיעים ברחבי המילון. הרישיון הוא בהתאם למופיע בתיאור הסרטון ביו-טיוב. אם לא צוין אחרת, כל הזכויות שמורות לרונן רוטפרב ואין לעשות שימוש בסרטונים ללא אישורו.</small>
                </li>
                <li><strong>אחרים</strong>
                    <small>במידה ומוצגים סרטונים של יוצרים אחרים, מידע לגבי זכויות יופיע לצד הסרטון</small>
                </li>
            </ul>
        </li>
        <li>אודיו
            <ul>
                <li><strong>מילון ערבית מדוברת</strong>
                    <small>במילון מוטמעים קטעי אודיו שהוקלטו על ידי מתנדבים במסגרת הפרויקט. אין לעשות שימוש בקטעים אלה ללא אישור פרטני ממדרסה או מהמתנדב שהקליט את הקטע.</small>
                </li>
                <li><strong><a href="https://www.facebook.com/ערביט-247705252430009">ערביט</a></strong>
                    <small>במילון מוטמעים קטעי אודיו ששייכים לפרויקט 'ערביט'. קטעים אלה הוטמעו באישורם. כל הזכויות שמורות ל'ערביט'.</small>
                </li>
                <li><strong><a href="https://www.facebook.com/Kilme.A.Word.A.Day">כלמה/מילה אחת ביום</a></strong>
                    <small>במילון מוטמעים קטעי אודיו ששייכים לפרויקט 'כלמה/מילה אחת ביום'. קטעים אלה הוטמעו באישורם. כל הזכויות שמורות ל'כלמה/מילה אחת ביום'.</small>
                </li>
            </ul>
        </li>
    </ul>
</section>

<%-- Footer, avatar for logged-in users, closes the page container div --%>
<!--#include file="inc/trailer.asp"-->
