<div dir="rtl" align="right">

<h1>סטטוס הפרויקט: מה הושלם ומה עוד פתוח</h1>

<p>
מסמך קצר ושיתופי שמסכם את מצב הפרויקט בשני הרפוזיטוריז:
</p>

<ul>
  <li><code>spoken-arabic-dictionary</code></li>
  <li><code>spoken-arabic-dictionary-django</code></li>
</ul>

<blockquote>
  <strong>בקצרה:</strong> גרסת ה-Django כבר רצה על host פרודקשן זמני עם <code>noindex</code>, עבודת ה-legacy סודרה ותועדה, ולפני מעבר ציבורי מלא צריך לסגור scope סופי, להשלים את מה שנכנס לגל הראשון, ולעשות <code>QA</code> ו-<code>cutover</code> מסודרים.
</blockquote>

<h2>קישורים מרכזיים</h2>

<table dir="rtl">
  <thead>
    <tr>
      <th align="right">סוג</th>
      <th align="right">קישור</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="right"><strong>ריפו legacy</strong></td>
      <td align="right"><a href="https://github.com/madrasafree/spoken-arabic-dictionary">github.com/madrasafree/spoken-arabic-dictionary</a></td>
    </tr>
    <tr>
      <td align="right"><strong>ריפו Django</strong></td>
      <td align="right"><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django">github.com/madrasafree/spoken-arabic-dictionary-django</a></td>
    </tr>
    <tr>
      <td align="right"><strong>האתר הראשי</strong></td>
      <td align="right"><a href="https://milon.madrasafree.com/">milon.madrasafree.com</a></td>
    </tr>
    <tr>
      <td align="right"><strong>Staging של Django</strong></td>
      <td align="right"><a href="https://staging-milon.madrasafree.com/">staging-milon.madrasafree.com</a></td>
    </tr>
    <tr>
      <td align="right"><strong>פרודקשן זמני של Django</strong></td>
      <td align="right"><a href="https://prod-milon.madrasafree.com/">prod-milon.madrasafree.com</a></td>
    </tr>
  </tbody>
</table>

<h2>תקציר מנהלים</h2>

<table dir="rtl">
  <thead>
    <tr>
      <th align="right">נושא</th>
      <th align="right">מצב נוכחי</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="right"><strong>פרודקשן זמני</strong></td>
      <td align="right">עלה host זמני של Django עם <code>noindex</code></td>
    </tr>
    <tr>
      <td align="right"><strong>תשתית דיפלוי</strong></td>
      <td align="right">קיימת ופועלת דרך Azure VM ו-GitHub Actions</td>
    </tr>
    <tr>
      <td align="right"><strong>ליבת האתר הציבורי</strong></td>
      <td align="right">קיימת ב-Django: בית, חיפוש, נושאים ודף מילה</td>
    </tr>
    <tr>
      <td align="right"><strong>המעבר הציבורי המלא</strong></td>
      <td align="right">עדיין פתוח להחלטות scope ולבדיקות go-live</td>
    </tr>
    <tr>
      <td align="right"><strong>נושאים פתוחים</strong></td>
      <td align="right"><code>lists</code>, <code>sentences</code>, <code>history</code>, <code>media</code>, <code>guide.asp</code>, <code>bulk</code></td>
    </tr>
  </tbody>
</table>

<h2>מה הושלם ב-<code>spoken-arabic-dictionary</code></h2>

<table dir="rtl">
  <thead>
    <tr>
      <th align="right">מהלך</th>
      <th align="right">מה נעשה</th>
      <th align="right">למה זה חשוב</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="right"><strong>ניקוי וייצוב ה-legacy</strong></td>
      <td align="right">בוצע cleanup משמעותי של קוד, דפים וקבצים שכבר לא תרמו למערכת הפעילה</td>
      <td align="right">נוצר בסיס עבודה ברור ופחות רועש למיגרציה</td>
    </tr>
    <tr>
      <td align="right"><strong>סידור מבנה וקבצי מערכת</strong></td>
      <td align="right">סודר מבנה ה-<code>includes</code> וה-<code>admin</code>, ואוחדו assets תחת מבנה עקבי יותר</td>
      <td align="right">האתר הישן התייצב והתחזוקה והמיפוי נעשו פשוטים יותר</td>
    </tr>
    <tr>
      <td align="right"><strong>מיפוי ותיעוד טכני</strong></td>
      <td align="right">נכתב inventory טכני ונכתב תיעוד למסכים, includes, handlers, מסדי נתונים ו-assets</td>
      <td align="right">אפשר להבין את המערכת הישנה ולעבוד מולה בלי ניחושים</td>
    </tr>
    <tr>
      <td align="right"><strong>מיפוי מעבר ל-Django</strong></td>
      <td align="right">נבנה מיפוי <code>MVP</code> בין המסכים הישנים לבין המערכת החדשה</td>
      <td align="right">הוגדר מה חייב לעבור, מה אפשר לאחד ומה לא צריך לשחזר אחד-לאחד</td>
    </tr>
    <tr>
      <td align="right"><strong>הרצה מקומית של ה-legacy</strong></td>
      <td align="right">נוספה אוטומציית setup מקומי ל-Windows/IIS/Classic ASP</td>
      <td align="right">אפשר להרים את המערכת הישנה ולאמת התנהגות לפי הצורך</td>
    </tr>
    <tr>
      <td align="right"><strong>מסמכי עבודה לצוות</strong></td>
      <td align="right">נכתבו <code>README.md</code> ו-<code>AGENTS.md</code></td>
      <td align="right">הכניסה לעבודה בריפו הישן ברורה יותר גם למי שנכנס מבחוץ</td>
    </tr>
  </tbody>
</table>

<h2>מה הושלם ב-<code>spoken-arabic-dictionary-django</code></h2>

<table dir="rtl">
  <thead>
    <tr>
      <th align="right">מהלך</th>
      <th align="right">מה נעשה</th>
      <th align="right">למה זה חשוב</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="right"><strong>הקמת המערכת החדשה</strong></td>
      <td align="right">הוקם בסיס Django חדש והוגדר מודל דאטה עם migrations</td>
      <td align="right">נבנתה תשתית מודרנית ויציבה במקום שכבת ה-ASP</td>
    </tr>
    <tr>
      <td align="right"><strong>תאימות לנתוני legacy</strong></td>
      <td align="right">נשמרה תמיכה ב-<code>legacy_id</code></td>
      <td align="right">נשמרים קישורים קיימים ומתאפשרת מיגרציה עקבית</td>
    </tr>
    <tr>
      <td align="right"><strong>סביבת פיתוח אחידה</strong></td>
      <td align="right">הוקמה סביבת עבודה עם Docker + PostgreSQL ונכתב <code>tools/workflow.py</code></td>
      <td align="right">ההרצה, הבדיקות והעבודה השוטפת מרוכזות תחת flow אחד</td>
    </tr>
    <tr>
      <td align="right"><strong>ייבוא ורענון נתונים</strong></td>
      <td align="right">נבנה pipeline לייבוא <code>CSV snapshot</code> ונבנה exporter מ-Access MDB ל-CSV</td>
      <td align="right">אפשר לרענן ולטעון נתוני legacy בלי תהליך ידני ארוך</td>
    </tr>
    <tr>
      <td align="right"><strong>ליבה ציבורית ראשונה</strong></td>
      <td align="right">מומשו דפי הבית, החיפוש, <code>about</code>, רשימת נושאים, דף נושא ודף מילה</td>
      <td align="right">חוויית המילון המרכזית כבר זמינה ב-Django</td>
    </tr>
    <tr>
      <td align="right"><strong>תאימות לכתובות ישנות</strong></td>
      <td align="right">נשמרה תאימות ל-legacy URLs מרכזיים ונוספו redirects למסלולים ישנים</td>
      <td align="right">נמנעת שבירה של כתובות מוכרות ושל זרימות קיימות</td>
    </tr>
    <tr>
      <td align="right"><strong>מסכי צוות ראשונים</strong></td>
      <td align="right">נבנה ממשק צוות להוספה ועריכה של מילים עם הרשאות ושמירת history</td>
      <td align="right">העבודה השוטפת כבר לא תלויה רק ב-admin הגנרי</td>
    </tr>
    <tr>
      <td align="right"><strong>API וניהול בסיסי</strong></td>
      <td align="right">נבנה API לחיפוש ולדף מילה והוגדר Django admin למודלים המרכזיים</td>
      <td align="right">קיימת שכבת גישה נקייה לנתונים וניהול בסיסי יציב</td>
    </tr>
    <tr>
      <td align="right"><strong>מעטפת ציבורית חדשה</strong></td>
      <td align="right">נבנתה מעטפת frontend חדשה ורספונסיבית</td>
      <td align="right">האתר עובר לחוויית שימוש מודרנית יותר</td>
    </tr>
    <tr>
      <td align="right"><strong>שליטה באינדוקס</strong></td>
      <td align="right">נוספה שכבת <code>noindex</code> ו-<code>robots.txt</code> לפי environment</td>
      <td align="right">האתר החדש לא נחשף מוקדם מדי למנועי חיפוש</td>
    </tr>
    <tr>
      <td align="right"><strong>תשתית ענן ו-DevOps</strong></td>
      <td align="right">נבנו תהליכים ל-Azure VM, דיפלוי, גיבוי, שחזור ו-Cloudflare cutover</td>
      <td align="right">ההעלאה לענן הפכה לתהליך מסודר ולא ידני</td>
    </tr>
    <tr>
      <td align="right"><strong>פרודקשן זמני</strong></td>
      <td align="right">הועלתה גרסת Django ל-host פרודקשן זמני</td>
      <td align="right">אפשר לבדוק את המערכת בתנאי ענן אמיתיים לפני מעבר ציבורי מלא</td>
    </tr>
  </tbody>
</table>

<h2>מה עדיין פתוח להחלטה</h2>

<table dir="rtl">
  <thead>
    <tr>
      <th align="right">נושא</th>
      <th align="right">מה צריך להחליט</th>
      <th align="right">למה זה חשוב</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="right"><strong><code>lists</code></strong></td>
      <td align="right">האם נכנס בגל הראשון ובאיזה היקף</td>
      <td align="right">זה אזור תוכן וגילוי משמעותי במערכת הישנה</td>
    </tr>
    <tr>
      <td align="right"><strong><code>sentences</code></strong></td>
      <td align="right">האם נכנס בגל הראשון ומה רמת ה-<code>parity</code> הנדרשת</td>
      <td align="right">משפיע ישירות על עומק חוויית המילון</td>
    </tr>
    <tr>
      <td align="right"><strong><code>history</code></strong></td>
      <td align="right">האם נכנס למסכי צוות, לציבור, או נשאר פנימי ומצומצם</td>
      <td align="right">משפיע על workflow ועל שקיפות שינויים</td>
    </tr>
    <tr>
      <td align="right"><strong><code>media</code></strong></td>
      <td align="right">מה נכנס לגרסה הראשונה ואיך הוא מופיע בדפי מילה, משפטים ורשימות</td>
      <td align="right">משפיע על חוויית תוכן ועל מורכבות המימוש</td>
    </tr>
    <tr>
      <td align="right"><strong><code>guide.asp</code></strong></td>
      <td align="right">האם נכנס, נשאר placeholder זמני, או יוצא מה-scope</td>
      <td align="right">תלוי בחשיבות שלו לגל הראשון</td>
    </tr>
    <tr>
      <td align="right"><strong><code>bulk</code> לתוכן</strong></td>
      <td align="right">האם נכנס לגל הראשון או נשאר לשלב הבא</td>
      <td align="right">יכול לעזור למשימות תוכן מרוכזות, אבל לא בטוח שהוא חסם לעלייה הראשונה</td>
    </tr>
  </tbody>
</table>

<h2>מה צריך לבצע לפני מעבר ציבורי מלא</h2>

<table dir="rtl">
  <thead>
    <tr>
      <th align="right">תחום</th>
      <th align="right">משימה</th>
      <th align="right">מטרה</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="right"><strong>Scope</strong></td>
      <td align="right">להכריע מה נכנס לגל הראשון</td>
      <td align="right">למנוע עבודה מיותרת על דברים שלא עולים עכשיו</td>
    </tr>
    <tr>
      <td align="right"><strong>מימוש</strong></td>
      <td align="right">להשלים רק את <code>lists</code>, <code>sentences</code>, <code>history</code> ו-<code>media</code> שייכנסו ל-scope</td>
      <td align="right">למקד את הפיתוח במה שבאמת צריך לעלות</td>
    </tr>
    <tr>
      <td align="right"><strong>QA</strong></td>
      <td align="right">לבצע בדיקות מלאות על הדפים והזרימות שייכנסו לעלייה הציבורית</td>
      <td align="right">לוודא שהגרסה הציבורית מבוססת על דאטה אמיתי ועל URLs אמיתיים</td>
    </tr>
    <tr>
      <td align="right"><strong>UI cleanup</strong></td>
      <td align="right">לנקות או לתקן רכיבי <code>client-side</code> שכרגע לא יציבים מספיק</td>
      <td align="right">למנוע השארת רכיבים חלשים בגרסת העלייה</td>
    </tr>
    <tr>
      <td align="right"><strong>Analytics</strong></td>
      <td align="right">להוסיף <code>Google Analytics</code></td>
      <td align="right">לאפשר מעקב אחרי שימוש, חיפוש ובעיות אחרי העלייה</td>
    </tr>
    <tr>
      <td align="right"><strong>Go-live checks</strong></td>
      <td align="right">להשלים staging, health checks, assets, redirects ו-<code>robots.txt</code></td>
      <td align="right">לא להגיע ל-cutover עם הפתעות</td>
    </tr>
    <tr>
      <td align="right"><strong>Cutover</strong></td>
      <td align="right">לבצע מעבר מסודר מ-host זמני ל-host הציבורי ולהסיר <code>noindex</code> בזמן הנכון</td>
      <td align="right">להבטיח מעבר חלק ומבוקר</td>
    </tr>
  </tbody>
</table>

<h2>נושא <code>bulk</code></h2>

<p>
כרגע <code>bulk</code> הוא <strong>כיוון המשך רלוונטי</strong>, לא החלטה סופית לעלייה הראשונה.
</p>

<p>
הוא יכול לעזור במיוחד במשימות תוכן מרוכזות, אבל אם מקדמים אותו כדאי לעשות את זה בצורה מסודרת:
</p>

<ul>
  <li><strong>פורמט קלט ברור</strong> לייבוא</li>
  <li><strong><code>preview</code> ו-<code>validation</code></strong> לפני כתיבה</li>
  <li><strong>אישור מפורש</strong> לפני apply</li>
  <li><strong>תיעוד מלא</strong> של ה-flow לצוות</li>
  <li><strong>שחזור / rollback</strong> אם משהו משתבש</li>
</ul>

<p>
המטרה היא שאם <code>bulk</code> ייכנס, הוא יהיה כלי אמין לעבודה ולא מסלול מסוכן שקשה לתחזק.
</p>

<h2>מה לא צריך לשחזר אחד-לאחד</h2>

<ul>
  <li><strong>handlers ישנים של ASP:</strong> לא נכון להחזיר handlers שבירים או לא בטוחים רק בשביל parity מלאכותי.</li>
  <li><strong>admin wrappers ישנים:</strong> אין צורך להחיות שכבת admin ישנה כשכבר קיימת שכבת ניהול חדשה.</li>
  <li><strong><code>activity.asp</code> הישן:</strong> לא חייב לחזור אם אין לו ערך ברור במבנה החדש.</li>
  <li><strong><code>stats.asp</code> הישן:</strong> אם יידרש דף סטטיסטיקות, עדיף לבנות אותו מחדש על דאטה עדכני.</li>
</ul>

<h2>סדר עבודה מומלץ</h2>

<ol>
  <li><strong>להכריע scope</strong>: מה נכנס לגל הראשון ומה נשאר להמשך.</li>
  <li><strong>להשלים מימוש</strong>: רק למה שנכנס ל-scope.</li>
  <li><strong>להריץ QA מלא</strong>: על הדאטה, ה-URLs והזרימות שבאמת עולות.</li>
  <li><strong>להוסיף analytics ולהשלים go-live checks</strong>: לפני המעבר הציבורי.</li>
  <li><strong>לבצע cutover מסודר</strong>: ורק אחריו להסיר <code>noindex</code>.</li>
</ol>

<h2>מקורות עיקריים</h2>

<ul>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary/blob/main/docs/pages.md">legacy pages map</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary/blob/main/docs/handlers.md">legacy handlers</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary/blob/main/docs/db.md">legacy DB notes</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary/blob/main/docs/mvp_feature_map/MVP_FEATURE_MAP.md">legacy MVP feature map</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django/blob/main/docs/legacy_gap_analysis.md">Django legacy gap analysis</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django/blob/main/docs/legacy_snapshot.md">Django legacy snapshot format</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django/blob/main/docs/architecture.md">Django architecture</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django/blob/main/docs/local_cloud_runbook.md">Django local and cloud runbook</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django/blob/main/docs/github_actions.md">Django GitHub Actions runbook</a></li>
  <li><a href="https://github.com/madrasafree/spoken-arabic-dictionary-django/blob/main/docs/azure_vm_operations.md">Django Azure VM operations</a></li>
</ul>

</div>
