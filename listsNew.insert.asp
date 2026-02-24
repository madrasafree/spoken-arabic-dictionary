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
        session("msg") = "אין כרגע אפשרות ליצור רשימות חדשות. אנא נסו שנית מאוחר יותר"
        response.Redirect "."
    end if
    res.close
closeDB


 %>
<!DOCTYPE html>
<html>
<head>
	<title>הוספת רשימה חדשה למסד נתונים</title>
    <meta name="robots" content="none">
<!--#include file="includes/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<!--#include file="includes/top.asp"-->
<!--#include file="includes/time.asp"--><%

' Function getString (f)
'     getString = "'" &replace(request(f),"'","&#39;")&"'"
' End function

dim lTitle,lDesc,uploaderID,creationTimeUTC,maxID,lPrivacy,lType

lTitle = gereshFix(request("lTitle"))
lDesc = gereshFix(request("lDesc"))

lPrivacy = 1 'unlisted
'lPrivacy = request("lPrivacy")
lType = 10 'regular
'lType = request("lType")

'openDB "arabicWords"
openDbLogger "arabicWords","O","listsNew.insert.asp","single",""


'check if lTitl already in DB'
mySQL = "SELECT id FROM lists WHERE listName='"&lTitle&"' AND creator="&session("userID")
res.open mySQL, con
if NOT res.EOF then
	session("msg") = "כבר יש לך רשימה עם אותו שם"
	response.Redirect "listsNew.asp"
end if
res.close

uploaderID = session("userID")
creationTimeUTC = AR2UTC(now())

'add SCHOOL here and in FORMS'
mySQL = "INSERT INTO lists (creator,listName,privacy,type,listDesc,creationTimeUTC) VALUES ("&uploaderID&",'"&lTitle&"',"&lPrivacy&","&lType&",'"&lDesc&"','"&creationTimeUTC&"')"

response.write mySQL
'Response.End
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

mySQL = "SELECT max(ID) FROM lists"
res.open mySQL, con
	maxID = res(0)
res.close

'closeDB
closeDbLogger "arabicWords","C","listsNew.insert.asp","single",durationMs,""



session("msg") = "הרשימה נוספה בהצלחה"
Response.Redirect "lists.asp?id="&maxID %>
</div>
</body>
</html>