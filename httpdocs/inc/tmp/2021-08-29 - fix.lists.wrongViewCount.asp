<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html>
<head>
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
    <style>
        td {
            border-bottom:1px solid gray;
            padding:4px;
            }
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="bread">
	<a href=".">מילון</a> / <%
	if session("userID")=1 then %>
	<a href="admin.asp">ניהול</a> / <%
	end if %>
    <h1>TEMP - lists - fix wrong view count</h1>
</div>

<table style="width:100%;">
    <tr style="font-weight:bold;">
        <td>id</td>
        <td>viewCNT</td>
        <td>tmpOriginal</td>
        <td>tmpExtra (db)</td>
        <td>tmpCurrent (db)</td>
    </tr>

<%

openDB "arabicWords"
mySQL = "SELECT * FROM lists"
res.open mySQL, con
do until res.EOF %>
    <tr>
        <td><%=res("id")%></td>
        <td><%=res("viewCNT")%></td>
        <td><%=res("tmpOriginal")%></td>
        <td><%=res("tmpExtra")%></td>
        <td><%=res("tmpCurrent")%></td>
    </tr><%

    'UPDATE SEARCH STRING

    ' mySQL = "UPDATE lists SET viewCNT="&res("tmpExtra")+res("tmpOriginal")&" WHERE id="&res("id")
    ' cmd.CommandType=1
    ' cmd.CommandText=mySQL
    ' Response.Write "<div dir='ltr'>"& mySQL&"</div>"
    ' Set cmd.ActiveConnection=con
    ' cmd.execute ,,128

    'Response.End



    res.moveNext
loop
res.close

closeDB %>
</table>
<!--#include file="inc/trailer.asp"--><%
%>