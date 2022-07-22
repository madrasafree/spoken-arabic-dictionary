<!DOCTYPE html>
<html>
<head>
	<title>Mail to verify user's email</title>
	<meta charset='utf-8'>
</head>
<body>

<?php
$hebrewName = $_GET['hebrewName'];
$email = $_GET['eMail'];
$emailvcode = $_GET['eMailVCode'];
$maxID = $_GET['maxId'];
echo "<br/>hebrewName = ";
echo $hebrewName;
echo "<br/>email = ";
echo $email;
echo "<br/>emailvcode = ";
echo $emailvcode;
echo "<br/>maxID = ";
echo $maxID;
//exit;

$msg = "<!DOCTYPE html>";
$msg .= "<html>";
$msg .= "<head>";
$msg .= "<meta charset='UTF-8'";
$msg .= "<title>מייל אוטומטי ממילון ערבית מדוברת</title>";
$msg .= "<meta name='viewport' content='width=device-width'";
$msg .= "</head>";
$msg .= "<body dir='rtl' style='margin:0; padding:0;'>";
$msg .= "<div style='background-image: url('https://image.ibb.co/kb26BG/diagBlue.png'); background-repeat:repeat;'";
$msg .= "<div style='margin:0 auto; max-width:600px;text-align:center;";
$msg .= "<img src='https://image.ibb.co/gW4Q5b/2016_12_01_TEAM_facebook_group_cover.jpg' style='display:block; max-width:100%; padding:12px 0;' width='600'";
$msg .= "<div>$hebrewname שלום!</div>";
$msg .= "<br/>";
$msg .= "<div>קיבלנו את בקשתך להצטרף למילון. על מנת שהמשתמש שלך יוכל להוסיף ערכים, יש קודם לאשר שזהו אכן המייל שלך. כדי לעשות זאת, לחץ על הקישור הבא: ";
$msg .= "<a href='http://ronen.rothfarb.info/arabic/team/user.verifyEmail.asp?verify=true?email=$email?emailvcode=$emailvcode'>אשר מייל</a>";
$msg .= "<br/>";
$msg .= "<br/>או לחלופין, התחבר למילון והזן את הקוד הבא: $emailvcode";
$msg .= "<br/>";
$msg .= "<div>במידה ולא ביקשתם להצטרף למילון, ואתם מנועיינים לחסום אפשרות להשתמש במייל זה בעתיד, ליחצו כאן: ";
$msg .= "<a href='http://ronen.rothfarb.info/arabic/team/user.verifyEmail.asp?verify=block?email=$email'>חסום רישום עתידי עם המייל הנל.</a>";
$msg .= "<br/>";
$msg .= "<div>בברכה, רונן רוטפרב ומתנדבי המילון</div>";
$msg .= "<br/><br/>";
$msg .= "<div><a href='https://www.facebook.com/spoken.arabic.dictionary'>דף הפייסבוק של המילון</a></div>";
$msg .= "<div><a href='https://www.facebook.com/groups/1795781623996083'>קבוצת המתנדבים בפייסבוק</a></div>";
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

$subject = "אשרו כתובת מייל כדי להוסיף מילים למילון";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";
$headers .= 'Cc: yaniv@madrasafree.com' . "\r\n";


// send email
mail($email,$subject,$msg,$headers);

// Redirect browser
header("Location: http://ronen.rothfarb.info/arabic/profile.asp?id=$maxID");
exit();
?>

</body>
</html>