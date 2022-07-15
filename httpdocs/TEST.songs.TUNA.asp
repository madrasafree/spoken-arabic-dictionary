<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<meta name="robots" content="noindex" />
	<title>שירים - דף נסיוני</title>
	<meta name="Description" content="דף נסיוני - לא לנסות בבית" />
	<!--#include file="inc/header.asp"-->
	<style>
		#tuna {max-width:800px; margin:0 auto; font-size:1.2em;}
		.ar {color:green;}
		.hb {color:#009aff;}
		.ar2 {color:#009aff; background:#00ffff40;}
		.en {color:#d88d05;}
		.hbAr {color:#cb05d8;}
		.songHouse {margin:20px auto; font-weight:bold;}
		.songChorus {margin:20px; border-right:1px solid gray; padding-right:20px; font-weight:bold;}
		.songRow {margin:3px auto;}
	</style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">ניסוי - שירים</div> 

<div style="max-width:800px; margin:0 auto;">
	<p style="color:red;">לבדוק נושא זכויות יוצרים לפני שמחברים למילון</p>
	<h1>סרט ערבי <span style="display:inline-block; margin-left:10px; font-size:.5em; font-weight:100;">טונה</span></h1>
	<iframe width="560" height="315" src="https://www.youtube.com/embed/OPrbtVIwhHo?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</div>


<div id="tuna">
	<div>
		<span class="ar">ערבית</span> | <span class="hb">עברית</span> | <span class="ar2">שיבוש מערבית</span> | <span class="en">לועזית</span> | <span class="hbAr">מיקס עברית+ערבית</span>
	</div>
	
	מילים:
	<div class="songHouse">
		<div class="songRow"><span class="ar">יא איבני, יא באבה, יום באסאל, יום</span> סבבה</div>
		<div class="songRow"><span class="hb">חם כמו </span><span class="ar">פינג׳אן</span><span class="hb"> שעל האש, </span><span class="ar">יעני</span> <span class="hb">לבה</span></div>
		<div class="songRow">נוחת פי הליקופטר, יא סאלאם! ואיסמי ״טונה״</div>
		<div class="songRow">טלפון אל "Entourage", ״הלו?״ תעלו יא חמולה!</div>
		<div class="songRow">איסמע, יא ג׳מעה: יש פה אכבר משימייה!</div>
		<div class="songRow">כאן כל אחד משמיע מוזיקייה רצינייה</div>
		<div class="songRow">אינתה בא בדאווין יעני ״King״? אינעל אביך!</div>
		<div class="songRow">ואללאק, ראפ ישראלי הוא האדה ״פאשלה אל פאדיחה״</div>
		<div class="songRow">עוד זמר מלעון, אינתה ג׳אחש, יעני חנון</div>
		<div class="songRow">ג׳יב, ג׳יב אל מיקרופון, ואללאק תראה אותי מג׳נון</div>
		<div class="songRow">איפתח אל תזמורת וחלאס לבצורת</div>
		<div class="songRow">חרוזייה, על ה-Beats, כמו אוזניות של הדוקטורה</div>
		<div class="songRow">שובו של ה-M.C סלאמת פי מתחרייה</div>
		<div class="songRow">לא תשתיק ת׳אמנות עם פרסומות וניצנוצייה</div>
		<div class="songRow">"טונהמן ג׳ונס" בא כמו ״רדיו רמאללה״</div>
		<div class="songRow">נחליף לכם ת׳טעם בנרגילה... סמאללה</div>
	</div>

	[פזמון X2]
	<div class="songChorus">
		<div class="songRow">הנה זה מגיע, אל אחלה מסיבייה</div>
		<div class="songRow">כולם פה בחאפלה, בחורות בעינטוזייה</div>
		<div class="songRow">מצומת מסובייה, עד ערב אל סעודייה</div>
		<div class="songRow">יאללה שימו ת׳ידיים באויר</div>
		<div class="songRow">הוליווד - חירייה, עם כיפה או כאפייה</div>
		<div class="songRow">מבאקינגהם פאלאס עד לבאקה אל גרביה</div>
		<div class="songRow">תמיד אותו פזמון, כמה דרמה, מאמה-מייה</div>
		<div class="songRow">ואללה כולם פה בסרט ערבי...</div>
	</div>

	<div class="songHouse">
		<div class="songRow">בחייאת סעידה, שוואייה שוואייה</div>
		<div class="songRow">אינתה חילוואה יא חביבתי כמו... שו איסמה? טייב?</div>
		<div class="songRow">אנא אמצע משימייה, האדה Buisness, האדה Pleasure</div>
		<div class="songRow">נכנס אל הסייארה, James Bond, יעני - Danger!</div>
		<div class="songRow">ואחאד, תניין, ואחאד, ביחד אין פחד</div>
		<div class="songRow">תן בעיטות ל״טיזו״ לכל מי שתופס תחת</div>
		<div class="songRow">אומרים: ״אותה גברת בשינוי הגלבייה״</div>
		<div class="songRow">מה עם מסר? מה עם סטייל? מה עם ראש יצירתייה?</div>
		<div class="songRow">יאללה רוח! אני מגיע! הוקוס פוקוס כמו ״זריף״</div>
		<div class="songRow">מערבב ושם חריף, על הלשון של תל אביב</div>
		<div class="songRow">עכשיו תבין ת׳מסר, או קח את זה חפיף</div>
		<div class="songRow">והקהל, שוף את מי הוא מעדיף?</div>
		<div class="songRow">כיף?</div>
	</div>

	<div class="songChorus">
		[פזמון]
	</div>

	<div class="songHouse">
		<div class="songRow">Beyonce, Can you handle this?</div>
		<div class="songRow">Rihanna, Can you handle this?</div>
		<div class="songRow">Saida, Can you handle this?</div>
		<div class="songRow">Laa, Inta can't handle this!</div>
		<div class="songRow">I am the king of the middle east</div>
		<div class="songRow">Shake your "tiz" in the Levi's Jeans</div>
		<div class="songRow">היידה ישראל, יאללה קצת יותר ב-Passion</div>
		<div class="songRow">ואחאד, תניין, תאלתה, אקשן!</div>
	</div>

	<div class="songChorus">
		[פזמון]
	</div>

	<div class="songHouse">
		<div class="songRow">Aiwa...</div>
		<div class="songRow">Everybody: Aiwa...</div>
		<div class="songRow">Ya Habibti Aiwa...</div>
		<div class="songRow">כולם ביחד: Aiwa</div>
		<div class="songRow">Everybody: Aiwa...</div>
		<div class="songRow">Ya Habibti Aiwa..</div>
		<div class="songRow">כולם ביחד יאללה</div>
		<div class="songRow">Aiwa!</div>
	</div>

	<div class="songHouse">
		<div class="songRow">ג׳נטלמן, מסא אל-ח׳יר.</div>
		<div class="songRow">ליידיז, סבאח אל-נור.</div>
		<div class="songRow">I come in peace</div>
	</div>


</div>


<br />
<!--#include file="inc/trailer.asp"-->