<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <title>ארגז חול - RUBY</title>
    <!--#include file="inc/header.asp"-->
    <style>
        .arb {
            font-family:"harmattan";
            font-size: 2em;
        }
        .arb > span {
            border-color: #2ead31;
            border-width: 0 0 2px 0;
            border-style: solid;
        }
        .arb > span:hover {
            background:yellow;
        }
		#bread {
			background: white;
			border: 1px solid gray;
			border-radius: 0;
			margin: 20px auto;
			padding: 4px 8px;
			position: sticky;
			top:41px;
			z-index:999999;
			}
		#container {
			margin:20px auto;
			width:90%;
            }
        h1 {
			display:inline-block;
			font-size:medium;
			margin:0;
			text-align: center;
            }
        h2 {
            text-decoration:underline;
        }
        rt {
            font-family:"keter";
            font-size:large;
            direction:rtl;
        }
        .rubyFake {
            text-align:right;
        }
        .rubyFake > div {
            border:1px solid #8080804a;
            display:inline-block;
        }
        .rubyFake .harm {
            position:relative;
        }
        .rubyFake .keter {
            bottom:25px;
            font-size:large;
            left:50%;
            position:relative;
        }
        .rubyReal {
            text-align:right;
        }
        .table {
            width:1200px;
            text-align:right;
        }

    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
	<a href="test.asp">ניסויים</a> / 
	<h1>Interlinear gloss</h1>
</div>

<div class="table">

    <h2>משפט שלם - עם רובי</h2>
    <div class="arb rubyReal">
        <span><ruby><rb>הייתי</rb>كُنت<rt>כנת</rt></ruby></span>
        <span><ruby>بِالبَحَر<rt>באלבחר</rt></ruby></span>
        <span><ruby>وُما<rt>ומא</rt></ruby></span>
        <span><ruby>انْبَسطْتِش<rt>אנבסטתש</rt></ruby></span>
        <span><ruby>شيلي بيلي<rt>שילי בילי</rt></ruby></span>،
        <span><ruby>عَشان<rt>עשאן</rt></ruby></span>
        <span><ruby>كان<rt>כאן</rt></ruby></span>
        <span><ruby>في<rt>פי</rt></ruby></span>
        <span><ruby>قَناديل البَحَر<rt>קנאדיאל אלבחר</rt></ruby></span>
    </div>

    <h2>משפט שלם - עם רובי - פירוש מילולי בעברית</h2>
    <div class="arb rubyReal">
        <span><ruby>كُنت<rt>הייתי</rt></ruby></span>
        <span><ruby>بِالبَحَر<rt>בים</rt></ruby></span>
        <span><ruby>وُما<rt>ולא</rt></ruby></span>
        <span><ruby>انْبَسطْتِش<rt>לא נהנתי</rt></ruby></span>
        <span><ruby>شيلي بيلي<rt>בכלל</rt></ruby></span>،
        <span><ruby>عَشان<rt>בגלל</rt></ruby></span>
        <span><ruby>كان في<rt>היה</rt></ruby></span>
        <span><ruby>قَناديل البَحَر<rt>מדוזות</rt></ruby></span>
    </div>

    <h2>משפט שלם - עם חיקוי רובי</h2>
    <div class="arb rubyFake">
        <div>
            <span class="harm">كُنت</span>
            <span class="keter">כנת</span>
        </div>
        <div>
            <span class="harm">بِالبَحَر</span>
            <span class="keter">באלבחר</span>
        </div>
        <div>
            <span class="harm">وُما</span>
            <span class="keter">ומא</span>
        </div>
        <div>
            <span class="harm">انْبَسطْتِش</span>
            <span class="keter">אנבסטתש</span>
        </div>
        <div>
            <span class="harm">شيلي بيلي،</span>
            <span class="keter">שילי בילי,</span>
        </div>
        <div>
            <span class="harm">عَشان</span>
            <span class="keter">עשאן</span>
        </div>
        <div>
            <span class="harm">كان</span>
            <span class="keter">כאן</span>
        </div>
        <div>
            <span class="harm">في</span>
            <span class="keter">פי</span>
        </div>
        <div>
            <span class="harm">قَناديل البَحَر</span>
            <span class="keter">קנאדיאל אלבחר</span>
        </div>
    </div>


</div>


<!--#include file="inc/trailer.asp"-->