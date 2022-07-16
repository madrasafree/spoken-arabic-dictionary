<!DOCTYPE html>
<html>
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
</head>
<body><%
dim returnTo
returnTo = request("returnTo")
response.redirect "team/login.asp?returnTo="&returnTo %>


</body>
</html>