<!--#include file="inc/inc.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head><%

Response.Write "<br/>OOPS! There seems to be an error.<br/>Please notify site admin - arabic4hebs@gmail.com<br/><br/>"
If session("role") < 7 then
	session("msg") = "אין לך הרשאה להשתמש באישור מהיר. לבירור, ניתן לפנות למנהלי האתר."
	Response.Redirect "/dashboard.lists.asp?listID=1"
end if

Function getString (f)
	getString = "'" &replace(f,"'","''")&"'"
End function 

Dim wordID,msg,myMail
Dim utcNow,action,explain,errorTypes

Dim arabic,arabicWord,searchString,hebrew,pronunciation
Dim	partOfSpeach,gender,number,example,info,root
Dim imgLink,imgCredit,status,labels,show
Dim youtube,linkDesc,link

Dim arabicOld,arabicWordOld,searchStringOld,hebrewOld,pronunciationOld
Dim	partOfSpeachOld,genderOld,numberOld,exampleOld,infoOld,rootOld
Dim imgLinkOld,imgCreditOld,statusOld,labelsOld,showOld
Dim youtubeOld,linkDescOld,linkOld

Const lblCnt = 22
Dim labelsOldStr, labelsNewArr(),labelsNewStr
redim labelsNewArr(lblCnt)


wordID = request("id")
    response.write "<br/>wordID = "&wordID&"<br/>"

explain = "'מנגנון אישור מהיר'"
	response.write "<br/>explain = "&explain


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","word.correct.quick.asp","main",""



mySQL = "SELECT * FROM words WHERE id="&wordID
'response.write "<br/>mySQL = "&mySQL&"<br/>"
res.open mySQL, con
if res.EOF then
	session("msg") = "res.EOF on mySQL: "&mySQL
else
	showOld = res("show")
	response.write "<br/> showOld = "&showOld
	arabicOld = res("arabic")
	response.write "<br/> arabicOld = "&arabicOld
	arabicWordOld = getString(res("arabicWord"))
	response.write "<br/> arabicWordOld = "&arabicWordOld
	response.write "<br/> arabicWordOld res = "&res("arabicWord")
	hebrewOld = getString(res("hebrewTranslation"))
	response.write "<br/>hebrewOld = "&left(hebrewOld,len(hebrewOld))
	pronunciationOld = getString(res("pronunciation"))
	response.write "<br/>pronunciationOld = "&pronunciationOld
	searchStringOld = getString(res("searchString"))
	response.write "<br/>searchStringOld = "&searchStringOld
	partOfSpeachOld = res("partOfSpeach")
	response.write "<br/>partOfSpeachOld = "&partOfSpeachOld
	genderOld = res("gender")
	response.write "<br/>genderOld = "&genderOld
	numberOld = res("number")
	response.write "<br/>numberOld = "&numberOld
	if len(res("example"))>=0 then exampleOld = getString(res("example")) else exampleOld="''"
	response.write "<br/>example = "&exampleOld
	if len(res("info"))>=0 then	infoOld = getString(res("info")) else infoOld = "''"
	response.write "<br/>infoOld = "&infoOld
	if len(res("imgLink"))>=0 then imgLinkOld = getString(res("imgLink")) else imgLinkOld = "''"
	response.write "<br/>imgLinkOld = "&imgLinkOld
	if len(res("imgCredit"))>=0 then imgCreditOld = getString(res("imgCredit")) else imgCreditOld = "''"
	response.write "<br/>imgCreditOld = "&imgCreditOld
	statusOld = res("status")
	response.write "<br/>statusOld = "&statusOld
	linkDescOld = "''" 'TEMP UNTIL linkHistory delt with in DB'
	linkOld = "''" 'TEMP UNTIL linkHistory delt with in DB'
	'labelsOld = res("labels")
end if
res.close

	response.write "<br/><br/>CHECK POINT 1<br/>"
	'response.end

hebrew = hebrewOld
    response.write "<br/>hebrew = "&left(hebrew,len(hebrew))
	response.write "<br/>hebrewOld = "&left(hebrewOld,len(hebrewOld))
pronunciation = pronunciationOld
    response.write "<br/>pronunciation = "&pronunciation
	response.write "<br/>pronunciationOld = "&pronunciationOld
arabicWord = arabicWordOld
    response.write "<br/>arabicWord = "&arabicWord
    response.write "<br/>arabicWordOld = "&arabicWordOld
arabic = arabicOld
    response.write "<br/>arabic = "&arabic
    response.write "<br/>arabicOld = "&arabicOld

partOfSpeach = partOfSpeachOld
    response.write "<br/>partOfSpeach = "&partOfSpeach
	response.write "<br/>partOfSpeachOld = "&partOfSpeachOld
gender = genderOld
    response.write "<br/>gender = "&gender
	response.write "<br/>genderOld = "&genderOld
number = numberOld
    response.write "<br/>number = "&number
	response.write "<br/>numberOld = "&numberOld
example = exampleOld
    response.write "<br/>example = "&example
	response.write "<br/>exampleOld = "&exampleOld
info = infoOld
    response.write "<br/>info = "&info
	response.write "<br/>infoOld = "&infoOld
imgLink = imgLinkOld
    response.write "<br/>imgLink = "&imgLink
	response.write "<br/>imgLinkOld = "&imgLinkOld
imgCredit = imgCreditOld
    response.write "<br/>imgCredit = "&imgCredit
	response.write "<br/>imgCreditOld = "&imgCreditOld
link = ""
	response.write "<br/>link = "&link
	linkDesc="" 

status = "1"
response.write "<br/>status = "&status
response.write "<br/>statusOld = "&statusOld


show = showOld
	response.write "<br/>show = "&show
	response.write "<br/>showOld = "&showOld

Response.Write "<br/><br/>TEMP VALUES:<br/>"

action = 4
	response.write "<br/>action = "&action


Response.Write "<br/><br/>LEAVE FOR NOW...:<br/>"

searchString = searchStringOld

errorTypes = "errorTypesTest"
	response.write "<br/>errorTypes = "&errorTypes

root = "0"
	response.write "<br/>root = "&root
rootOld = "0"
	response.write "<br/>rootOld = "&rootOld


dim isFirst
mySQL = "SELECT * FROM labels INNER JOIN wordsLabels ON labels.id=wordsLabels.labelID WHERE wordID=" + wordId
res.open mySQL, con
labelsOldStr = ""
isFirst=true
if not res.EOF then
	Do until res.EOF
		if isFirst then
			labelsOldStr = res("labelID")
			isFirst = false
		else
			labelsOldStr = labelsOldStr & ", " & res("labelID")
		end if
		res.moveNext
	Loop
end if
res.close

labelsNewStr = labelsOldStr
response.write "<br/>labelsNewStr = " & labelsNewStr
response.write "<br/>labelsOldStr = " & labelsOldStr


utcNow = AR2UTC(now())


'Response.End

Set cmd=Server.CreateObject("adodb.command")

'THIS query is missing video, labels and searchString:'
dim maxId
mySQL = "SELECT max(id) FROM history"
res.open mySQL, con
	maxId = res(0)
res.close

mySQL = "INSERT into history (word,actionUTC,[action],statusOld,statusNew,[user],errorTypes,explain,showOld,showNew,hebrewOld,hebrewNew,arabicOld,arabicNew,arabicWordOld,arabicWordNew,pronunciationOld,pronunciationNew,rootOld,rootNew,partOfSpeachOld,partOfSpeachNew,genderOld,genderNew,numberOld,numberNew,infoOld,infoNew,exampleOld,exampleNew,imgLinkOld,imgLinkNew,imgCreditOld,imgCreditNew,linkDescOld,linkDescNew,linkOld,linkNew,labelsOld,labelsNew) VALUES ("&wordID&",'"&utcNow&"',"&action&","&statusOld&","&status&","&session("userID")&",'"&errorTypes&"',"&explain&","&showOld&","&show&","&left(hebrewOld,len(hebrewOld))&","&left(hebrew,len(hebrew))&",'"&arabicOld&"','"&arabic&"',"&arabicWordOld&","&arabicWord&","&pronunciationOld&","&pronunciation&","&rootOld&","&root&","&partOfSpeachOld&","&partOfSpeach&","&genderOld&","&gender&","&numberOld&","&number&","&infoOld&","&info&","&exampleOld&","&example&","&imgLinkOld&","&imgLink&","&imgCreditOld&","&imgCredit&","&linkDescOld&",'"&linkDesc&"',"&linkOld&",'"&link&"','"&labelsOldStr&"','"&labelsNewStr&"')"

cmd.CommandType=1
cmd.CommandText=mySQL
Response.Write "<br/><br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128


'Inserting only the memo field to resolve error 80040e57'
response.write "<br/>memo not yet inserted"
mySQL = "SELECT max(id) FROM history"
res.open mySQL, con
	if res(0) <> maxId then

		mySQL = "UPDATE history SET searchStringOld="&searchStringOld&",searchStringNew="&searchString&" WHERE id="&res(0)

		cmd.CommandType=1
		cmd.CommandText=mySQL
		Response.Write "<br/><br/>"& mySQL
		'Response.End
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	end if
res.close



mySQL = "UPDATE words SET show="&show&",status="&status&",arabic='"&arabic&"',arabicWord="&arabicWord&",hebrewTranslation="&left(hebrew,len(hebrew))&",pronunciation="&pronunciation&",searchString="&searchString&",partOfSpeach="&partOfSpeach&",gender="&gender&",[number]="&number&",info="&info&",example="&example&",imgLink="&imgLink&",imgCredit="&imgCredit&" WHERE id="&wordId

cmd.CommandType=1
cmd.CommandText=mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","word.correct.quick.asp","main",durationMs,""




dim uName,userEmail

startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","word.correct.quick.asp","username email",""



	mySQL = "SELECT username,Email FROM users WHERE id="&session("userID")
	res.open mySQL, con
		uName = res(0)
		userEmail = res(1)
	res.close


endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","word.correct.quick.asp","username email",durationMs,""





session("msg") = "המילה <a href='../word.asp?id="&wordID&"'>"&arabicWord&"</a> אושרה בהצלחה!"

response.Redirect "/dashboard.lists.asp?listID=1"





'session("msg") = "המילה <a href=""https://rothfarb.info/ronen/arabic/word.asp?id=" & maxId & """><span class=""nikud"">" & arabicWord & "</span></a> נוספה למילון בהצלחה"

'response.write "<br/>END OF INSERT"
'response.end
'Response.Redirect "send_email.php?wordID="&maxId&"&arabic="&arabicWord

%>