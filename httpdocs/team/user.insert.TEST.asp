<%

Response.write "<br/>request.ServerVariables(SERVER_NAME) = "&request.ServerVariables("SERVER_NAME")
response.end


dim hebrewName,eMail,eMailVCode,maxId
hebrewName = "רונן"
eMail = "kanija@gmail.com"
eMailVCode = "1234"
maxId = "1"

	Response.Redirect "send_email_verify.php?&hebrewName="+hebrewName+"&eMail="&eMail&"&eMailVCode="&eMailVCode&"&maxId="&maxId
 %>
