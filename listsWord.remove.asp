<!--#include file="includes/inc.asp"--><%
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
	<title>הסרת מילה מרשימה</title>
    <meta name="robots" content="none">
<!--#include file="includes/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<div style="padding:20px;">
<!--#include file="includes/time.asp"--><%

dim listID,wordID,lastUpdateUTC

listID = Request("listID")
response.write "<br/>listID = "&listID
wordID = Request("wordID")
response.write "<br/>wordID = "&wordID


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


'closeDB
closeDbLogger "arabicWords","C","listsWord.remove.asp","single",durationMs,""


session("msg") = "מילה "&wordID&" הוסרה מהרשימה בהצלחה"
'Response.Redirect request.ServerVariables("http_referer") 
response.redirect "lists.asp?id="&listID 

%>

</div>
</body>
</html>