<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>פירסום במילון</title>
	<meta name="Description" content="פירסום באתר מילון ערבית מדוברת - מידע ומחירון" />
	<!--#include file="inc/header.asp"-->
	<style>
	h1,p {
		text-align:center;
		padding:6px; 
		border-radius:10px; 
		max-width:400px; 
		margin:0 auto 10px auto;
	}
	h2 {
		margin:20px auto 0 auto;
		text-align:center;
	}
	main {
		width:max(60vw,500px);
		margin:0 auto;
	}
	main ul {
		font-size:small;
		max-width:570px;
		margin:0 auto;
		text-align:right;
		padding:5px;
		list-style:none;
		background:#eeeeee;
	}
	.active {
		color:red;
		float:left;
	}
	.saved {
		color:gray;
		float:left;
	}
	.vacen {
		color:green;
		float:left;
	}
	.payment {
		border:1px solid gray;
		width:min(90vw,600px);
		background:white;
		margin:10px auto;
	}
	.priceTable, .typeTable {
		background:white;
		border-collapse:collapse;
		display:table;
		margin:10px auto;
		width:min(90vw,600px);
	}
	.priceTable a, .payment a {
		color:#1988cc;
	}
	.priceTable a:hover {
		background:yellow;
	}

	.priceTable > div, .typeTable > div {
		display:table-row;
	}
	.priceTable > div > div, .typeTable > div > div {
		border:1px solid gray;
		display:table-cell;
		padding:2px 4px;
		vertical-align:middle;
		height:32px;
	}
	.priceTable > div > div:not(:nth-child(1)) {
		width:80px;
		text-align:center;
	}
	.typeTable > div > div:not(:nth-child(4)) {
		width:80px;
		text-align:center;
	}
	.priceTable .th > div {
		background:#ffd587;
		color:#714c08;
	}
	.typeTable .th > div {
		background:#f887ff;
		color:#5c0871;
	}
	.priceTable span {
		display:block;
		font-size:small;
	}
	.free {
		background:yellow;
		color:black;
	}
	.disabled {
		background:#eeeeee;
	}
	</style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<p style="background:#f8f9cce6; color:#858812; margin-bottom:40px;">דף זה טרם הותאם לצפייה מטלפונים. עמכם הסליחה</p>
<main>
	<h1>פירסום באתר המילון</h1>
	<p style="background:#dddeee55;"><b>פירסום ממוקד לקהילת לומדי הערבית בארץ</b>
		<br>פרסנו את משבצות הפירסום במגוון מיקומים באתר, על מנת לאפשר גם לבתי ספר קטנים ומורים פרטיים לפרסם באתר המילון
	</p>
	<p style="background:#f8f9cce6; color:#858812;">
		<b>תקופת הרצה</b>
		<br>התחלנו במאי 2021. דברים בטח יישתנו לאורך הדרך... נשמח לשמוע מכם כדי לשפר ולאפשר לכם להגיע ליותר לקוחות
	</p>	
	<h2>מחירון <span style="font-size:small;">30 יום</span></h2>

	<div class="priceTable">
		<div class="th">
			<div>מיקום באתר <small>(לחצו למעבר לדף)</small></div>
			<div>חשיפה מוערכת</div>
			<div>טקסט</div>
			<div>תמונה</div>
			<div>סרטון</div>
		</div>
		<div>
			<div><a href="where2learn.schools.asp">רשימת בתי ספר</a></div>
			<div>270</div>
			<div class="free">חינם לכולם</div>
			<div class="free">חינם לכולם
				<span>(לוגו בלבד)</span>
			</div>
			<div>
				<span>קישור קבוע למילון באתר בית הספר</span>
			</div>
		</div>
		<div>
			<div>
				<a href="labels.asp">אינדקס נושאים</a>
				<small class="vacen">פנוי</small>
			</div>
			<div>980</div>
			<div>20 ש"ח</div>
			<div>30 ש"ח</div>
			<div>40 ש"ח
				<span>(עד 2 דקות)</span>
			</div>
		</div>
		<div>
			<div>
				<a href="lists.all.asp">אינדקס רשימות אישיות</a>
				<small class="vacen">פנוי</small>
			</div>
			<div>1,200</div>
			<div>30 ש"ח</div>
			<div>45 ש"ח</div>
			<div>60 ש"ח
				<span>(עד 2 דקות)</span>
			</div>
		</div>
		<div>
			<div>
				<a href="games.mem.asp">דף משחק זיכרון</a>
				<small class="vacen">פנוי</small>
			</div>
			<div>1,480</div>
			<div>50 ש"ח</div>
			<div>80 ש"ח</div>
			<div>100 ש"ח
				<span>(עד 2 דקות)</span>
			</div>
		</div>
		<div>
			<div>
				<a href="label.asp?id=1">רשימת נושא מסוים</a>
				<small class="vacen">פנוי</small>
			</div>
			<div>5,800</div>
			<div>100 ש"ח</div>
			<div>150 ש"ח</div>
			<div>200 ש"ח
				<span>(עד 10 דקות)</span>
			</div>
		</div>
		<div>
			<div>
				<a href="lists.asp?id=13">רשימה אישית</a>
				<small class="vacen">פנוי</small>
			</div>
			<div>6,700</div>
			<div>100 ש"ח</div>
			<div>150 ש"ח</div>
			<div>200 ש"ח
				<span>(עד 10 דקות)</span>
			</div>
		</div>
		<div>
			<div>
				<a href="default.asp">דף נחיתה
				<small class="vacen">פנוי</small>
				<span>דף ראשי לפני ביצוע חיפוש</span>
				</a>
			</div>
			<div>32,000</div>
			<div>200 ש"ח</div>
			<div class="disabled">-</div>
			<div class="disabled">-</div>
		</div>	
		<div>
			<div>
				<a href="word.asp?id=185">דף מילה</a>
				<small class="vacen">פנוי</small>
			</div>
			<div>55,000</div>
			<div>300 ש"ח</div>
			<div>400 ש"ח</div>
			<div>500 ש"ח
				<span>(עד 10 דקות)</span>
			</div>
		</div>
		<div>
			<div><a href="default.asp?searchString=טבע">תוצאות חיפוש
				<small class="vacen">פנוי</small>
				<span>דף ראשי בין תוצאות מדויקות לנוספות</span></a>
			</div>
			<div>213,000</div>
			<div>800 ש"ח</div>
			<div class="disabled">-</div>
			<div class="disabled">-</div>
		</div>	
	</div>

	<ul>
		<li>* מידע צפיות (חשיפה מוערכת) מעוגל למטה על בסיס גוגל אנליטיקס בחודש יולי 2021.</li>
		<li>** המחירים הם ל-30 יום (לדוגמא: מה-28 באוגוסט ועד ה-27 בספטמבר כולל).</li>
		<li>*** המחירון רלוונטי לחודשים אוקטובר - נובמבר 2021.</li>
	</ul>

	<h2>סוגי פירסומים</h2>
	<div class="typeTable">
		<div class="th">
			<div>סוג</div>
			<div>רוחב מקסימלי</div>
			<div>גובה מקסימלי</div>
			<div>הערות / מידע נוסף</div>
		</div>
		<div>
			<div>טקסט</div>
			<div>440px</div>
			<div>320px</div>
			<div>ניתן לשים קישורים לאתרים מאובטחים בלבד</div>
		</div>			
		<div>
			<div>תמונה</div>
			<div>440px</div>
			<div>320px</div>
			<div>משקל קובץ מקסימלי - 100KB
				<br>ניתן לשים קישורים לאתרים מאובטחים בלבד
			</div>
		</div>			
		<div>
			<div>סרטון</div>
			<div>440px</div>
			<div>320px</div>
			<div>יש להעביר קישור לסרטון שניתן להטמיע. רצוי יו-טיוב</div>
		</div>			
	</div>
	<ul>
		<li>מוזמנים לתת לנו פידבק ולהגיד לנו מה הייתם רוצים מבחינת הגדרות המדיה. בהמשך הדרך ננסה להתאים גדלים יעודיים על פי המיקום המדויק באתר.</li>
	</ul>

	<h2>תהליך ותנאי תשלום</h2>
	<div class="payment">
		<ol style="padding:0px 35px 0px 15px; line-height:1.4em;">
			<li>גלשו לדף היעודי באתר המילון, ובחרו משבצת ומועד.</li>
			<li>שלחו מייל ל-<a href="mailto:arabic4hebs@gmail.com">arabic4hebs@gmail.com</a> עם בחירתכם.</li>
			<li>במידה והמשבצת עדיין פנויה, היא תשורין ל-24 שעות אשר במהלכן יש לבצע את התשלום.</li>
		</ol>
	</div>
</main>


<!--#include file="inc/trailer.asp"-->