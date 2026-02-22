<!--#include file="inc/inc.asp"--><%
    '1=ronen ; 73=yaniv ; 77=hadar ; 103 = ran ; 118 = noam ; 129 = sharon'
    If not (session("userID")=1 or session("userID")=73 or session("userID")=77 or session("userID")=103 or session("userID")=118 or session("userID")=129) then Response.Redirect "login.asp"



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

'MISSING:
'CREATING MEDIA-HISTORY TABLE IN DB
'INSERTING PREVIOUS DATA INTO THAT TABLE'
 %>
<!DOCTYPE html>
<html>
<head>
	<title>עדכון מדיה קיימת במסד נתונים</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body style="text-align:left; direction: ltr;">
<div style="padding:20px;">
<!--#include file="inc/time.asp"--><%
Function getString (f)
    getString = "'" &replace(request(f),"'","&#39;")&"'"
End function

dim mediaID,mType,mLink,mDesc,credit,creditLink,speakerID,uploaderID,uploadTime

mediaID = request("mID")
mType = request("mType")
mLink = getString("mLink")
mDesc = getString("mDesc")
credit = getString("credit")
creditLink = getString("creditLink")
speakerID = request("speaker")
if speakerID = "" then speakerID = 2

uploaderID = session("userID")
uploadTime = isrTime() 'add to DB and to INSERT'


'openDB "arabicWords"
openDbLogger "arabicWords","O","mediaEdit.update.asp","single",""

'add SCHOOL here and in FORMS'
mySQL = "UPDATE media SET mType="&mType&",mLink="&mLink&",description="&mDesc&",credit="&credit&",creditLink="&creditLink&",speaker="&speakerID&",uploader="&uploaderID&" WHERE id="&mediaID

response.write mySQL
'Response.End
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

'closeDB
closeDbLogger "arabicWords","C","mediaEdit.update.asp","single",durationMs,""



session("msg") = "המדיה עודכנה בהצלחה"

Response.Redirect "mediaControl.asp" %>
</div>
</body>
</html>