<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
	<title>צוות מילון - דף ראשי</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
    <style>
        h2 {font-size:1em;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<!--#include file="inc/topTeam.asp"--> <%

dim iMsg, iConf, sch, SendEmailGmail

if Len(Request.Form("email")) > 0 then
	Set iMsg = CreateObject("CDO.Message")
	Set iConf = CreateObject("CDO.Configuration")

	' send one copy with Google SMTP server (with autentication)
	sch = "http://schemas.microsoft.com/cdo/configuration/"
	With iConf.Fields
		.Item(sch & "smtpauthenticate") = 1
		.Item(sch & "smtpusessl") = True
		.Item(sch & "smtpserver") = "smtp.gmail.com" 
		.Item(sch & "sendusername") = "choyce.info@gmail.com"
		.Item(sch & "sendpassword") = "Dellgpt#3"
		.Item(sch & "smtpserverport") = 465
		.Item(sch & "sendusing") = 2
		.Item(sch & "connectiontimeout") = 100
		.Update
	End With

	With iMsg
		Set .Configuration = iConf
		.To = "ronen@mhcolor.com"
		.CC = "kanija@gmail.com"
		.From = "mhcolor.com contact <smtp@mhcolor.com>"
		.Subject = "יצירת קשר מהאתר"
		.HTMLBody = "<div dir=""rtl""><table style=""width:600px;border:solid 1px gray;"">" & _
			"<tr><td style=""width:120px;"">" & "שם השולח: " & "</td><td>" &  Request.Form("firstname")&" "& Request.Form("lastname") & _
			"</td></tr><tr><td>" & "טלפון: " & "</td><td>" & Request.Form ("phone") & _
			"</td></tr><tr><td>" & "מייל: " & "</td><td>" & Request.Form ("email") & _
			"</td></tr></table><blockquote>" & Request.Form ("body") & _
			"</blockquote></div>" & _
			"<table><tr><td>" & "Agent: " & "</td><td>" & Request.ServerVariables("HTTP_USER_AGENT")  & _
			"</td></tr><tr><td>" & "Resolution: " & "</td><td>" & Request.Form ("resolution") & _
			"</td></tr></table>"
		'.TextBody = Request.Form ("body") & vbNewLine & "Phone: " & Request.Form ("phone")
		'.Sender = 
		'.Organization = "Myname"
		.ReplyTo = Request.Form("firstname")&" "& Request.Form("lastname")&"<"&Request.Form("email")&">"
		SendEmailGmail = .Send
	End With

	set iMsg = nothing
	set iConf = nothing

end if %>

<div id="pTitle">
    <h2>הודעתכם נשלחה בהצלחה</h2>
</div>

    <!--#include file="inc/trailer.asp"-->
    </body>
    </html>