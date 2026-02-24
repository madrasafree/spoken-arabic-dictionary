<!--#include file="inc/inc.asp"--><%
    '1=ronen ; 73=yaniv ; 77=hadar ; 103 = ran ; 118 = noam ; 129 = sharon'
    if not (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=103 or session("userID")=118 or session("userID")=129) then Response.Redirect "login.asp" 

openDB "arabicUsers"
    'Checks if READ ONLY mode is Enabled
    mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readonly'"
    res.open mySQL, con
    if res(0) = true then
        session("msg") = "אין כרגע אפשרות לערוך מידע במסד הנתונים. אנא נסו שנית מאוחר יותר"
        Response.Redirect Request.ServerVariables("HTTP_REFERER")
    end if
    res.close
closeDB    
	
	
	%>
<!DOCTYPE html>
<html>
<head>
	<title>הוספת מדיה חדשה למסד נתונים</title>
    <meta name="robots" content="none">
<!--#include file="../inc/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<div style="padding:20px;">
<!--#include file="inc/time.asp"--><%
Function getString (f)
    getString = "'" &replace(request(f),"'","&#39;")&"'"
End function

dim mType,mLink,mDesc,credit,creditLink,speakerID,uploaderID,creationTime

mType = request("mType")
if mType="empty" then
	session("msg") = "לא נבחר סוג המדיה"
	response.Redirect "mediaNew.asp"
end if
mLink = getString("mLink")


'openDB "arabicWords"
openDbLogger "arabicWords","O","mediaNew.insert.asp","single",""

'check if mLink already in DB'
mySQL = "SELECT mType, mLink FROM media WHERE mType="&mType&" AND mLink="&mLink
res.open mySQL, con
if NOT res.EOF then
	session("msg") = "קישור זהה כבר קיים במערכת"
	response.Redirect "mediaNew.asp"
end if
res.close

mDesc = getString("mDesc")
credit = getString("credit")
creditLink = getString("creditLink")
speakerID = request("speaker")
if speakerID = "" then speakerID = 2

uploaderID = session("userID")
creationTime = isrTime() 'add to DB and to INSERT'

'add SCHOOL here and in FORMS'
mySQL = "INSERT INTO media (mType,mLink,description,credit,creditLink,speaker,uploader,creationTime) VALUES ("&mType&","&mLink&","&mDesc&","&credit&","&creditLink&","&speakerID&","&uploaderID&",'"&creationTime&"')"

response.write mySQL
'Response.End
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128


'closeDB
closeDbLogger "arabicWords","C","mediaNew.insert.asp","single",durationMs,""



session("msg") = "המדיה נוספה בהצלחה"

response.redirect "mediaControl.asp" %>
</div>
</body>
</html>