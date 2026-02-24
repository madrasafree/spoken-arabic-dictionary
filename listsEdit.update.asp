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
	<title>עדכון רשימה במסד נתונים</title>
    <meta name="robots" content="none">
<!--#include file="includes/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<!--#include file="includes/top.asp"-->
<!--#include file="includes/time.asp"--><%

' Function getString (f)
'     getString = "'" &replace(request(f),"'","&#39;")&"'"
' End function

dim LID,lTitle,lDesc,uploaderID,lastUpdateUTC,lPrivacy,lType

LID = Request("LID")
lTitle = gereshFix(request("lTitle"))
lDesc = gereshFix(request("lDesc"))

lPrivacy = request("lPrivacy")
lType = request("lType")

'openDB "arabicWords"
openDbLogger "arabicWords","O","listsEdit.update.asp","single",""


'check if lTitle already in DB'
mySQL = "SELECT id FROM lists WHERE listName='"&lTitle&"' AND creator="&session("userID")&" AND NOT id="&LID
response.write "<br>"&mySQL&"<br>"
res.open mySQL, con
if NOT res.EOF then
	session("msg") = "כבר יש לך רשימה עם אותו שם"
	response.Redirect Request.ServerVariables("HTTP_REFERER")
end if
res.close

uploaderID = session("userID")
lastUpdateUTC = AR2UTC(now())

'add SCHOOL here and in FORMS'
mySQL = "UPDATE lists SET creator = "&uploaderID&", "&_
                        "listName = '"&lTitle&"', "&_
                        "privacy = "&lPrivacy&", "&_
                        "type = "&lPrivacy&", "&_
                        "listDesc = '"&lDesc&"', "&_
                        "lastUpdateUTC = '"&lastUpdateUTC&"' "&_
                    "WHERE id="&LID

response.write mySQL
'response.end
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

'closeDB
closeDbLogger "arabicWords","C","listsEdit.update.asp","single",durationMs,""


session("msg") = "הרשימה עודכנה בהצלחה"
Response.Redirect "lists.asp?id="&LID %>
</div>
</body>
</html>