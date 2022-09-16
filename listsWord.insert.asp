<!--#include file="inc/inc.asp"--><%
If (session("role")<2) then 
    session("msg") = "אין לך הרשאה מתאימה"
    Response.Redirect Request.ServerVariables("HTTP_REFERER")
end if


openDB "arabicUsers"
    'Checks if READ ONLY mode is Enabled
    mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readonly'"
    res.open mySQL, con
    if res(0) = true then
        session("msg") = "אין כרגע אפשרות לערוך רשימות. אנא נסו שנית מאוחר יותר"
        Response.Redirect Request.ServerVariables("HTTP_REFERER")
    end if
    res.close
closeDB

 %>
<!DOCTYPE html>
<html>
<head>
	<title>הוספת מילה לרשימה</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<div style="padding:20px;">
<!--#include file="inc/time.asp"--><%

dim listID,wordID,maxPos,lastUpdateUTC

listID = Request("listID")
response.write "<br/>listID = "&listID
wordID = Request("wordID")
response.write "<br/>wordID = "&wordID


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","listsWord.insert.asp","single",""

'limit list to '300' items'
mySQL = "SELECT count(wordID) FROM wordsLists WHERE listID="&listID
res.open mySQL, con
response.write "<br/>res(0) = " & res(0)
'response.end
	if res(0)>399 then
		session("msg") = "אין מקום למילים נוספות ברשימה זו"
		response.Redirect Request.ServerVariables("HTTP_REFERER")
	end if
res.close

'check if word already in list'
mySQL = "SELECT wordID FROM wordsLists WHERE listID="&listID&" AND wordID="&wordID
response.write "<br/>mySQL = "&mySQL
'Response.End
res.open mySQL, con
if NOT res.EOF then
	session("msg") = "המילה כבר קיימת ברשימה זו"
	Response.Redirect "lists.asp?id="&listID
end if
res.close

'get max pos(position) from list'
mySQL = "SELECT max(pos) FROM wordsLists WHERE listID="&listID
response.write "<br/>mySQL = "&mySQL
'Response.End
res.open mySQL, con
if len(res(0))>1 then
	response.write "<br/>old max pos = "&res(0)
	maxPos = res(0)+1
else
	response.write "<br/>no max pos"
	maxPos = 1
end if
res.close
response.write "<br/>new max pos = "&maxPos


mySQL = "INSERT INTO wordsLists (listID,wordID,pos) VALUES ("&listID&","&wordID&","&maxPos&")"

response.write "<br/>mySQL = "&mySQL
'Response.End
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

lastUpdateUTC = AR2UTC(now())

mySQL = "UPDATE lists SET lastUpdateUTC = '"&lastUpdateUTC&"' WHERE id="&listID
response.write mySQL
'response.end
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","listsWord.insert.asp","single",durationMs,""


session("msg") = "המילה נוספה לרשימה בהצלחה"
Response.Redirect "lists.asp?id="&listID %>
</div>
</body>
</html>