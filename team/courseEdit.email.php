<!DOCTYPE html>
<html>
<head>
	<title>mail upon editing a course entry</title>
	<meta charset="UTF-8">
</head>	
<body>

<?php
$cID = $_GET['cID'];
$cTitle = $_GET['cTitle'];
$userID = $_GET['userID'];

$msg = "<html><body><table>";
$msg .= "<tr><td>Course ID</td><td>$cID</td></tr>";
$msg .= "<tr><td>Course Title</td><td>$cTitle</td></tr>";
$msg .= "<tr><td>User ID</td><td>$userID</td></tr>";
$msg .= "</table></body></html>";
// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);
//echo $msg;

$subject = "עריכת קורס קיים : ";
$subject .= "$cTitle";

$headers = "Content-Type: text/html; charset=UTF-8\r\n";
//$headers = "Content-Type: text/html; charset=ISO-8859-1\r\n";

// send email
mail("arabic4hebs@gmail.com",$subject,$msg,$headers);

// Redirect browser
header("Location: http://ronen.rothfarb.info/arabic/where2learn.asp");
exit();
?>
  
</body>
</html>