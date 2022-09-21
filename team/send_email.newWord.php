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

$msg = "<html><body>";
$msg .= "<div>AUTOMATIC EMAIL: ";
$msg .= "<div>The user $username has added a <a href='https://milon.madrasafree.com/word.asp?id=$wordID'>new word</a> to the dictionary</div>";
$msg .= "<div>Arabic : $arabic</div>";
$msg .= "<div>wordID : $wordID</div>";
$msg .= "</body></html>";

// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);
//echo $msg;

$subject = "wordID $wordID added by $username";

//$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";

// send email
mail($userEmail,$subject,$msg,$headers);

// Redirect browser
header("Location: https://milon.madrasafree.com/word.asp?id=$wordID");
exit();
?>
  
</body>
</html>