<%

response.write "HELLO WORLD"
'response.end

Set myMail = CreateObject("CDO.Message")
myMail.Subject = "Sending email with CDO"
myMail.From = "ronen@rothfarb.info"
myMail.To = "kanija@gmail.com"
myMail.TextBody = "This is a message."
myMail.Send
set myMail = nothing


session("msg")="test msg sent"
'response.end
response.redirect "TEST.emailTimerTMP.asp"
%>