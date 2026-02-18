<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
  if session("role") < 14 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "login.asp"
  end if %>
<!DOCTYPE html>
<html>
<head>
    <title>מוניטור</title>
	<meta name="robots" content="noindex" />
    <!--#include file="inc/header.asp"-->
  	<link rel="stylesheet" href="css/arabic_utils.css" />
    <style>
        .mdb {
            border:1px solid gray;
            margin:20px auto;
            width:800px;
        }
        .mdb th {
            background:#8080803b;
        }
        .mdb td {
            border-bottom:1px dotted gray;
        }
    </style>      
</head>
<body dir="rtl">
<!--#include file="inc/top.asp"-->

<div id="bread">
	<a href="admin.asp">admin</a> / 
    <h1>Monitor</h1>
</div>

<%

dim listsCnt,viewsSum,viewsAvg,dateA,dateB

listsCnt = 0
viewsAvg = 0
viewsSum = 0

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","admin.monitors.asp","m1",""

mySQL = "SELECT viewCNT FROM lists WHERE viewCNT > 0"
res.open mySQL, con
do until res.EOF
    viewsSum = viewsSum + res("viewCNT")
    listsCnt = listsCnt + 1
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","admin.monitors.asp","m1",durationMs,"" 'inc.asp

response.write "<br><br><br>viewsSum = "&viewsSum
response.write "<br>listsCnt = "&listsCnt
viewsAvg = viewsSum / listsCnt 

response.write "<br>viewsAvg = "&viewsAvg%>
<div class="table" dir="ltr">
    <h2>M1 - Lists view counter</h2>
    <ul>
        <li>List Counter = <%=listsCnt%></li>
        <li>Views Summary = <%=formatNumber(viewsSum,0)%></li>
        <li>Views Average = <%=formatNumber(viewsAvg,0)%></li>
    </ul><%
    if request("email")<>"sent" then %>
        <button onclick="location.href='admin.monitors.email.php?listsAvgVC=<%=formatNumber(viewsAvg,0)%>'">Send email</button><%
    else %>
        <mark>email sent!</mark><%
    end if %>
</div>

<div class="table">
    <mark>GMT now is <%=AR2UTC(now())%></mark>
</div>

<table class="mdb">
    <tr>
        <th>mID</th>
        <th>status</th>
        <th>actionUTC</th>
        <th>hours</th>
    </tr><%

startTime = timer()
'openDB "arabicLogs"
openDbLogger "arabicLogs","O","admin.monitors.asp","mdb",""

mySQL = "SELECT * FROM monitors"
res.open mySQL, con
do until res.EOF 
    dateA = replace(left(res("actionUTC"),19),"T"," ")
    dateB = replace(left(AR2UTC(now()),19),"T"," ")%>
    <tr>
        <td><%
            Select CASE res("mID")
                case 1 %> מונה רשימות אישיות <%
                case ELSE %> <span style="color:red;">אחר</span> <%
            END Select
            %> (<%=res("mID")%>)</td>
        <td><%
            Select CASE res("status")
                case 1 %> תקין <%
                case ELSE %> <span style="color:red;">אחר</span> <%
            END Select
            %></td>
        <td><%=res("actionUTC")%></td>
        <td><%=dateDiff("h",dateA,dateB)%></td>
    </tr><%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicLogs","C","admin.monitors.asp","mdb",durationMs,"" 'inc.asp %>

</table>

<!--#include file="inc/trailer.asp"-->