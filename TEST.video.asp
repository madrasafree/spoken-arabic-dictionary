<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <title>ארגז חול - סרטון</title>
    <!--#include file="inc/header.asp"-->
    <style>
    .arb {
        line-height: 1em;
    }
    .eng{ 
        padding-bottom: 3px;
        text-transform: initial;
        float:none;
    }
    .heb {
        float:none;
    }
    .subtitles {
        margin:10px auto;
        width:min(95%,600px);
    }
    </style>
    <script>
    $(function() {
        // add classes
        $('.subtitles > div:nth-child(4n)').addClass("eng");
        $('.subtitles > div:nth-child(4n+1)').addClass("arb");
        $('.subtitles > div:nth-child(4n+2)').addClass("arb");
        $('.subtitles > div:nth-child(4n+3)').addClass("heb");

        //Filter
        $("#showArabic").click(function(){
            $('.subtitles > div:nth-child(4n+1)').toggle();
        });

        $("#showArabicHeb").click(function(){
            $('.subtitles > div:nth-child(4n+2)').toggle();
        });

        $("#showHebrew").click(function(){
            $('.subtitles > div:nth-child(4n+3)').toggle();
        });

        $("#showEnglish").click(function(){
            $('.subtitles > div:nth-child(4n)').toggle();
        });
    });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ניסויים</a> / 
	<h1>וידאו</h1>
</div>

<div style="POSITION:STICKY; TOP:40px; background:white; max-width:500px; text-align:center; margin:0 auto;">
    <iframe width="320" height="180" src="https://www.youtube.com/embed/LDek2BHoESk" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    <div>
        <label>عربية</label><input type="checkbox" id="showArabic" checked="checked" />
        <label>תעתיק עברי</label><input type="checkbox" id="showArabicHeb" checked="checked"  />
        <label>עברית</label><input type="checkbox" id="showHebrew" checked="checked"  />
        <label>English</label><input type="checkbox" id="showEnglish" checked="checked" />
    </div>
</div>


<div class="subtitles">
    <div>مرحبا</div>
    <div>מרחבא</div>
    <div>שלום</div>
    <div>Hello</div>
    <div>أنا صفاء</div>
    <div>אנא צפאא</div>
    <div>אני ספאא</div>
    <div>I am Safaa</div>
    <div>يلا نبلش</div>
    <div>ילא נבלש</div>
    <div>קדימה. נתחיל</div>
    <div>Let's start</div>
    <div>أول سؤال</div>
    <div>אול סאאל</div>
    <div>שאלה ראשונה</div>
    <div>First question</div>
    <div>وين إحنا موجودين؟</div>
    <div>וין אחנא מוג'ודין?</div>
    <div>איפה אנחנו נמצאים?</div>
    <div>Where are we?</div>
    <div>إحنا موجودين بمتنزه رمات غان</div>
    <div>אחנא מוג'ודין במתנזה רמאת ע'אן</div>
    <div>אנחנו נמצאים בפארק רמת גן</div>
    <div>We are In Ramat Gan park</div>
    <div>أي لهجة انت بتحكي؟</div>
    <div>אי להג'ה אנת בתחכי?</div>
    <div>איזה להג את דוברת?</div>
    <div>What dialect do you speak?</div>
    <div>أنا بحكي اللّهجة السّخنينية</div>
    <div>אנא בחכי (אל)לّהג'ה (אל)סّח'ניניה</div>
    <div>אני דוברת את הלהג של סַחְ'נִין</div>
    <div>I speak the Sakhnin dialect</div>
    <div>أي كلمة بالعربي الكل لازم يعرفها?</div>
    <div>אי כלמה באלערבי אלכל לאזם יערפהא?</div>
    <div>איזו מילה בערבית כדאי שכולם יכירו?</div>
    <div>Which word in Arabic should everyone know?</div>
    <div>بسطل كثير</div>
    <div>בסטל כת'יר</div>
    <div>"בִּסְטֵל כְּתִיר"</div>
    <div>"Bistel Ktir"</div>
    <div>يعني بيجنن كثير</div>
    <div>יעני ביג'נן כת'יר</div>
    <div>שזה אומר "מאוד מגניב"</div>
    <div>Which means "very cool"</div>
    <div>بأكم دولة كنت بالعالم؟</div>
    <div>באכם דולה כנת באלעאלם?</div>
    <div>בכמה מדינות בעולם היית?</div>
    <div>How many countries have you been to?</div>
    <div>كنت بثلاث دول</div>
    <div>כנת בת'לאת' דול</div>
    <div>הייתי בשלוש מדינות</div>
    <div>I have been in three countries</div>
    <div>شو أكثر اشي بخوفك؟</div>
    <div>שו אכת'ר אשי בח'ופכ?</div>
    <div>מה הדבר שהכי מפחיד אותך?</div>
    <div>What is the thing that scares you the most?</div>

    <div>اكثر اشي بخوفني...</div>
    <div>אכת'ר אשי בח'ופני...</div>
    <div>הדבר שהכי מפחיד אותי...</div>
    <div>The thing that scares me the most...</div>
    <div>إنه امي او ابوي يتأذوا</div>
    <div>אנו אמי או אבוי יתאד'ו</div>
    <div>שאמי או אבי ייפגעו</div>
    <div>is that my mother or father will be hurt</div>
    <div>عندك حيوانات أليفة؟ شو اسماهن؟</div>
    <div>ענדכ חיואנאת אליפה? שו אסמאהן?</div>
    <div>יש לך חיות מחמד? איך קוראים להם?</div>
    <div>Do you have any pets? What are their names?</div>
    <div>عندي كلبة. اسمها لوتشي.</div>
    <div>ענדי כלבה. אסמהא לותשי</div>
    <div>יש לי כלבה. קוראים לה לוצ'י</div>
    <div>I have a dog. Her name is Luchy</div>
    <div>اي اشي بيخليك تبكي؟</div>
    <div>אי אשי ביח'ליכִּ תבּכּי?</div>
    <div>מה גורם לך לבכות?</div>
    <div>What makes you cry?</div>
    <div>الاشي الي بخليني ابكي هو...</div>
    <div>אלאשי אלי בח'ליני אבכי הו...</div>
    <div>הדבר שגורם לי לבכות הוא...</div>
    <div>The thing that makes me cry is...</div>
    <div>الكتمان. يعني..</div>
    <div>אלכתמאן. יעני...</div>
    <div>לשמור סוד. כלומר...</div>
    <div>keeping a secret. I mean...</div>
    <div>الضغط الزائد، لما بخليه جواتي كثير</div>
    <div>אלצ'ע'ט אלזאיד, למא בחליו ג'ואתי כת'יר</div>
    <div>הלחץ האינטנסיבי, כשאני משאירה אותו בתוכי הרבה</div>
    <div>The intense pressure, when I keep it inside me a lot</div>
    <div>فبتراكم وممكن اني ابكي</div>
    <div>פ-בתראכם וממכן אני אבכי</div>
    <div>הוא מצטבר ואני עלולה לבכות</div>
    <div>it builds up and I could cry</div>
    <div>شو أكثر كلمة بتحبيها بأي لغة بالعالم؟</div>
    <div>שו אכת'ר כלמה בתחביהא באי לע'ה באלעאלם?</div>
    <div>מה המילה האהובה עלייך בכל שפה בעולם?</div>
    <div>What is your favourite word, in any language in the world?</div>

    <div>سلام</div>
    <div>סלאם</div>
    <div>שלום</div>
    <div>Peace</div>
    <div>مِش مُهِم</div>
    <div>מש מהם</div>
    <div>לא חשוב</div>
    <div>Never mind</div>
    <div>شو بتعرفي تطبخي؟</div>
    <div>שו בתערפי תטבח'י?</div>
    <div>מה את יודעת לבשל?</div>
    <div>What can you cook?</div>
    <div>مُمكن الوصفة؟</div>
    <div>ממכן אלוצפה?</div>
    <div>אפשר את המתכון?</div>
    <div>Can we have the recipe?</div>
    <div>بعرف اطبخ كثير اشياء</div>
    <div>בערף אטבח' כת'יר אשיאא</div>
    <div>אני יודעת לבשל הרבה דברים</div>
    <div>I can cook many things</div>
    <div>أكل عربي، طبعًا</div>
    <div>אכל ערבי, טבען</div>
    <div>אוכל ערבי, כמובן</div>
    <div>Arab food, of course</div>
    <div>دوالي</div>
    <div>דואלי</div>
    <div>עלי גפן</div>
    <div>vine leaves</div>
    <div>محاشي</div>
    <div>מחאשי</div>
    <div>ממולאים</div>
    <div>Stuffed Vegetables</div>
    <div>الوصفة، صعب بصراحة اعطيكو اياها، يعني</div>
    <div>אלוצפה, צעב בצראחה אעטיכו איאהא, יעני...</div>
    <div>המתכון, קשה ממש לתת לכם אותו, זאת אומרת...</div>
    <div>The recipe, it's hard to give it to you, I mean...</div>
    <div>بس بالأساس دوالي</div>
    <div>בס באלאסאס דואלי</div>
    <div>אבל העיקר זה עלי גפן</div>
    <div>but the main thing is vine leaves</div>
    <div>مع رز</div>
    <div>מע רֻז</div>
    <div>עם אורז</div>
    <div>with rice</div>
    <div>وبالاخر بتطبخوها، يعني هيك بالاساس</div>
    <div>ובאלאח'ר בתטבח'והא, יעני היכ באלאסאס</div>
    <div>ובסופו של דבר מבשלים אותם, זה העיקר</div>
    <div>and you just cook them, that's the main thing</div>
    <div>مع شوية بهارات وخلص</div>
    <div>מע שוית בהאראת וח'לץ</div>
    <div>עם קצת תבלינים וזהו</div>
    <div>with some spices and that's it</div>
    <div>شو ممكن يخليك مبسوطة اسا؟</div>
    <div>שו ממכן יחליכי מבסוטה אסא?</div>
    <div>מה יעשה אותך שמחה עכשיו?</div>
    <div>What would make you happy now?</div>
    <div>حاليًا...</div>
    <div>חאלין...</div>
    <div>כרגע...</div>
    <div>Right now...</div>
    <div>"الاشي الي رح يخليني مبسوطة
    هو اني اشوف امي"</div>
    <div>"אלאשי אלי רח יח'ליני מבסוטה
    הו אני אשוף אמי"</div>
    <div>"הדבר שיעשה אותי שמחה
    הוא שאראה את אמא שלי"</div>
    <div>"what would make me happy
    is seeing my mother"</div>

    <div>كثير</div>
    <div>כת'יר</div>
    <div>מאוד (שמחה)</div>
    <div>Very much</div>
    <div>شو معك بجيابك؟</div>
    <div>שו מעכ בג'יאבכ?</div>
    <div>מה יש לך בכיסים?</div>
    <div>What do you have in your pockets?</div>
    <div>الصراحة، ولا اشي</div>
    <div>אלצראחה, ולא אשי</div>
    <div>בכנות, שום דבר</div>
    <div>Honestly, not a thing</div>
    <div>بلا ولا شي</div>
    <div>בלא ולא שי</div>
    <div>בלי כלום</div>
    <div>There's nothing</div>
    <div>"اذا بتصير شكل هندسي،
    اي شكل بتكوني وليش؟"</div>
    <div>"אד'א בתציר שכל הנדסי,
    אי שכל בתכוני וליש?"</div>
    <div>"אם היית צורה גאומטרית,
    איזו צורה היית?"</div>
    <div>"If you were a geometrical shape,
    which would you be?"</div>
    <div>اظن دائرة</div>
    <div>אט'ן דאארה</div>
    <div>אני חושבת שעיגול</div>
    <div>I think a circle</div>
    <div>لانو دائرة هي الشكل الوحيد الي فيس في...</div>
    <div>לאנו דאארה הי אלשכל אלוחיד אלי פיש פי...</div>
    <div>מכיוון שעיגול היא הצורה היחידה שאין לה...</div>
    <div>because a circle is the only shape that doesn't have...</div>
    <div>احدا الاشكال الي فش فيها زوايا</div>
    <div>אחדא אלאשכאל אלי פש פיהא זואיא</div>
    <div>אחת מהצורות שאין לה זוויות</div>
    <div>one of the shapes that doesn't have angles</div>
    <div>فاحتمال اني اعلق بالزوايا رح يكون قليل</div>
    <div>פ-אחתמאל אני אעלק באלזואיא רח יכון קליל</div>
    <div>כך שהסבירות שאתקע בזוויות שלה יהיה נמוך</div>
    <div>so the likelyhood I'll get stuck in its corners will be low</div>
    <div>"اذا بتقدر تلتقي باي شخص بالعالم،
    عايش او ميت، مين بتحب تلتقي وليش؟"</div>
    <div>"אד'א בתקדר תלתקי באי שח'ץ באלעאלם
    עאיש או מית, מין בתחב תלתקי וליש?"</div>
    <div>"אם תוכלי לפגוש כל אדם בעולם,
    חי או מת, את מי היית רוצה לפגוש ומדוע?"</div>
    <div>"If you could meet any person in the world,
    alive or dead, who would it be and why?"</div>
    <div>"اظن كنت رح التقي
    بالانسان الي اخترع القنابل"</div>
    <div>"אט'ן כנת רח אלתקי
    באלאנסאן אלי אח'תרע אלקנאבל"</div>
    <div>"אני חושבת שהייתי פוגשת
    את האיש שהמציא את הפצצות"</div>
    <div>"I think I would want to meet
    the person that invented the bombs"</div>
    <div>واخترع كل اشي بخص بال...</div>
    <div>ואח'תרע כל אשי בח'ץ באל...</div>
    <div>והמציא את כל מה שקשור ל...</div>
    <div>and anything to do with...</div>
    <div>سواريخ</div>
    <div>סואריח'</div>
    <div>טילים</div>
    <div>rockets</div>
    <div>عشان اسالو "ليش؟"</div>
    <div>עשאן אסאלו "ליש?"</div>
    <div>כדי לשאול אותו "למה?"</div>
    <div>so I could ask him "why?"</div>

    <div>كيف اصحابك وعيلتك بينادو عليك؟</div>
    <div>כיף אצחאבכ ועילתכ בינאדו עליכ?</div>
    <div>איך החברים והמשפחה קוראים לך?</div>
    <div>What do your friends and family call you?</div>
    <div>"صفوءة، صفصوفة، صفصف،
    صوفي، صوصة، صفائي"</div>
    <div>"צפואה, צפצופה, צפצף,
    צופה, צוצה, צפאאי"</div>
    <div>"ספואה, ספסופה, ספסף,
    סופה, סוסה, ספאאי"</div>
    <div>"Safoa, Safsufa, Safsaf, 
    Sufa, Susa, Safaay"</div>
    <div>صفوئتي. هيك</div>
    <div>צפואתי. היכ</div>
    <div>ספואתי. ככה.</div>
    <div>Safwati. That's how.</div>
    <div>شوأقلّ كلمة بتحبيها، بكل لغة بالعالم؟</div>
    <div>שו אַקַל כלמה בתחביהא, בכל לע'ה באלעאלם?</div>
    <div>איזו מילה את הכי פחות אוהבת, בכל שפה בעולם?</div>
    <div>"Which is your least favourite word,
    in any language in the world?"</div>
    <div>حرب</div>
    <div>חרב</div>
    <div>מלחמה</div>
    <div>War</div>
    <div>وين بتنصحنا نتمشى بلدك اللي تربيت فيها؟</div>
    <div>וין בתנצחנא נתמשא בלדכ אלי תרבית פיהא?</div>
    <div>איפה תמליצי לנו לטייל בעיר בה גדלת?</div>
    <div>"Where would you recommend we
    visit in the city you grew up in?"</div>
    <div>بسخنين في حارة قديمة</div>
    <div>בסח'נין פי חארה קדימה</div>
    <div>בסח'נין יש שכונה עתיקה</div>
    <div>In Sakhnin there is an old neighbourhood</div>
    <div>جدًا جدًا جدًا حلوة</div>
    <div>ג'דן ג'דן ג'דן חלוה</div>
    <div>מאוד מאוד מאוד יפה</div>
    <div>Very very very pretty</div>
    <div>فحارة كثير كثير قديمة</div>
    <div>פ-חארה כת'יר כת'יר קדימה</div>
    <div>ושכונה מאוד מאוד עתיקה</div>
    <div>and very very old</div>
    <div>وفيها متحف برضو قديم</div>
    <div>ופיהא מתחף ברצ'ו קדים</div>
    <div>ויש בה מוזיאון שהוא גם עתיק</div>
    <div>and it has a museum which is also old</div>
    <div>فكثير بنصح انكو تزوروه</div>
    <div>פ-כת'יר בנצח אנכו תזורוה</div>
    <div>ואני מאוד ממליצה לכם לבקר בו</div>
    <div>and I really recommend that you visit it</div>

    <div>ليش الجاجة قطعت الشارع؟</div>
    <div>ליש אלג'אג'ה קטעת אלשארע?</div>
    <div>למה התרנגולת חצתה את הכביש?</div>
    <div>Why did the chicken cross the road?</div>
    <div>ليش الجاجة قطعت الشارع؟</div>
    <div>ליש אלג'אג'ה קטעת אלשארע?</div>
    <div>למה התרנגולת חצתה את הכביש?</div>
    <div>Why did the chicken cross the road?</div>
    <div>[صفاء عم بتضحك]</div>
    <div>[צפאא עם בתצ'חכ]</div>
    <div>[ספאא צוחקת]</div>
    <div>[Safaa laughing]</div>
    <div>ليش الجاجة قطعت الشارع؟</div>
    <div>ליש אלג'אג'ה קטעת אלשארע?</div>
    <div>למה התרנגולת חצתה את הכביש?</div>
    <div>Why did the chicken cross the road?</div>
    <div>بتلحق الصوص يمكن</div>
    <div>בתלחק א(ל)צוץ ימכן</div>
    <div>אולי היא רודפת אחרי האפרוח</div>
    <div>Maybe she's chasing the (baby) chick</div>
    <div>ليش الجاجة قطعت الشارع؟</div>
    <div>ליש אלג'אג'ה קטעת אלשארע?</div>
    <div>למה התרנגולת חצתה את הכביש?</div>
    <div>Why did the chicken cross the road?</div>
    <div>شو كانت التحلاية الأخيرة الي اكلتها؟</div>
    <div>שו כאנת אלתחלאיה אלאח'ירה אלי אכלתהא?</div>
    <div>מה הקינוח האחרון שאכלת?</div>
    <div>What was the last dessert you had?</div>
    <div>وصف تفصيلي</div>
    <div>וצף תפצילי</div>
    <div>תיאור מפורט</div>
    <div>Detailed description</div>
    <div>تحلاية... تحلاية...</div>
    <div>תחלאיה... תחלאיה...</div>
    <div>קינוח... קינוח...</div>
    <div>dessert... dessert...</div>
    <div>بينفع شكلاطة؟</div>
    <div>בינפע שכלאטה?</div>
    <div>אולי שוקולד?</div>
    <div>Maybe chocolate?</div>
    <div>شكلاطة</div>
    <div>שכלאטה</div>
    <div>שוקולד</div>
    <div>Chocolate</div>
    <div>إمبارح</div>
    <div>אמבארח</div>
    <div>אתמול</div>
    <div>Yesterday</div>
    <div>صيف، شتاء، خريف او ربيع؟</div>
    <div>צ'יף, שתאא, ח'ריף או רביע?</div>
    <div>קיץ, חורף, סתיו או אביב?</div>
    <div>Summer, winter, fall or spring?</div>
    <div>شتاء. شتاء. شتاء. ثمّ - شتاء!</div>
    <div>שתאא. שתאא. שתאא. תֻ'םّ - שתאא!</div>
    <div>חורף. חורף. חורף. ושוב פעם - חורף!</div>
    <div>Winter. Winter. Winter. and again - Winter!</div>
    <div>وبعدها، برضو شتاء</div>
    <div>ובעדהא, ברצ'ו שתאא</div>
    <div>ואחר כך, גם כן חורף.</div>
    <div>and afterwards, also Winter.</div>
    <div>شو بتشتغل؟</div>
    <div>שו בתשתע'ל?</div>
    <div>במה אתה עובד?</div>
    <div>"What do you do for a living?
    (male inflection)"</div>

    <div>"شو بتشتغلي؟" بِالْأَحْرَى</div>
    <div>"שו בתשתע'לי?" בִּ(א)לְאַחְרַא</div>
    <div>"במה את עובדת?" ליתר דיוק</div>
    <div>"""What do you do for a living?""
    (female inflection) To be correct"</div>
    <div>بشتغل...</div>
    <div>בשתע'ל...</div>
    <div>אני עובדת...</div>
    <div>I work...</div>
    <div>بدكانة اواعي</div>
    <div>בדכאנת אואעי</div>
    <div>בחנות בגדים</div>
    <div>in a clothes shop</div>
    <div>اسمها '24/7'</div>
    <div>אסמהא '24/7'</div>
    <div>בשם '24/7'</div>
    <div>called '24/7'</div>
    <div>مسؤولة وردية</div>
    <div>מסאולת ורדיה</div>
    <div>אחראית משמרת ("מסאולת ורדיה")</div>
    <div>shift manager</div>
    <div>بالعربي</div>
    <div>"באלערבי
    (ספאא מציינת זאת כיוון שערבים בישראל משתמשים גם במונח העברי)"</div>
    <div>"בערבית 
    (ספאא מציינת זאת כיוון שערבים
    בישראל משתמשים גם במונח העברי)"</div>
    <div>"In Arabic
    (* it's common for Arab Israelis to use the Hebrew term)"</div>
    <div>كثير بحب شغلي</div>
    <div>כת'יר בחב שע'לי</div>
    <div>אני מאוד אוהבת את העבודה שלי</div>
    <div>I love my work very much</div>
    <div>وكثير بحب الناس الي بشتغل معهن</div>
    <div>וכת'יר בחב אלנאס אלי בשתע'ל מעהן</div>
    <div>ואני מאוד אוהבת את האנשים שאני עובדת איתם</div>
    <div>and I love the people I work with very much</div>
    <div>وكثير بحب اتعمل مع زبائن</div>
    <div>וכת'יר בחב אתעמל מע זבאאן</div>
    <div>ואני אוהבת מאוד לעבוד עם לקוחות</div>
    <div>and I love to work with customers very much</div>
    <div>مع ناس. مع...</div>
    <div>מע נאס. מע...</div>
    <div>עם אנשים. עם...</div>
    <div>with people. with...</div>
    <div>احكي مع ناس</div>
    <div>אחכי מע נאס</div>
    <div>שאני מדברת עם אנשים</div>
    <div>talking to people</div>
    <div>اي فيلم تنصحينا نشوف؟</div>
    <div>אי פילם תנצחינא נשוף?</div>
    <div>איזה סרט תמליצי לנו לראות?</div>
    <div>What film would you recommend we watch?</div>
    <div>بنصحكو تشوفو فيلم...</div>
    <div>בנסחכו תשופו פילם...</div>
    <div>אני ממליצה שתראו את הסרט...</div>
    <div>I recommend you watch the movie...</div>
    <div>بشك كلياتكو بتحبوه، يعني بس انو</div>
    <div>בשכ כליאתכו בתחבוה, יעני בס אנו</div>
    <div>אני בספק שכולכם תאהבו אותו, אבל בכל מקרה...</div>
    <div>I doubt all of you will like it, but anyway...</div>
    <div>فيام اسمو [عبري:] "بالاش مهاخائم"</div>
    <div>פילם אסמו "בלש מהחיים"</div>
    <div>סרט ששמו "בלש מהחיים"</div>
    <div>a movie called [Hebrew:] "Balash meHaKhaim"</div>
    <div>فيلم بالانجليزي</div>
    <div>פילם באלאנגליזי</div>
    <div>סרט באנגלית</div>
    <div>a movie in English</div>
    <div>يعني، بالعربي اسمو، اذا بنترجموه</div>
    <div>יעני, באלערבי אסמו, אד'א בנתרג'מו</div>
    <div>"אז בערבית השם שלו יהיה,
    אם נתרגם אותו"</div>
    <div>in Arabic his name is, if we translate it</div>
    <div>فاسمو</div>
    <div>פ-אסמו</div>
    <div>שמו יהיה</div>
    <div>his name would be</div>
    <div>"محقّق من الحياة"</div>
    <div>"מחקّק מן אלחיאה"</div>
    <div>"בלש מהחיים"</div>
    <div>"Real life detective"</div>
    <div>او "محقّق حقيقي"</div>
    <div>או "מחקّק חקיקי"</div>
    <div>או "בלש אמיתי"</div>
    <div>or "Real detective"</div>
    <div>هيك اشي يعني</div>
    <div>היכ אשי יעני</div>
    <div>משהו כזה</div>
    <div>something like that</div>
    <div>بحكي عن جرائم قتل</div>
    <div>בחכי ען ג'ראאם קתל</div>
    <div>מדבר על רציחות</div>
    <div>it's about murders</div>

    <div>اللي هي صارت بالفعل، يعني بحقيقة</div>
    <div>אללי הי צארת באלפעל, יעני בחקיקה</div>
    <div>שקרו באמת, כלומר במציאות</div>
    <div>that actually happened, In reallity I mean</div>
    <div>و...</div>
    <div>ו...</div>
    <div>ו...</div>
    <div>And...</div>
    <div>بجيبو كثير اشحاس اللي هنو كان محققين</div>
    <div>בג'יבו כת'יר אשחאס אללי הנו כאן מחקקין</div>
    <div>מביאים הרבה אנשים שהיו בלשים</div>
    <div>they bring a lot of people who were detactives</div>
    <div>بعد ما طلعو تقاعد</div>
    <div>בעד מא טלעו תקאעד</div>
    <div>אחרי שיצאו לפנסיה</div>
    <div>after they retired</div>
    <div>وبعملو معهن محدثة وبفهمو</div>
    <div>ובעמלו מעהן מחדת'ה ובפהמו</div>
    <div>ועשו איתם שיחה ומבינים</div>
    <div>and talked to them and understand</div>
    <div>من هن؟ كيف سارت الجريمة؟ وكيف حققو؟</div>
    <div>מן הן? כיף צארת אלג'רימה? וכיף חקקו?</div>
    <div>מי הם? איך התרחש הפשע? וכיצד חקרו?</div>
    <div>who they are? How did the crime happen? How did they investigate?</div>
    <div>وفيها كثير لقطات اللي ممكن تكون جدًا صعبة، بس...</div>
    <div>ופיהא כת'יר לקטאת אלי ממכן תכון ג'דן צעבה, בס...</div>
    <div>ויש בה הרבה סצינות שיכולות להיות מאוד קשות, אבל...</div>
    <div>it has many scenes that might be distressing, but...</div>
    <div>فيو كثير أشياء ممكن نتعلم</div>
    <div>פיו כת'יר אשיאא ממכן נתעלם</div>
    <div>יש בו הרבה דברים שאפשר ללמוד</div>
    <div>it has many things we can learn from it</div>
    <div>شو اكثر ريحة بتحبيها؟</div>
    <div>שו אכת'ר ריחה בתחביהא?</div>
    <div>איזה ריח את הכי אוהבת?</div>
    <div>Which smell do you love the most?</div>
    <div>ريحة شكلاطة؟</div>
    <div>ריחת שכלאטה?</div>
    <div>ריח של שוקולד?</div>
    <div>The smell of chocolate?</div>
    <div>ريحة شكلاطة</div>
    <div>ריחת שכלאטה</div>
    <div>ריח של שוקולד</div>
    <div>The smell of chocolate</div>

    <div>بتعرفي تعزفي او بتحبي تتعلمي الى اشي؟</div>
    <div>בתערפי תעזפי או בתחבי תתעלמי עלא אשי?</div>
    <div>על איזה כלי נגינה את יודעת או היית רוצה לדעת לנגן?</div>
    <div>Which musical instrument do you know or would like to know how to play?</div>
    <div>الصراحة بعرفش اعزف</div>
    <div>א(ל)צראחה בערפש אעזף</div>
    <div>האמת שאני לא יודעת לנגן</div>
    <div>The truth is I don't play</div>
    <div>بس اذا بتمناه اشي، هو بتمناه اني...</div>
    <div>בס אד'א בתמנא אשי, הו בתמנא אנו...</div>
    <div>אבל אם הייתי מאחלת משהו (לעצמי), הייתי מאחלת ש...</div>
    <div>but if I'd wish something for myself, I'd wish that...</div>
    <div>لو اني تعلمت او لو اني بقدر اتعلم اعزف على بيانو او كمان</div>
    <div>לו אני תעלמת או לו אני בקדר אתעלם אעזף עלא פיאנו או כמאן</div>
    <div>אלמד או שאוכל ללמוד לנגן על פסנתר או כינור</div>
    <div>I'd play or could learn how to play the piano or violin</div>
    <div>شكرًا كثير</div>
    <div>שכרן כת'יר</div>
    <div>תודה רבה</div>
    <div>Thank you</div>
    <div>خلص</div>
    <div>ח'לצ</div>
    <div>נגמר</div>
    <div>All done</div>
    <div>رونين: شكرًا صفاء</div>
    <div>רונין: שכרן צפאא</div>
    <div>רונן: תודה ספאא</div>
    <div>Ronen: Thank you Safaa</div>

</div><!--subtitles ends here-->


<!--#include file="inc/trailer.asp"-->