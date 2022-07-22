<%

response.write "HELLO WORLD"
'response.end

'2021 - Acording to https://stackoverflow.com/questions/57500626/sending-email-with-classic-asp-through-godaddy

Dim objNewMail

    'Your email information
    Set objNewMail = Server.CreateObject("CDO.Message")
    objNewMail.From = "yaniv@madrasafree.com"
    objNewMail.To   = "kanija@gmail.com"
    objNewMail.Subject = "This is a test email"
    objNewMail.TextBody = "this is a test email"

    ' GoDaddy SMTP Settings
    objNewMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
    objNewMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="relay-hosting.secureserver.net"
    objNewMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25 
    objNewMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
    'objNewMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/cdoSendUserName") = "your-primary-website-username"
    'objNewMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/cdoSendPassword") = "your-primary-website-password"
    objNewMail.Configuration.Fields.Update
    objNewMail.Send

    'After the Send method, NewMail Object become Invalid
    Set objNewMail = Nothing





'2017 below

' Set myMail = CreateObject("CDO.Message")
' myMail.Subject = "Sending email with CDO"
' myMail.From = "ronen@rothfarb.info"
' myMail.To = "kanija@gmail.com"
' myMail.TextBody = "This is a message."
' 'myMail.Send
' set myMail = nothing


' session("msg")="test msg sent"
' response.end
' response.redirect "."
%>