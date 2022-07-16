<!--#include file="inc/inc.asp"--><%
dim timeServer,timeUtc,timeUtcIso

startTime = timer()
'openDB "arabicSandbox"
openDbLogger "arabicSandbox","O","TEST.time.server.asp","single",""


mySQL = "SELECT now()"
res.open mySQL, con
    timeServer=res(0)
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSandbox","C","TEST.time.server.asp","single",durationMs,""


timeUtcIso = AR2UTC(timeServer)

%>
<!DOCTYPE html>
<!--#include file="inc/time.asp"-->
<html>
<head>
    <title>Sandbox - Time - Show time on server</title>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
</head>
<body>
<table>
    <tr>
        <td><%=mySQL%></td>
        <td><%=timeServer%></td>
    </tr>
    <tr>
        <td>AR2UTC(timeUtc)</td>
        <td><%=timeUtcIso%></td>
    </tr>
</table>
<!--#include file="inc/trailer.asp"-->