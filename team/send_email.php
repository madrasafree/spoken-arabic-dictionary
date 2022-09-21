<!DOCTYPE html>
<html>
<head>
	<title>Mail upon new entry</title>
	<meta charset="UTF-8">
</head>	
<body>

<?php
$wordID = $_GET['wordID'];
$arabic = $_GET['arabic'];
$username = $_GET['username'];
$userEmail = "admin@madrasafree.com";

$msg = "<html><body dir='rtl' style='background:#dddddd;'>";
$msg .= "<div>$username שלום!</div>";
$msg .= "<br/>";
$msg .= "<div>זהו מייל אוטומטי המאשר שהוספת את המילה ";
$msg .= "<a href='https://milon.madrasafree.com/word.asp?id=$wordID'>$arabic (מספר סידורי $wordID)</a>";
$msg .= " בהצלחה למילון.";
$msg .= "<div>תודה רבה על תרומתך למילון!</div>";
$msg .= "<br/>";
$msg .= "<div>בברכה, רונן רוטפרב</div>";
$msg .= "<br/><br/>";
$msg .= "<div><a href='https://www.facebook.com/spoken.arabic.dictionary'>דף הפייסבוק של המילון</a></div>";
$msg .= "<div><a href='https://www.facebook.com/groups/1795781623996083'>קבוצת המתנדבים בפייסבוק</a></div>";
$msg .= "<br/><br/>";
$msg .= "<div>להערות לגבי מייל אוטומטי זה, אנא כיתבו לנו למייל admin@madrasafree.com</div>";
$msg .= "</body></html>";
// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);
//echo $msg;

$subject .= "הוספת מילה בהצלחה! ";
$subject .= "- מס''ד $wordID ";

$from_mail = "admin@madrasafree.com";
//$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";
//$headers .= 'Cc: admin@madrasafree.com' . "\r\n";

// send email
mail($userEmail,$subject,$msg,$headers);

// Redirect browser
header("Location: https://milon.madrasafree.com/word.asp?id=$wordID");

exit();
?>
  
</body>
</html>