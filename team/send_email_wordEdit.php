<!DOCTYPE html>
<html>
<head>
	<title>Mail upon editing an entry</title>
	<meta charset="UTF-8">
</head>	
<body>

<?php
$wordID = $_GET['wordID'];
$arabic = $_GET['arabic'];
$username = $_GET['username'];
$userEmail = "yaniv@madrasafree.com";

$msg = "<!DOCTYPE html>";
$msg .= "<html>";
$msg .= "<head>";
$msg .= "<meta charset='UTF-8'";
$msg .= "<title>מייל אוטומטי ממילון ערבית מדוברת</title>";
$msg .= "<meta name='viewport' content='width=device-width'";
$msg .= "</head>";
$msg .= "<body dir='rtl' style='margin:0; padding:0;'>";
$msg .= "<div style='background-image: url('https://image.ibb.co/kb26BG/diagBlue.png'); background-repeat:repeat;'>";
$msg .= "<div style='margin:0 auto; max-width:600px;text-align:center;";
$msg .= "<img src='https://image.ibb.co/gW4Q5b/2016_12_01_TEAM_facebook_group_cover.jpg' style='display:block; max-width:100%; padding:12px 0;' width='600'";
$msg .= "<div>$username שלום!</div>";
$msg .= "<br/>";
$msg .= "<div>זהו מייל אוטומטי המאשר שערכת את המילה ";
$msg .= "<a href='https://milon.madrasafree.com/word.asp?id=$wordID'>$arabic (מספר סידורי $wordID)</a>";
$msg .= " בהצלחה.</div>";
$msg .= "<div>תודה רבה על תרומתך למילון!</div>";
$msg .= "<br/>";
$msg .= "<div>בברכה, רונן רוטפרב</div>";
$msg .= "<br/><br/>";
$msg .= "<div><a href='https://www.facebook.com/spoken.arabic.dictionary'>דף הפייסבוק של המילון</a></div>";
$msg .= "<div><a href='https://www.facebook.com/groups/1795781623996083'>קבוצת הפייסבוק של המילון</a></div>";
$msg .= "<br/><br/>";
$msg .= "<div>להערות לגבי מייל אוטומטי זה, אנא כיתבו לנו למייל yaniv@madrasafree.com</div>";
$msg .= "</div>";
$msg .= "</div>";
$msg .= "</body>";
$msg .= "</html>";
$msg .= "";


// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);
//echo $msg;

$subject .= "ערכת מילה בהצלחה! ";
$subject .= "- מס''ד $wordID ";

$from_name = "שרת דואר - מילון ערבית מדוברת";
//$from_mail = "yaniv@madrasafree.com";
//$headers = "From: ".$from_name." <".$from_mail.">\r\n";
//$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";

$headers .= 'From: arabic4hebs <yaniv@madrasafree.com>' . "\r\n" .
    'Reply-To: yaniv@madrasafree.com' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();


// send email
mail($userEmail,$subject,$msg,$headers);

// Redirect browser
header("Location: https://milon.madrasafree.com/word.asp?id=$wordID");

exit();
?>
  
</body>
</html>