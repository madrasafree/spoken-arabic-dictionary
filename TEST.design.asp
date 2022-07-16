<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NONE">
    <meta charset="utf-8">
	<title>ארגז חול - עיצוב</title>
    <meta property="og:site_name" content="מילון ערבית מדוברת"/>
    <meta property="fb:app_id" content="1567725220133768" />
    <meta property="og:locale" content="he_IL" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        .arabic {
            color:#2ead31;
        }
        .arabicEng {
            color:#d17111;
        }
        .arabicHeb {
            color:#2ead31;
        }
        body {
            background-image: url(img/site/diagBlue.png);
            background-repeat: repeat;
            color: gray;
            direction: rtl;
        }
        .em2 {
            font-size:2em;
        }
        .hebrew {
            color:#1988cc;
        }
        label {
            direction:ltr;
            font-size:initial;
        }
        .tbl {
            display:table;
        }
        .tbl > div {
            display:table-row;
        }
        .tbl > div > span {
            display:table-cell;
            padding: 0 10px;
            max-width: 300px;
        }
        .tbl > div > span:nth-child(1) {
            font-size:2em;
        }
    </style>


	<link rel="stylesheet" href="css/test.css" />
</head>
<body>
<header>
<label>תפריט "פירורי לחם"</label>
<nav id="bread">
    <a href=".">מילון</a> / <%
    if session("userID")=1 then %>
    <a href="admin.asp">ניהול</a> / <%
    end if %>
    <a href="test.asp">ארגז חול</a> / 
    <h1>עיצוב</h1>
</nav>
</header>
<main>

<section>
    <ul><u>דפים שונים באתר:</u>
        <li><a href="TEST.team.new.asp">team New</a></li>
        <li><a href="TEST.team.old.asp">team old</a></li>
        <li><a href="TEST.where2learn.asp">where2learn</a></li>
    </ul>
</section>

<section>
    <h2>צבעים</h2>
    <ul>
        <li>
            <h3>תבנית צבע</h3>
        </li>
        <li>
            <h3>טקסט שפה</h3>
            <div class="tbl">
                <div><span>טקסט רגיל</span><span>gray</span></div>
                <div class="hebrew"><span>עברית</span><span>#1988cc</span></div>
                <div class="arabic"><span>عربية</span><span>#2ead31</span></div>
                <div class="arabicHeb"><span>תעתיק עברי</span><span>#2ead31</span></div>
                <div class="arabicEng"><span>English Transcript</span><span>#d17111</span></div>
            </div>
        </li>
    </ul>
</section>
<section>
    <h2>שמות ברורים לקלאסים</h2>
    <div class="tbl">
        <div><span>arabic</span><span>טקסט ערבי בערבית</span></div>
        <div><span>arabicEng</span><span>טקסט ערבי בתעתיק לועזי</span></div>
        <div><span>arabicHeb</span><span>טקסט ערבי בתעתיק עברי</span></div>
        <div><span>hebrew</span><span>טקסט עברי בעברית</span></div>
    </div>
</section>
<section>
<h2>תגים סמנטים - מתי להשתמש ועיצוב קבוע</h2>
<dl dir="ltr">
    <dt>article</dt><dd>a self-contained composition in a [...] site, which is intended to be independently distributable or reusable</dd>
    <dt>aside</dt><dd>מידע נלווה לתוכן הדף</dd>
    <dt>base</dt><dd>specifies the base URL to use for all relative URLs in a document</dd>
    <dt>bdi</dt><dd>Bidirectional Isolate element - מאפשר לשנות כיוון טקסט באמצע - מעולה לשילוב עברית/ערבית עם אנגלית</dd>
    <dt>bdo</dt><dd>Bidirectional Text Override element - לא נשתמש, אבל חשוב להכיר 
        <br><bdi>overrides the current directionality of text, so that the text within is rendered in a different direction</bdi></dd>
    <dt>details</dt><dd>creates a disclosure widget in which information is visible only when the widget is toggled into an "open" state
        <br><mark>לשקול. בשלב זה אין אנימציה</mark></dd>
    <dt>br</dt><dd>Do not use br to create margins between paragraphs; wrap them in p elements and use the CSS margin property to control their size.
        <br><mark>להסיר אלכסון ולהוריד לגמרי היכן שלא משמש כמעבר שורה</mark></dd>        
    <dt>dd</dt><dd>Description Details - provides the description, definition, or value for the preceding term</dd>
    <dt>dl</dt><dd>description list</dd>
    <dt>dt</dt><dd>specifies a term in a description or definition list</dd>
    <dt>dfn</dt><dd>used to indicate the term being defined within the context of a definition phrase or sentence
    <br><mark>לשקול להשתמש לפירושון</mark></dd>
    <dt>em</dt><dd>stress emphasis - הדגשת טון דיבור</dt><dd>This is <em>not</em> a drill!</dd>
    <dt>footer</dt><dd>represents a footer for its nearest sectioning content or sectioning root element. A footer typically contains information about the author of the section, copyright data or links to related documents</dd>
    <dt>header</dt><dd>represents introductory content, typically a group of introductory or navigational aids. It may contain some heading elements but also a logo, a search form, an author name, and other elements</dd>
    <dt>label</dt><dd><mark>לוודא שימוש רק בצמוד לאינפוטים (להשתמש בספאן במקומות אחרים). לוודא שהאינפוט נמצא בתוך התגית ולא לצידה</mark></dd>
    <dt>main</dt><dd>represents the dominant content of the 'body' of a document. The main content area consists of content that is directly related to or expands upon the central topic of a document, or the central functionality of an application</dd>
    <dt>mark</dt><dd>represents text which is marked or highlighted for reference or notation purposes, due to the marked passage's relevance or importance in the enclosing context
    <br><mark>לשקול שימוש למשפטים בדף מילה - לסימון המילה בה אנו צופים</mark></dd>
    <dt>nav</dt><dd>represents a section of a page whose purpose is to provide navigation links, either within the current document or to other documents. Common examples of navigation sections are menus, tables of contents, and indexes.</dd>
    <dt>p</dt><dd>paragraph
        <br><mark><bdi>להחליף היכן שצריך במקום ה-DIVים שיש כרגע</bdi></mark></dd>
    <dt>picture</dt><dd>contains zero or more <source> elements and one <img> element to offer alternative versions of an image for different display/device scenarios
    <br><mark>לשקול להכניס בכל מקום שאנחנו מציגים תמונות</mark></dd>
    <dt>q</dt><dd>quotation <br><mark>רלוונטי אולי לתמלול סרטונים</mark></dd>
    <dt>section</dt><dd>represents a standalone section — which doesn't have a more specific semantic element to represent it — contained within an HTML document</dd>
    <dt>small</dt><dd>represents side-comments and small print, like copyright and legal text, independent of its styled presentation.
        <br><mark><bdi>לשקול להשתמש ב-footer</bdi></mark></dd>
    <dt>strong</dt><dd><mark><bdi>טקסט חשוב - להחליף בכל מקום שיש כרגע b</bdi></mark></dd>
</dl>
</section>



</main>
<footer>
    <h2>אינדקס אתר נסיוני</h2>
    <b>להעביר תחת עיצוב</b>
    <div style="display:flex; flex-wrap: wrap;">
        <ul>
            <li>דף ראשי</li>
            <li>אודות</li>
            <li>סטטיסטיקה</li>
            <li>משימות ורעיונות</li>
            <li>הכנסות</li>
            <li>תרומות</li>
        </ul>
        <ul>
            <li>רשימות נושאים</li>
            <li>רשימות אישיות</li>
            <li>משחק זיכרון - כרטיסים</li>
            <li>משחק זיכרון - תמונות</li>
            <li></li>
            <li></li>
        </ul>
        <ul>
            <li>קישורים</li>
            <li>בתי ספר</li>
            <li>מורים פרטיים</li>
            <li>מפגשי תרגול</li>
            <li></li>
            <li></li>
        </ul>
        <ul>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
        </ul>
    </div>
</footer>
</body>
</html>