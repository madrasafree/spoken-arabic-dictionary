<!DOCTYPE html>
<html>
<head>
	<title>Monitors - email</title>
	<meta charset="UTF-8">
</head>	
<body>

<?php
$listsAvgVC = $_GET['listsAvgVC'];
$userEmail = "admin@madrasafree.com";

$msg = "<html><body>";
$msg .= "<div>MONITORS: ";
$msg .= "<div>The lists average view count is $listsAvgVC.</div>";
$msg .= "</body></html>";

// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);
//echo $msg;

$subject = "ניטור מידע לילי";

//$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";
$headers .= "MIME-Version: 1.0\r\n";


// send email
mail($userEmail,$subject,$msg,$headers);

// Redirect browser
header("Location: https://milon.madrasafree.com/admin.monitors.asp?email='sent'");
exit();
?>
  
</body>
</html>