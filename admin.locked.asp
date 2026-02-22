<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
  if session("role") < 14 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "login.asp"
  end if 
  
  dim unlockWord,wordID

  unlockWord = request("unlock")
  wordID = request("id")

  if unlockWord="true" then

    'openDB "arabicWords"
    openDbLogger "arabicWords","O","admin.locked.asp","unlock","" 

    mySQL = "UPDATE words SET lockedUTC='' WHERE id="&wordID
        'response.write "<BR>"&mySQL
        'response.END
		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128

    'closeDB
    closeDbLogger "arabicWords","C","admin.locked.asp","unlock",durationMs,"" 'inc.asp 


    session("msg") = "ערך מספר "&wordID&" נפתח לעריכה"
    response.redirect ("admin.locked.asp")

  end if %>
<!DOCTYPE html>
<html>
<head>
    <title>ערכים נעולים</title>
	<meta name="robots" content="noindex" />
    <!--#include file="inc/header.asp"-->
  	<link rel="stylesheet" href="assets/css/arabic_utils.css" />
    <style>
    #lockTable {
        background:white;
        margin-top:10px;
        width:100%;
    }

    #lockTable th {
        background:whitesmoke;
    }

    #lockTable td {
        border:1px solid lightgray;
        padding: 1px 6px;
    }
    </style>
</head>
<body dir="rtl">
<!--#include file="inc/top.asp"-->

<div id="bread">
	<a href="admin.asp">admin</a> / 
    <h1>ערכים נעולים</h1>
</div>

<div>
    <div><% response.write request("unlock") %></div>
    <div><% response.write request("id") %></div>
</div>

<table id="lockTable">
    <tr>
        <th>id</th>
        <th>lockedUTC</th>
        <th>hebrewTranslation</th>
        <th>arabic</th>
        <th>arabicWord</th>
        <th>action</th>
    </tr><%

'openDB "arabicWords"
openDbLogger "arabicWords","O","admin.locked.asp","read","" 

mySQL = "SELECT id,lockedUTC,hebrewTranslation,arabic,arabicWord FROM words WHERE len(lockedUTC)>1 ORDER BY lockedUTC DESC"
res.open mySQL, con
do until res.EOF %>
    <tr>
        <td style="text-align:center;"><%=res("id")%></td>
        <td style="text-align:left;"><%=res("lockedUTC")%></td>
        <td><%=res("hebrewTranslation")%></td>
        <td><%=res("arabic")%></td>
        <td><%=res("arabicWord")%></td>
        <td style="text-align:center;"><a href="admin.locked.asp?unlock=true&id=<%=res("id")%>">unlock</td>
    </tr><%
    res.moveNext
loop
res.close 

'closeDB
closeDbLogger "arabicWords","C","admin.locked.asp","read",durationMs,"" 'inc.asp %>

</table>


<!--#include file="inc/trailer.asp"-->