<!--#include file="inc/inc.asp"--><%
If (session("role")<2) then 
    session("msg") = "אין לך הרשאה מתאימה"
    Response.Redirect Request.ServerVariables("HTTP_REFERER")
end if %>
<!DOCTYPE html>
<html>
<head>
	<title>הסרת מילה מרשימה</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<div style="padding:20px;">
<!--#include file="inc/time.asp"--><%

dim listID,wordID,lastUpdateUTC

listID = Request("listID")
response.write "<br/>listID = "&listID
wordID = Request("wordID")
response.write "<br/>wordID = "&wordID


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","listsWord.remove.asp","single",""


mySQL = "DELETE FROM wordsLists WHERE listID="&listID&" AND wordID="&wordID
response.write "<br/>mySQL = "&mySQL
'Response.End
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


lastUpdateUTC = AR2UTC(now())

mySQL = "UPDATE lists SET lastUpdateUTC='"&lastUpdateUTC&"' WHERE id="&listID
response.write mySQL
'response.end
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","listsWord.remove.asp","single",durationMs,""


session("msg") = "מילה "&wordID&" הוסרה מהרשימה בהצלחה"
'Response.Redirect request.ServerVariables("http_referer") 
response.redirect "lists.asp?id="&listID 

%>

</div>
</body>
</html>