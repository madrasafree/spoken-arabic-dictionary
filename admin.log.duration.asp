<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<!DOCTYPE html>
<html>
<head>
    <title>log - server request duration</title>
	<meta name="robots" content="noindex" />
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/arabic_utils.css" />
    <style>
    .logger {
        font-size:small;
        margin:30px auto;
        width:1000px;
    }
    .logger td {
        border-bottom:1px solid gray;
        padding:3px 10px;
    }
    .mark td {
        background:yellow;
    }
    .mark > .ms {
        font-weight:bold;
    }
    .open {
        background: #2bb8e22b;
        color: #66929e;
    }
    .close {
        color: #c14a4a;
        text-align:right;
    }
    </style>
</head>
<body dir="rtl">
<!--#include file="inc/top.asp"-->


<div id="bread">
	<a href="admin.asp">admin</a> / 
    <h1>Log - Server Request Duration</h1>
</div>

<table dir="ltr" class="logger">
    <tr>
        <td>id</td>
        <td>opType</td>
        <td>afDB</td>
        <td>afPage</td>
        <td>opNum</td>
        <td>userIP</td>
        <td>opTimestamp</td>
        <td>durationMs</td>
        <td>sStr</td>
    </tr><%

dim clsSet,opType

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","admin.log.duration.asp","words",""

mySQL = "SELECT TOP 200 * FROM log WHERE opType='c' ORDER BY id DESC"
res.open mySQL, con
do until res.EOF 
    clsSet = ""
    opType = ""
    if res("opType")="C" then opType="close" else opType="open"
    if res("durationMs")>500 then clsSet="mark" %>
    <tr class="<%=clsSet%>">
        <td><%=res("id")%></td>
        <td class="<%=opType%>"><%=opType%></td>
        <td><%=res("afDB")%></td>
        <td><%=res("afPage")%></td>
        <td><%=res("opNum")%></td>
        <td><%=res("userIP")%></td>
        <td><%=res("opTimestamp")%></td>
        <td class="ms"><%=res("durationMs")%></td>
        <td><%=res("sStr")%></td>
    </tr>
    <%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","admin.log.duration.asp","words",durationMs,"" 'inc.asp 
%>
</table>


<table dir="ltr" class="logger">
    <tr>
        <td>id</td>
        <td>opType</td>
        <td>afDB</td>
        <td>afPage</td>
        <td>opNum</td>
        <td>userIP</td>
        <td>opTimestamp</td>
        <td>durationMs</td>
        <td>sStr</td>
    </tr><%


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.log.duration.asp","users",""

mySQL = "SELECT TOP 50 * FROM log WHERE opType='c' ORDER BY id DESC"
res.open mySQL, con
do until res.EOF 
    clsSet = ""
    opType = ""
    if res("opType")="C" then opType="close" else opType="open"
    if res("durationMs")>500 then clsSet="mark" %>
    <tr class="<%=clsSet%>">
        <td><%=res("id")%></td>
        <td class="<%=opType%>"><%=opType%></td>
        <td><%=res("afDB")%></td>
        <td><%=res("afPage")%></td>
        <td><%=res("opNum")%></td>
        <td><%=res("userIP")%></td>
        <td><%=res("opTimestamp")%></td>
        <td class="ms"><%=res("durationMs")%></td>
        <td><%=res("sStr")%></td>
    </tr>
    <%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.log.duration.asp","users",durationMs,"" 'inc.asp 
%>
</table>

<table dir="ltr" class="logger">
    <tr>
        <td>id</td>
        <td>opType</td>
        <td>afDB</td>
        <td>afPage</td>
        <td>opNum</td>
        <td>userIP</td>
        <td>opTimestamp</td>
        <td>durationMs</td>
        <td>sStr</td>
    </tr><%


startTime = timer()
'openDB "arabicSearch"
openDbLogger "arabicSearch","O","admin.log.duration.asp","search",""

mySQL = "SELECT TOP 100 * FROM log WHERE opType='c' ORDER BY id DESC"
res.open mySQL, con
do until res.EOF 
    clsSet = ""
    opType = ""
    if res("opType")="C" then opType="close" else opType="open"
    if res("durationMs")>500 then clsSet="mark" %>
    <tr class="<%=clsSet%>">
        <td><%=res("id")%></td>
        <td class="<%=opType%>"><%=opType%></td>
        <td><%=res("afDB")%></td>
        <td><%=res("afPage")%></td>
        <td><%=res("opNum")%></td>
        <td><%=res("userIP")%></td>
        <td><%=res("opTimestamp")%></td>
        <td class="ms"><%=res("durationMs")%></td>
        <td><%=res("sStr")%></td>
    </tr>
    <%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSearch","C","admin.log.duration.asp","search",durationMs,"" 'inc.asp 
%>
</table>

<table dir="ltr" class="logger">
    <tr>
        <td>id</td>
        <td>opType</td>
        <td>afDB</td>
        <td>afPage</td>
        <td>opNum</td>
        <td>userIP</td>
        <td>opTimestamp</td>
        <td>durationMs</td>
        <td>sStr</td>
    </tr><%


startTime = timer()
'openDB "arabicSchools"
openDbLogger "arabicSchools","O","admin.log.duration.asp","schools",""

mySQL = "SELECT TOP 50 * FROM log WHERE opType='c' ORDER BY id DESC"
res.open mySQL, con
do until res.EOF 
    clsSet = ""
    opType = ""
    if res("opType")="C" then opType="close" else opType="open"
    if res("durationMs")>500 then clsSet="mark" %>
    <tr class="<%=clsSet%>">
        <td><%=res("id")%></td>
        <td class="<%=opType%>"><%=opType%></td>
        <td><%=res("afDB")%></td>
        <td><%=res("afPage")%></td>
        <td><%=res("opNum")%></td>
        <td><%=res("userIP")%></td>
        <td><%=res("opTimestamp")%></td>
        <td class="ms"><%=res("durationMs")%></td>
        <td><%=res("sStr")%></td>
    </tr>
    <%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSchools","C","admin.log.duration.asp","schools",durationMs,"" 'inc.asp 
%>
</table>



<table dir="ltr" class="logger">
    <tr>
        <td>id</td>
        <td>opType</td>
        <td>afDB</td>
        <td>afPage</td>
        <td>opNum</td>
        <td>userIP</td>
        <td>opTimestamp</td>
        <td>durationMs</td>
        <td>sStr</td>
    </tr><%

startTime = timer()
'openDB "arabicSandbox"
openDbLogger "arabicSandbox","O","admin.log.duration.asp","sandbox",""

mySQL = "SELECT TOP 50 * FROM log WHERE opType='c' ORDER BY id DESC"
res.open mySQL, con
do until res.EOF 
    clsSet = ""
    opType = ""
    if res("opType")="C" then opType="close" else opType="open"
    if res("durationMs")>500 then clsSet="mark" %>
    <tr class="<%=clsSet%>">
        <td><%=res("id")%></td>
        <td class="<%=opType%>"><%=opType%></td>
        <td><%=res("afDB")%></td>
        <td><%=res("afPage")%></td>
        <td><%=res("opNum")%></td>
        <td><%=res("userIP")%></td>
        <td><%=res("opTimestamp")%></td>
        <td class="ms"><%=res("durationMs")%></td>
        <td><%=res("sStr")%></td>
    </tr>
    <%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicSandbox","C","admin.log.duration.asp","sandbox",durationMs,"" 'inc.asp 
%>
</table>


<table dir="ltr" class="logger">
    <tr>
        <td>id</td>
        <td>opType</td>
        <td>afDB</td>
        <td>afPage</td>
        <td>opNum</td>
        <td>userIP</td>
        <td>opTimestamp</td>
        <td>durationMs</td>
        <td>sStr</td>
    </tr><%

startTime = timer()
'openDB "arabicManager"
openDbLogger "arabicManager","O","admin.log.duration.asp","manager",""

mySQL = "SELECT TOP 50 * FROM log WHERE opType='c' ORDER BY id DESC"
res.open mySQL, con
do until res.EOF 
    clsSet = ""
    opType = ""
    if res("opType")="C" then opType="close" else opType="open"
    if res("durationMs")>500 then clsSet="mark" %>
    <tr class="<%=clsSet%>">
        <td><%=res("id")%></td>
        <td class="<%=opType%>"><%=opType%></td>
        <td><%=res("afDB")%></td>
        <td><%=res("afPage")%></td>
        <td><%=res("opNum")%></td>
        <td><%=res("userIP")%></td>
        <td><%=res("opTimestamp")%></td>
        <td class="ms"><%=res("durationMs")%></td>
        <td><%=res("sStr")%></td>
    </tr>
    <%
    res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicManager","C","admin.log.duration.asp","manager",durationMs,"" 'inc.asp 
%>
</table>



<!--#include file="inc/trailer.asp"-->