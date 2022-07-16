<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>מדריך שימוש במילון - מדריך הוספה ועריכת מילים</title>
	<meta id="Description" content="כמה מילים אודות המילון ואיך הוא עובד" />
<!--#include file="inc/header.asp"-->
    <style>
        .big {font-size:1.4em;}
        .space {margin-bottom:50px;}
        .space a:hover {text-decoration: underline;}
        label {display:block; font-size:small; color:gray;}
        .tableInfo {display:table; width:100%;border-collapse: collapse;}
        .tableInfo td {text-align:center; vertical-align:middle; border:1px solid gray; padding: 0 4px;}
        .tableInfo td:nth-child(1) {color:#2ead31; font-size:3em;}
        .tableInfo td:nth-child(2) {color:#1988cc; font-size:2.2em;}
        .tableInfo td:nth-child(3) {color:#d17111; font-size:1.8em;}
        ol {counter-reset: item;}
        ol > li {counter-increment: item;}
        ol ol > li {display: block; margin-bottom:6px; line-height: 1.2em;}
        ol ol > li:before {content: counters(item, ".") ". "; margin-right: -31px; }
    </style>
</head><%
function isAndroid ()
    if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
        isAndroid = true
    else
        isAndroid = false
    end if
end function

function showShada (word)
    if isAndroid then
        showShada=Replace(word,chrw(&H0651),chrw(&hFB1E))
    else
        showShada=word
    end if
end function %>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">מדריך שימוש במילון</div>

<div class="table">
    <p style="text-align: justify;">לפני שאתם ממשיכים בקריאת מדריך זה, עיברו קודם על:
        <ul><li><a href="guide.asp">המדריך הבסיסי למשתמש במילון</a>.</li></ul>
    </p>
    <h2 style="margin-top:40px;">מדריך הוספה ועריכת מילים</h2>
    <div style="border:1px dotted gray; padding:10px 0;">
        <ol>
            <li><a href="#1">פירושי המילים</a></li>
            <li><a href="#2">התעתיק העברי</a></li>
            <li><a href="#3">הכתב הערבי</a></li>
            <li><a href="#4">התעתיק הלועזי - הגייה</a></li>
            <li><a href="#5">תמונות</a></li>
            <li><a href="#6">דוגמאות</a></li>
            <li><a href="#7">הערות</a></li>
            <li><a href="#8">קטגוריות / נושאים</a></li>
            <li><a href="#9">מידע דקדוקי</a></li>
            <li><a href="#10">זכויות יוצרים</a></li>
        </ol>
    </div>
<ol>    
    <div class="space" id="1"/></div>
    <li><h3>פירושי המילים</h3>
        <p>פירוש המילה בעברית יכול להיות כמה מילים אבל שמייצגים את אותו המונח - לדוגמא - <span class="arb">תמאם</span> - <span class="heb">בסדר, טוב</span>.</p>
        <p>אם מדובר במונחים נפרדים מבחינת המשמעות יש לפתוח ערך נפרד. לדוגמא - ערך 1- <span class="arb">חבה</span> - <span class="heb">דג</span>ן, ערך 2 - <span class="arb">חבה</span> - <span class="heb">כדור (תרופה)</span>.</p>
    </li>
    
    <div class="space" id="2"></div>
    <li><h3>התעתיק העברי</h3>
        <ol>
            <li><a href="guide.asp">טבלת כללי התעתיק</a> נמצאת במדריך הבסיסי למשתמש במילון.</li>
            <li>התעתיק העברי הוא העתק של הכתיב הערבי וברוב המקרים הוא יהיה זהה אחד לאחד לכתיב הערבי.</li>
            <li>אותיות שיש להם יותר מדרך הגייה אחת - יכתבו תמיד באופן הבא (לפי האות המתאימה לכתיב בכתב הערבי ולא לפי ההגייה)
                <ul>
                    <li><span class="arb big">ث</span> תמיד תיכתב ת' - <span class="arb">תַ'לַאתֵ'ה</span></li>
                    <li><span class="arb big">ذ</span> תמיד תיכתב ד' - <span class="arb">דַ'הַב</span></li>
                    <li><span class="arb big">ظ</span> תמיד תיכתב ט' - <span class="arb">טֻ'הֻר</span></li>
                    <li><span class="arb big">ق</span> תמיד תיכתב ק - <span class="arb">קַהְוֵה</span></li>
                </ul>
            </li>
            <li>הדגשה/הכפלת המילה מיושמת על ידי הוספת סימן השדה מעל האות. דוגמא - <span class="arb"><%=showShada("בִּדִّי")%></span></li>
            <li>אל הידיעה - שימוש בסוגריים במידת הצורך. דוגמאות - 
            <ul>
                <li><span class="arb">אֵלְבֵּית</span></li>
                <li><span class="arb">אֵ(ל)שַמֵס</span></li>
                <li><span class="arb"><%=showShada("פי (א)לְבֵּّית")%></span></li>
                <li><span class="arb"><%=showShada("פי (אל)שַّמֵס")%></span></li>
                <li><span class="arb">גַ'נְבּ (א)לְ-בֵּית</span></li>
            </ul>
            </li>
        </ol>
    </li>

    <div class="space" id="3"></div>
    <li><h3>הכתב הערבי</h3>
        <ol>
            <li>הכתיב הערבי של מילים במילון מייצג את הכתיב המקובל של המילים בכתיבה של ערבית מדוברת. לרוב הכתיב קרוב לכתיב המקובל גם בערבית הספרותית, אבל לא בכל המקרים.</li>
            <li>אותיות שיש להם יותר מדרך הגייה אחת - ייכתבו בכתב הערבי לפי האות השורשית הערבית המקורית, בתעתיק הלועזי תיכתב ההגייה (בלהג העירוני):
                <ul>
                    <li><span class="arb big">ث -  ثلاثة </span>נהגה <span class="eng">ta-laa-te</span>, <span class="arb big">حديث </span>נהגה <span class="eng">h'a-diis</span></li>
                    <li><span class="arb big">ذ - ذهب</span> נהגה <span class="eng">da-hab</span>, <span class="arb big">تلميذ</span> נהגה <span class="eng">til-miiz</span></li>
                    <li><span class="arb big">ظ - ظهر</span> נהגה <span class="eng">d'u-hur</span>, <span class="arb big">حافظ</span> נהגה <span class="eng">'h'aa-faz</span></li>
                </ul>
            </li>
        </ol>
    </li>

    <div class="space" id="4"></div>
    <li><h3>התעתיק הלועזי</h3>
        <p>התעתיק הלועזי הוא הגייתי, הוא מייצג את ההגייה של המילים.</p>
        <ol>
            <li>מקפים בין הברות <span class="eng">mu-han-des</span></li>
            <li>אל הידיעה מיוצגת לפי ההגיה שלה <span class="eng">es-sa-laam</span></li>
            <li>תנועות ארוכות - 
                <ul>
                    תנועות ארוכות ייוצגו בשתי אותיות בצורה הבאה:
                    <li>תנועה ארוכה a - תהיה aa -  דוגמא <span class="eng">sa-laam</span></li>
                    <li>תנועה ארוכה i - תהיה ii -  דוגמא <span class="eng">sa-liim</span></li>
                    <li>תנועה ארוכה u - תהיה uu -  דוגמא <span class="eng">'mab-suut</span></li>
                    <li>תנועה ארוכה e - תהיה ei - דוגמא <span class="eng">beit</span></li>
                    <li>תנועה ארוכה o - תהיה ou -  דוגמא - <span class="eng">youm</span></li>
                    <li>תנועה ארוכה שאינה מוטעמת תתקצר בתעתיק הלועזי בלבד לתנועה קצרה (כי היא לא נהגית כארוכה) - דוגמא <span class="arb">מַגַ'אנִין</span> <span class="eng">ma-ja-niin</span></li>
                </ul>
            </li>
        </ol>
    </li>

    <div class="space" id="5"></div>
    <li><h3>תמונות</h3>
        <ol>
            <li>ניתן להוסיף תמונה לכל ערך במילון - כמובן אם רלוונטי לייצג אותה בצורה ויזואלית.</li>
            <li>התמונות חייבות להיות  Common Creative!  ניתן ואף רצוי לקחת תמונות מהאתר הזה https://commons.wikimedia.org/wiki</li>
            <li>יש לציין קרדיט לבעל התמונה</li>
            <li>יש לקחת תמונה עם רזולוציה בינונית (מעל 250-250, מתחת ל-800-800)</li>
        </ol>
    </li>

    <div class="space" id="6"></div>
    <li><h3>דוגמאות</h3>
        <ol>
            <li>ניתן להוסיף משפט שמכיל את המילה שהוספתם, כדי להדגים איך היא משתלבת בתוך משפט.</li>
            <li>אין לקחת משפטים שלמים ממילונים אחרים.</li>
        </ol>
    </li>

    <div class="space" id="7"></div>
    <li><h3>הערות</h3>
        <ol>
            <li>ניתן לכתוב הערות בצורה חופשית. לדוגמא - מקור המילה, תשובה למילה, הערה לגבי הגיית המילה, הערה לגבי כתיבת המילה, הערה לגבי מתי משתמשים במילה ועוד.</li>
        </ol>
    </li>

    <div class="space" id="8"></div>
    <li><h3>נושאים / קטגוריות</h3>
        <ol>
            <li>ניתן לתייג את המילה בקטגוריה או נושא מתוך רשימה מוכנה. ניתן להוסיף למילה אחת יותר מקטגוריה אחת.</li>
            <li>יש להקפיד לשמור על רלוונטיות של הנושאים למילים.</li>
        </ol>
    </li>

    <div class="space" id="9"></div>
    <li><h3>מידע דקדוקי</h3>
        <ol>
            <li>יש אפשרות לציין מהו חלק הדיבר - פועל, שם עצם, שם תואר, תואר הפועל, מילת יחס ועוד.</li>
            <li>במקרים הרלוונטיים ניתן לציין גם זכר/נקבה ויחיד/רבים.</li>
            <li>במקרה ואתם בוחרים לא לסמן או לא יודעים השאירו "לא ידוע/לא רלוונטי".</li>
        </ol>
    </li>

    <div class="space" id="10"></div>
    <li><h3>זכויות יוצרים</h3>
        <ol>
            <li>אם אתם נעזרים במילונים או מקורות מידע כלשהם ע"מ לוודא את נכונות המילים, שימו לב שאתם לא פוגעים בזכויות היוצרים של אותו מקור מידע. אמנם אין זכויות יוצרים על השפה עצמה, אך יש לעתים הסברים לצד הערכים, למשל, ועליהם יש זכויות יוצרים.</li>
        </ol>
    </li>

</ol>
</div>
<!--#include file="inc/trailer.asp"-->