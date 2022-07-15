<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<html>
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">
    <meta charset="UTF-8">
    <style>
    body {font-size:large;}
    </style>
</head>

<body>
<div style="max-width:600px; margin:0 auto;">

	<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
	<input type="hidden" name="cmd" value="_s-xclick">
	<input type="hidden" name="hosted_button_id" value="BP9HZ5Y4SUYKG">
	<table>
	<tr><td><input type="hidden" name="on0" value="כמה כל חודש?">כמה כל חודש?</td></tr><tr><td><select name="os0">
		<option value="A">A : ₪30.00 ILS - monthly</option>
		<option value="B">B : ₪50.00 ILS - monthly</option>
		<option value="C">C : ₪100.00 ILS - monthly</option>
		<option value="D">D : ₪250.00 ILS - monthly</option>
	</select> </td></tr>
	</table>
	<input type="hidden" name="currency_code" value="ILS">
	<input type="image" src="https://www.paypalobjects.com/he_IL/IL/i/btn/btn_subscribeCC_LG.gif" border="0" name="submit" alt="PayPal - הדרך הקלה והבטוחה יותר לשלם באינטרנט!">
	<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
	</form>




</div>
</body>
</html>