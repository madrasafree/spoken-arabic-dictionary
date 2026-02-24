<!--#include file="includes/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <title>קריאת שעון בערבית מדוברת</title>
	<meta name="Description" content="קריאת השעון בערבית מדוברת. אפשרות לתעתיק עברי או כתב ערבי. ניתן לשנות את השעה שמוצגת" />
    <meta name="Keywords" content="מה השעה בערבית, שעון בערבית, שעה בערבית" />
    <meta property="og:url"     content="https://milon.madrasafree.com/clock.asp" />
    <meta property="og:type"     content="website" />
    <meta property="og:title"     content="קריאת השעון בערבית מדוברת" />
    <meta property="og:description"     content="קריאת השעון בערבית מדוברת. אפשרות לתעתיק עברי או כתב ערבי. ניתן לשנות את השעה שמוצגת" />
    <meta property="og:image"           content="https://milon.madrasafree.com/img/site/page.banner.clock.png" />
    <!--#include file="includes/header.asp"-->
    <script>
        function loadDeferredIframe() {
            // this function will load the iframes after the page loads and the JS runs
            var iframe1 = document.getElementById("iframe1");
            iframe1.src = "https://www.youtube-nocookie.com/embed/-QLuHNnMXlY";
            var iframe2 = document.getElementById("iframe2");
            iframe2.src = "https://www.youtube.com/embed/HGVeaCqWVKo?start=570";
        };
        
        window.onload = loadDeferredIframe;
    </script>

    <style>
        
        #container {
            width:100%;
        }

        #clockDash > div {
            display:inline-block;
            margin-left:20px;
        }

        #clockBtns {
            margin: 20px auto;
            padding: 5px 20px;
        }
        .clockBtn {
            background:#eff8fe;
            border: 1px solid #4191c255;
            border-radius: 10px;
            display:inline-block;
            padding:5px 10px;
        }
        section {
            width:100%; 
            margin:0 auto;
            text-align:center;
        }

        #taatikDisplay {
            background:#ffffff;
            border:2px solid gray;
            color:#2ead31;
            font-size: 2em;
            padding:5px 10px;
            width:fit-content; 
        }

        #entireHour {
            width:99%; 
            padding:5px; 
            color:#2ead31;
            margin:20px auto;
            font-size: 1.4em;
            text-align:center; 
        }

        .halfHour {
            width:49%;
        }

        .quarter {
            border-left:1px dotted gray;
            width:50%;
            text-align:right;
        }

        .quarter, .halfHour {
            display:inline-block;
            box-sizing:border-box;
        }

        .quarter > div {
            font-size:1.4rem;
            padding-right:5px;
        }

        .quarter > div > span:first-child {
            padding-left:10px;
            text-align:center;
            font-size:initial;
            font-family:arial;
            color:gray;
            letter-spacing: initial;
            background:none;
        }

        #timeInput {font-size: 2em;
                    border-radius: 6PX;
                    background: #999999;
                    color: white;
                    border: 0;
                    margin: 5px auto 15px auto;
                    font-weight: bold;
                    text-align: center;
                    PADDING: 2px 10px;
                    max-width:200px;
                    }
        #timeInput:hover {cursor:pointer; background:#777777;}

        #mmNow {
            background:#e3dd2888;
            border:dotted gray;
            border-width:1px 0;
        }
        
        .mmFive {
            color:#165017;
        }

        .youtubeVid {
            position: relative;
            max-width: 800px;
            margin:0 auto 3px auto;
            overflow:hidden;
            padding-top:56%;
        }
        .youtubeVid iframe { 
            position:absolute;
            top:0; left:0; bottom:0; right:0;
            width:100%; 
            height:100%;
        }

        #iframe1 {
            border:1px solid gray;
        }

        .aBTN:link, .aBTN:visited {
            background:#158d18;
            color:white;
            display:block;
            font-size:large;
            margin:5px auto 10px auto;
            padding:10px 25px;
            width:fit-content;
        }

        .aBTN:hover {
            background:#158d1811;
            color:#158d18;
            border:#158d18 solid;
            border-width:0 3px;
        }

        @media only screen and (min-width: 800px) {
            .youtubeVid {
                position: initial;
                max-width: 800px;
                margin:0 auto;
                padding:0;
            }
            .youtubeVid iframe { 
                position: initial;
                width:790px;
                }

            #iframe1 {
                height:440px;
            }
            #iframe2 {
                height:600px;
            }
        }

        @media only screen and (max-width: 1820px) {
            .halfHour {width:48%;}
            .quarter {width:100%;}
        }

        @media only screen and (max-width: 900px) {
            .halfHour, .quarter {width:100%;}
        }

        @media only screen and (max-width: 400px) {
            #clockDash > div {
                display:block;
                margin:10px auto;
            }
            #taatikDisplay {
                border-width:2px 0;
                display:block;
                font-size:1.6rem;
                margin:0;
                padding:0;
                width:100%;
            }
            .quarter {
                border:0;
                }
            .quarter > div {
                border-bottom:1px solid #999;
                margin-bottom:2px;
            }
            .quarter > div > span:first-child {
                display:block;
                text-align:right;
                padding-top:5px;
                }
            #mmNow {border:0;}

}
    </style>

</head>
<body>
<!--#include file="includes/top.asp"-->

<h1 id="pTitle">קריאת שעון בערבית מדוברת</h1>

<div class="table" style="text-align:center;">ניתן לשנות את השעה</div>

<section id="clockDash">
    <div id="clockBtns">
        <div class="clockBtn">
            <input type="radio" id="btnTaatik" name="btnLng" value="taatik" checked="checked">
            <label for="btnTaatik">תעתיק עברי</label>
        </div>
        <div class="clockBtn">
            <input type="radio" id="btnArabic" name="btnLng" value="arabic">
            <label for="btnArabic">عربي</label>
        </div>
    </div>

    <div>
        <input id="timeInput" type="time" dir="ltr" value="" />
    </div>

    <div id="taatikDisplay">
    </div>
</section>

<section>
    <div id="entireHour">
    </div>
</section>

<div class="youtubeVid">
    <iframe id="iframe1" src="about:blank" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowFullScreen></iframe>
</div>
<a class="aBTN" target="madrasa" href="https://madrasafree.com/">קורסי מדוברת בחינם</a>

<div class="youtubeVid">
    <iframe id="iframe2" src="about:blank" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
<a class="aBTN" target="youtube" href="https://www.youtube.com/playlist?list=PLV2YW4LPjpJrGBMtr8NoC6xI9UTkL4U6j">סרטוני תעלם ותכלם</a>


<script>

    var hh,mm;

    function getCurrentTime(){
        timeNowIs = new Date();
        hh = pad(timeNowIs.getHours(),2);
        mm = pad(timeNowIs.getMinutes(),2);
    }

    var daqiqa = 'דַקִיקַה';

    getCurrentTime();
    document.getElementById("timeInput").value = hh+":"+mm;


    showTimeNow();

    function showTimeNow(){

        var textBuild = "";
        for (i=0; i < 60; i++){
            if (i == 0) textBuild += "<div class='halfHour'><div class='quarter'>";
            if (i == 15 || i == 45) textBuild += "</div><div class='quarter'>";
            if (i == 30) textBuild += "</div></div><div class='halfHour'><div class='quarter'>";
            
            textBuild += "<div ";

            if (pad(i,2)==mm) textBuild += " id='mmNow'";
            if (i % 5 == 0) textBuild += " class='mmFive'";

            textBuild += "><span>" + hh + ":" + pad(i,2) + "</span><span data-arabic='السّاعة ' data-taatik='אִ(ל)סֵّאעַה '>"
            textBuild += "אִ(ל)סֵّאעַה </span><span data-arabic='";

            if (i==40 || i==45 || i==50 || i==55) {
                textBuild += hhArabic(parseInt(hh)+1) + "' data-taatik='";
                textBuild += hhTaatik(parseInt(hh)+1) + "'>" + hhTaatik(parseInt(hh)+1) + "</span>";
            } else {
                textBuild += hhArabic(hh) + "' data-taatik='";
                textBuild += hhTaatik(hh) + "'>" + hhTaatik(hh) + "</span>";
            }
            
            textBuild += "<span data-arabic='" + mmArabic(pad(i,2));
            textBuild += " ' data-taatik='" + mmTaatik(pad(i,2)) + " '>" + mmTaatik(pad(i,2)) + " </span><span ";

            if (i > 2 && i < 11) daqiqa = "data-arabic='دقايق' data-taatik='דַקַאיֵק'>דַקַאיֵק";
            if (i % 5 == 0) daqiqa = ">";
            if (i == 1 || i == 2) daqiqa = ">";
            
            textBuild += daqiqa + "</span></div>";
            daqiqa = "data-arabic='دقيقة' data-taatik='דַקִיקַה'>דַקִיקַה";

            if (i % 15 == 59) textBuild += "</div></div>";

            document.getElementById("entireHour").innerHTML = textBuild;

        }
        showMainTaatik()
    }


    function showMainTaatik(){
        var itm = "";
        $("#mmNow").children().not(":first-child").each(function(i, el){
            itm += el.outerHTML;
        }); 

        $("#taatikDisplay").empty().append(itm);
    }


    function pad(num,size){
        num = num.toString();
        while (num.length < size) num = "0" + num;
        return num;
    }

    function hhTaatik(hh){
        switch (parseInt(hh)) {
            case 01: case 13: return 'וַחַדֵה'; break;
            case 02: case 14: return "תִנְתֵין"; break;
            case 03: case 15: return "תַלַאתֵה"; break;
            case 04: case 16: return 'אַרְבַּעַה'; break;
            case 05: case 17: return "חַ׳מְסַה"; break;
            case 06: case 18: return 'סִתֵّה'; break;
            case 07: case 19: return 'סַבְּעַה'; break;
            case 08: case 20: return 'תַמַאנְיֵה'; break;
            case 09: case 21: return 'תִסְעַה'; break;
            case 10: case 22: return 'עַשַרַה'; break;
            case 11: case 23: return 'אְחְדַעַש'; break;
            case 12: case 24: case 00: return 'תְנַעַש'; break;
        }
    }

    function mmTaatik(mm){
        switch (parseInt(mm)) {
            case 00:    return " בִּ(אל)זַّבֵּט"; break;
            case 01:    return " וּדַקִיקַה"; break;
            case 02:    return " וּדַקִיקְתֵין"; break;
            case 03:    return " וּתַלַת"; break;
            case 04:    return " וּאַרְבַּע"; break;
            case 05:    return " וּחַ׳מְסֵה"; break;
            case 06:    return " וּסִתّ"; break;
            case 07:    return " וּסַבְּע"; break;
            case 08:    return " וּתַמַן"; break;
            case 09:    return " וּתִסְע"; break;
            case 10:    return " וּעַשַרַה"; break;
            case 11:    return " וּחְדַעְשַר"; break;
            case 12:    return " וּתְנַעְשַר"; break;
            case 13:    return " וּתְלַאתַעְשַר"; break;
            case 14:    return " וּאַרְבַּעְתַעַשַר"; break;
            case 15:    return " וּרֻבְּע"; break;
            case 16:    return " וּסִתַעְשַר"; break;
            case 17:    return " וּסַבַּעְתַעְשַר"; break;
            case 18:    return " וּתַמַנְתַעְשַר"; break;
            case 19:    return " וּתִסְעַתַעְשַר"; break;
            case 20:    return " וּתֻלְת"; break;
            case 21:    return " וּוַאחַד וּעִשְרִין"; break;
            case 22:    return " ותְנֵין וּעִשְרִין"; break;
            case 23:    return " וּתַלַאתֵה וּעִשְרִין"; break;
            case 24:    return " וּאַרְבַּעַה וּעִשְרִין"; break;
            case 25:    return " וּנֻץّ אִלַّא חַ׳מְסֵה"; break;
            case 26:    return " וּסִתֵّה וּעִשְרִין"; break;
            case 27:    return " וּסַבְּעַה וּעִשְרִין"; break;
            case 28:    return " וּתַמַאנְיֵה וּעִשְרִין"; break;
            case 29:    return " וּתִסְעַה וּעִשְרִין"; break;
            case 30:    return " וּנֻץّ"; break;
            case 31:    return " וּוַאחַד וּתַלַאתִין"; break;
            case 32:    return " ותְנֵין וּתַלַאתִין"; break;
            case 33:    return " וּתַלַאתֵה וּתַלַאתִין"; break;
            case 34:    return " וּאַרְבַּעַה וּתַלַאתִין"; break;
            case 35:    return " וּנֻץّ וּחַ׳מְסֵה"; break;
            case 36:    return " וּסִתֵّה וּתַלַאתִין"; break;
            case 37:    return " וּסַבְּעַה וּתַלַאתִין"; break;
            case 38:    return " וּתַמַאנְיֵה וּתַלַאתִין"; break;
            case 39:    return " וּתִסְעַה וּתַלַאתִין"; break;
            case 40:    return " אִלַّא תֻלְת"; break;
            case 41:    return " וּוַאחַד וּאַרְבַּעִין"; break;
            case 42:    return " ותְנֵין וּאַרְבַּעִין"; break;
            case 43:    return " וּתַלַאתֵה וּאַרְבַּעִין"; break;
            case 44:    return " וּאַרְבַּעַה וּאַרְבַּעִין"; break;
            case 45:    return " אִלַّא רֻבְּע"; break;
            case 46:    return " וּסִתֵّה וּאַרְבַּעִין"; break;
            case 47:    return " וּסַבְּעַה וּאַרְבַּעִין"; break;
            case 48:    return " וּתַמַאנְיֵה וּאַרְבַּעִין"; break;
            case 49:    return " וּתִסְעַה וּאַרְבַּעִין"; break;
            case 50:    return " אִלַّא עַשַרַה"; break;
            case 51:    return " וּוַאחַד וּחַ׳מְסִין"; break;
            case 52:    return " ותְנֵין וּחַ׳מְסִין"; break;
            case 53:    return " וּתַלַאתֵה וּחַ׳מְסִין"; break;
            case 54:    return " וּאַרְבַּעַה וּחַ׳מְסִין"; break;
            case 55:    return " אִלַّא חַ׳מְסֵה"; break;
            case 56:    return " וּסִתֵّה וּחַ׳מְסִין"; break;
            case 57:    return " וּסַבְּעַה וּחַ׳מְסִין"; break;
            case 58:    return " וּתַמַאנְיֵה וּחַ׳מְסִין"; break;
            case 59:    return " וּתִסְעַה וּחַ׳מְסִין"; break;
        }
    }

    function hhArabic(hh){
        switch (parseInt(hh)) {
            case 01: case 13: return 'وحدة'; break;
            case 02: case 14: return "تنتين"; break;
            case 03: case 15: return "تلاتة"; break;
            case 04: case 16: return 'أربعة'; break;
            case 05: case 17: return "خمسة"; break;
            case 06: case 18: return 'ستة'; break;
            case 07: case 19: return 'سبعة'; break;
            case 08: case 20: return 'تمانية'; break;
            case 09: case 21: return 'تسعة'; break;
            case 10: case 22: return 'عشرة'; break;
            case 11: case 23: return 'احدعش'; break;
            case 12: case 24: case 00: return 'تنعش'; break;
        }
    }

    function mmArabic(mm){
        switch (parseInt(mm)) {
            case 00:    return " بالزبط"; break;
            case 01:    return " ودقيقة"; break;
            case 02:    return " ودقيقتين"; break;
            case 03:    return " وتلات"; break;
            case 04:    return " وأربع"; break;
            case 05:    return " وخمسة"; break;
            case 06:    return " وست"; break;
            case 07:    return " وسبع"; break;
            case 08:    return " وتمن"; break;
            case 09:    return " وتسع"; break;
            case 10:    return " وعشرة"; break;
            case 11:    return " وحدعشر"; break;
            case 12:    return " وتنعشر"; break;
            case 13:    return " وتلاتعشر"; break;
            case 14:    return " وأربعتعشر"; break;
            case 15:    return " وربع"; break;
            case 16:    return " وستعشر"; break;
            case 17:    return " وسبعتعشر"; break;
            case 18:    return " وتمنتعشر"; break;
            case 19:    return " وتسعتعشر"; break;
            case 20:    return " وتلت"; break;
            case 21:    return " وواحد وعشرين"; break;
            case 22:    return " وتنين وعشرين"; break;
            case 23:    return " وتلاتة وعشرين"; break;
            case 24:    return " وأربعة وعشرين"; break;
            case 25:    return " ونص إلّا خمسة"; break;
            case 26:    return " وستة وعشرين"; break;
            case 27:    return " وسبعة وعشرين"; break;
            case 28:    return " وتمانية وعشرين"; break;
            case 29:    return " وتسعة وعشرين"; break;
            case 30:    return " ونص"; break;
            case 31:    return " وواحد وتلاتين "; break;
            case 32:    return " وتنين وتلاتبن"; break;
            case 33:    return " وتلاتة وتلاتبن"; break;
            case 34:    return " وأربعة وتلاتبن"; break;
            case 35:    return " ونص وخمسة"; break;
            case 36:    return " وستة وتلاتبن"; break;
            case 37:    return " وسبعة وتلاتبن"; break;
            case 38:    return " وتمانية وتلاتبن"; break;
            case 39:    return " وتسعة وتلاتبن"; break;
            case 40:    return " إلّا تلت"; break;
            case 41:    return " وواحد وأربعين"; break;
            case 42:    return " وتنين وأربعين"; break;
            case 43:    return " وتلاتة وأربعين"; break;
            case 44:    return " وأربعة وأربعين"; break;
            case 45:    return " إلّا ربع"; break;
            case 46:    return " وستة وأربعين"; break;
            case 47:    return " وسبعة وأربعين"; break;
            case 48:    return " وتمانية وأربعين"; break;
            case 49:    return " وتسعة وأربعين"; break;
            case 50:    return " إلّا عشرة"; break;
            case 51:    return " وواحد وخمسين"; break;
            case 52:    return " وتنين وخمسين"; break;
            case 53:    return " وتلاتة وخمسين"; break;
            case 54:    return " وأربعة وخمسين"; break;
            case 55:    return " إلّا خمسة"; break;
            case 56:    return " وستة وخمسين"; break;
            case 57:    return " وسبعة وخمسين"; break;
            case 58:    return " وتمانية وخمسين"; break;
            case 59:    return " وتسعة وخمسين"; break;
        }
    }


    $("#timeInput").on("change",function (){
        displayTimes($(this).val());
        clearInterval(refresher);
    });

    function displayTimes(hhmm){
        hh = hhmm.substring(0,2);
        mm = hhmm.substring(3,5);
        showTimeNow();
    }

    function displayArb(){
        var $arbTxt = $("span[data-arabic]");
        $arbTxt.each(function (i,el){
            $(el).html($(el).data("arabic"));
        });
    }

    $("#btnArabic").on("click",displayArb);

    $("#btnTaatik").on("click",function(){
        var $ttkTxt = $("span[data-taatik]");
        $ttkTxt.each(function (i,el){
            $(el).html($(el).data("taatik"));
        });
    });

    var refresher = setInterval(() => {
        var displayLang = $('input[name="btnLng"]:checked').val();
        getCurrentTime();
        showTimeNow();
        document.getElementById("timeInput").value = hh+":"+mm;
        if (displayLang == 'arabic') displayArb();
    }, 60000);

</script>
<!--#include file="includes/trailer.asp"-->