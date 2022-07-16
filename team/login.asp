<!DOCTYPE html>
<html>
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
</head>
<body><%
dim returnTo
returnTo = replace(request("returnTo"),"'","")
response.redirect "../login.asp?returnTo="&returnTo %>


</body>
</html>