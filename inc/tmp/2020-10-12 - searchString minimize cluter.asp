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
    <h1>TEMP</h1>
</div>

<ol>
    <li>להסיר | בהתחלה ובסוף של המחרוזת</li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
</ol>

<table>
    <tr style="font-weight:bold;">
        <td>id</td>
        <td>hebrewClean</td>
        <td>arabicClean</td>
        <td>arabicHebClean</td>
        <td>searchString</td>
        <td>split</td>
        <td>newString</td>
    </tr>

<%

dim strSplit,strSeg,strSegTmp,newString,shavim

openDB "arabicWords"
mySQL = "SELECT * FROM words WHERE len(searchString)>1 AND id > 49"
res.open mySQL, con
do until res.EOF %>
    <tr>
        <td><%=res("id")%></td>
        <td><%=res("hebrewClean")%></td>
        <td><%=res("arabicClean")%></td>
        <td><%=res("arabicHebClean")%></td>
        <td><%=res("searchString")%></td>
        <td><%
        newString = ""
        shavim = false
        strSplit = Split(res("searchString"),"|")
        for each strSeg in strSplit
            if len(strSeg)>0 then
                strSegTmp = replace(strSeg," ","")
                if strSegTmp = res("hebrewClean") or strSeg = res("arabicClean") or strSeg = res("arabicHebClean") then
                    response.write(strSeg & "<br>")
                else
                    newString = newString + strSeg + "|"
                end if
            end if
        next
        if newString<>"" then newString = left(newString,len(newString)-1)
        %></td>
        <td><%=newString%></td>
    </tr><%

    'UPDATE SEARCH STRING
    mySQL = "UPDATE words SET searchString='"&newString&"' WHERE id="&res("id")
    cmd.CommandType=1
    cmd.CommandText=mySQL
    Response.Write "<div dir='ltr'>"& mySQL&"</div>"
    Set cmd.ActiveConnection=con
    cmd.execute ,,128

    'Response.End



    res.moveNext
loop
res.close

closeDB %>
</table>
<!--#include file="inc/trailer.asp"--><%

session("msg") = "UPDATE ENDED. Last newString was "&newString

response.redirect "."%>