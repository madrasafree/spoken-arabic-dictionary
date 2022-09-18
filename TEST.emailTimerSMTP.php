<!DOCTYPE html>
<html>
<head>
	<title>Automatic eMail Test</title>
	<meta charset="UTF-8">
</head>	
<body>

<?php
$wordID = $_GET['wordID'];
//$arabic = $_GET['arabic'];
$uID = $_GET['uID'];
$userEmail = "yaniv@madrasafree.com";

$msg = "<html><body>";
$msg .= "<div>AUTOMATIC EMAIL: ";
$msg .= "<div>The user $uID is following wordID $wordID</div>";
$msg .= "</body></html>";

// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);
//echo $msg;

$subject = "עדכון יומי - ניסיון";

//$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";
$headers .= "MIME-Version: 1.0\r\n";


// send email
mail($userEmail,$subject,$msg,$headers);

// Redirect browser
header("Location: https://milon.madrasafree.com/TEST.emailTimer.asp");
exit();
?>
  
</body>
</html>