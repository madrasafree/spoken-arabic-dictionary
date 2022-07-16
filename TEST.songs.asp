<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>מילים עם תמונות</title>
	<meta name="Description" content="כל המילים שיש להם תמונה" />
	<!--#include file="inc/header.asp"-->
	<style>
			.arb {font-size:2em;}
	</style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">ניסוי - שירים</div> 

<div style="max-width:800px; margin:0 auto;">
	<p style="color:red;">לבדוק נושא זכויות יוצרים לפני שמחברים למילון</p>
	<h1 dir="ltr">Yalla Bina Yalla<span style="display:inline-block; margin-left:10px; font-size:.5em; font-weight:100;">Alabina (ft. Ishtar,Los Niños de Sara)</span></h1>
	<iframe width="560" height="315" src="https://www.youtube.com/embed/mDhmKrW4F6Y?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
	<p dir="ltr">
		De Granada a Casablanca<br/>
		Entre ritmo y fantasía<br/>
		Una guitarra y un gitano cantan<br/>
		Cantan mi Andalucía<br/>
		Al llegar en Casablanca<br/>
		tu me bailas en la playa<br/>
		con tus ojos negros chiquita<br/>
		y con tu boca enamorada<br/>
		enamorada como tú<br/>
		enamorada como tú<br/>
		enamorada como tú<br/>
		como tú, como tú, no hay nadie como tú...
	</p>
	<p class="arb">
		يلا بينا يلا<br/>
		يا حبيبي يلا<br/>
		نفرح ونقول ماشاء الله<br/>
	 </p>
	 <p class="arb">
		يلا بينا على طول<br/>
		اللي بينا يطول<br/>
		يلا بينا على طول، اللي بينا يطول<br/>
		يا عيني، ويلي ويلي<br/>
		ويلي ويلي، قولو ان شالله
	</p>
	<p dir="ltr">
		De Granada a Casablanca<br/>
		Entre ritmo y fantasía<br/>
		Una guitarra y un gitano cantan<br/>
		Cantan mi Andalucía<br/>
	</p>
	<p class="arb">
		عيونك حلوة<br/>
		شفايفك غنوة<br/>
		عيونك حلوة<br/>
		شفايفك غنوة<br/>
		آه يا ليلي، ويلي ويلي<br/>
		ويلي ويلي، قولو انشالله<br/>
	</p>
</div>





<br />
<!--#include file="inc/trailer.asp"-->