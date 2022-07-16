<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/soundex.asp"-->
<!--#include file="inc/functions/string.asp"-->
<!--#include file="inc/time.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head><%
dim q,qFix 'TEMP from team/inc/top.asp'

If (session("role") and 2) = 0 then Response.Redirect "login.asp"


Dim wordID,msg,myMail
Dim cTime,cTimeFix,utcNow,action,explain,errorTypes,mediaCnt,psikOld,psikNew

Dim arabic,arabicWord,searchString,hebrew,hebDef,pronunciation
Dim	partOfSpeach,binyan,gender,number,example,info,root
Dim imgLink,imgCredit,status,labels,show
Dim mediaNew,mediaNewStr

Dim arabicOld,arabicWordOld,searchStringOld,hebrewOld,hebDefOld,pronunciationOld
Dim	partOfSpeachOld,binyanOld,genderOld,numberOld,exampleOld,infoOld,rootOld
Dim imgLinkOld,imgCreditOld,statusOld,labelsOld,showOld
Dim mediaOld,mediaOldStr

Dim lblCNT
Dim taatik,hebClean,arbClean,taatikClean
dim hebrewCleanMore,arabicCleanMore,arabicHebCleanMore


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","1_lblCNT",""

mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
	lblCNT = res(0)
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","1_lblCNT",durationMs,""



Dim labelsOldStr, labelsNewArr(),labelsNewStr
redim labelsNewArr(lblCnt)



wordID = request("id")
explain = gereshFix(request("explain"))



startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","2_words",""

mySQL = "SELECT * FROM words WHERE id="&wordID
res.open mySQL, con
if res.EOF then
	session("msg") = "res.EOF on mySQL: "&mySQL
else
	showOld = res("show")
	arabicOld = res("arabic")
	arabicWordOld = gereshFix(res("arabicWord"))
	hebrewOld = gereshFix(res("hebrewTranslation"))
	if len(res("hebrewDef"))>=0 then hebDefOld = gereshFix(res("hebrewDef")) else hebDefOld="''"
	pronunciationOld = gereshFix(res("pronunciation"))
	partOfSpeachOld = res("partOfSpeach")
	binyanOld = res("binyan")
	if len(binyanOld)>0 then
		'response.write "<Br/>binyan > 0"
	else
		binyanOld=0
	end if
	genderOld = res("gender")
	numberOld = res("number")
	if len(res("example"))>=0 then exampleOld = gereshFix(res("example")) else exampleOld="''"
	if len(res("info"))>=0 then	infoOld = gereshFix(res("info")) else infoOld = "''"
	if len(res("imgLink"))>=0 then imgLinkOld = gereshFix(res("imgLink")) else imgLinkOld = "''"
	if len(res("imgCredit"))>=0 then imgCreditOld = gereshFix(res("imgCredit")) else imgCreditOld = "''"
	statusOld = res("status")

	mediaOld = "''" 'TEMP UNTIL wordsMediaHistory delt with in DB'

end if
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","2_words",durationMs,""


hebrew = gereshFix(Request("hebrewTranslation"))
hebDef = gereshFix(Request("hebDef"))
pronunciation = gereshFix(Request("pronunciation"))
arabicWord = gereshFix(Request("arabicWord"))
arabic = gereshFix(Request("arabic"))

partOfSpeach = CLng(Request("partOfSpeach"))
binyan = CLng(Request("binyan"))
gender = CLng(Request("gender"))
number = CLng(Request("number"))
example = gereshFix(request("example"))
info = gereshFix(request("info"))
imgLink = gereshFix(request("imgLink"))
imgCredit = gereshFix(request("imgCredit"))

mediaNew = request("mediaNew")

status = request("status")
	if len(status)<1 then status = statusOld

show = request("show")



if len(request("arabic"))>0 then 
	taatik = request("arabic")
else
	taatik = request("arabicWord")
end if


hebClean = onlyLetters(hebrew)
arbClean = onlyLetters(arabic)
taatikClean =  onlyLetters(arabicWord)

hebrewCleanMore = request("hebrewCleanMore")
arabicCleanMore = request("arabicCleanMore")
arabicHebCleanMore = request("arabicHebCleanMore")

if len(hebrewCleanMore)>0 then hebrewCleanMore = gereshFix(onlyLetters(hebrewCleanMore))
if len(arabicCleanMore)>0 then arabicCleanMore = gereshFix(onlyLetters(arabicCleanMore))
if len(arabicHebCleanMore)>0 then arabicHebCleanMore = gereshFix(onlyLetters(arabicHebCleanMore))




'Relations - DELETE all relations to this word'

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","3_rel_del",""

mySQL = "DELETE FROM wordsRelations WHERE word1="&wordID&" OR word2="&wordID
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","3_rel_del",durationMs,""


'Relations - INSERT checked existing relations'
dim a,b,x,y,relsChecked
relsChecked = Request("rel")
a=split(relsChecked,", ")

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","4_rel_ins",""

for each x in a
	b=split(x,"b")
	mySQL = "INSERT INTO wordsRelations (word1, word2, relationType) VALUES ("&b(0)&","&b(1)&","&b(2)&")"
	cmd.CommandText=mySQL
	Set cmd.ActiveConnection=con
	cmd.execute ,,128
next

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","4_rel_ins",durationMs,""



'Relations - INSERT new relations [2020-11]'
dim newRelCnt
newRelCnt = request("relCount")
newRelCnt = left(newRelCnt,1)

if newRelCnt>0 then
	dim word1,word2,newRelType,newRelID,newRelTypeStr,newRelIDStr,tmpRelID,tmpRelType
	tmpRelID = trim(request("relID"))
	tmpRelType = trim(request("newRelType"))
	if right(tmpRelID,1) = "," then tmpRelID = left(tmpRelID,len(tmpRelID)-1)
	if right(tmpRelType,1) = "," then tmpRelType = left(tmpRelType,len(tmpRelType)-1)
	newRelIDStr = split(tmpRelID,",") 'New Relationship ID'
	newRelTypeStr = split(tmpRelType,",") 'New Relationship Type'
	for i=0 to newRelCnt-1
		if i=6 then exit for
		if len(newRelIDStr(i))>0 then newRelID = newRelIDStr(i) else exit for
		if len(newRelTypeStr(i))>0 then newRelType = newRelTypeStr(i) else exit for

		if newRelID>0 then 
			word1 = wordID
			word2 = newRelID
			SELECT CASE newRelType
				case 10
					word1 = newRelID
					word2 = wordID
				case 11
					newRelType = 10
				case 20
					word1 = newRelID
					word2 = wordID
				case 21
					newRelType = 20
				case 31
					newRelType = 3
					word1 = newRelID
					word2 = wordID
				case 32
					newRelType = 3
				case 41
					word1 = newRelID
					word2 = wordID
					newRelType = 4
				case 42
					newRelType = 4
				case 50
					word1 = newRelID
					word2 = wordID
				case 51
					newRelType = 50
				case 52
					word1 = newRelID
					word2 = wordID
				case 53
					newRelType = 52
				case 54
					word1 = newRelID
					word2 = wordID
				case 55
					newRelType = 54
				case 60
					word1 = newRelID
					word2 = wordID
				case 61
					newRelType = 60		
				case 81
					word1 = newRelID
					word2 = wordID
					newRelType = 8
				case 82
					newRelType = 8
			END SELECT

			startTime = timer()
			'openDB "arabicWords"
			openDbLogger "arabicWords","O","edit.update.asp","5_rel_new",""

			mySQL = "INSERT INTO wordsRelations (word1, word2, relationType) VALUES ("&word1&","&word2&","&newRelType&")"
			cmd.CommandText=mySQL
			Set cmd.ActiveConnection=con
			cmd.execute ,,128

			endTime = timer()
			durationMs = Int((endTime - startTime)*1000)
			'closeDB
			closeDbLogger "arabicWords","C","edit.update.asp","5_rel_new",durationMs,""

		end if
	next
end if
'Relations - END HERE


action = 4

searchString = gereshFix(request("searchString"))
searchString = replace(searchString,", ","|")
searchString = replace(searchString,",","|")
searchString = replace(searchString,"vbLf","|") 'windows line feed
searchString = replace(searchString,"vbCr","") 'windows carrige return

if len(searchString)>255 then
    searchString = left(searchString,255)
end if


errorTypes = "errorTypesTest"

root = "0"
rootOld = "0"





dim isFirst, isFirst2
dim i
labelsNewStr = ""
isFirst=true

for i=1 to lblCnt
	labelsNewArr(i)=request("label"&cstr(i))
	if isFirst then
		if labelsNewArr(i)="on" then
			labelsNewStr = cstr(i)
			isFirst = false
		end if
	else
		if labelsNewArr(i)="on" then labelsNewStr = labelsNewStr & "," & cstr(i)
	end if
next

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","6_labels",""

mySQL = "SELECT labelID FROM labels INNER JOIN wordsLabels ON labels.id=wordsLabels.labelID WHERE wordID="&wordId
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

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","6_labels",durationMs,""


'MEDIA - GET OLD DATA (for history) and Checked for new string'
mediaNewStr = ""
mediaOldStr = ""
psikOld = ""
psikNew = ""
mediaCnt = 0

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","7_media",""

mySQL = "SELECT mediaID FROM wordsMedia WHERE wordID="&wordId
res.open mySQL, con
do until res.EOF
	mediaOldStr = mediaOldStr & psikOld & res("mediaID")
	psikOld = ","
	if (request("mediaCheck"&cstr(res("mediaID"))) = "on") AND (cstr(request("mediaNew"))<>cstr(res("mediaID"))) then 
		mediaNewStr = mediaNewStr & psikNew & res("mediaID")
		psikNew = ","
		mediaCnt = mediaCnt+1
	end if
	res.moveNext
loop
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","7_media",durationMs,""


if len(request("mediaNew"))>0 then
	mediaNewStr = mediaNewStr & psikNew & request("mediaNew")
	mediaCnt = mediaCnt + 1
end if

'DELETE ALL media from word'

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","8_media_del",""

mySQL = "DELETE FROM wordsMedia WHERE wordID="&wordID
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","8_media_del",durationMs,""


'ADD new media to word'
dim mediaNewArr
if len(mediaNewStr)>0 then
	mediaNewArr = Split(mediaNewStr,",")

	startTime = timer()
	'openDB "arabicWords"
	openDbLogger "arabicWords","O","edit.update.asp","9_media_new",""

	for i=1 to mediaCnt
		if mediaNewArr(i-1) then 
			mySQL = "INSERT INTO wordsMedia (wordID, mediaID) VALUES ("&wordId&","&mediaNewArr(i-1)&")"
			cmd.CommandText=mySQL
			Set cmd.ActiveConnection=con
			cmd.execute ,,128
		end if
	next

	endTime = timer()
	durationMs = Int((endTime - startTime)*1000)
	'closeDB
	closeDbLogger "arabicWords","C","edit.update.asp","9_media_new",durationMs,""

end if


utcNow = AR2UTC(now())


'Response.End

Set cmd=Server.CreateObject("adodb.command")


'INSERT MISSING: hebDef
'INSERT MISSING: media, relations
dim maxId

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","10_history_max",""

mySQL = "SELECT max(id) FROM history"
res.open mySQL, con
	maxId = res(0)
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","10_history_max",durationMs,""


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","11_history_ins",""

mySQL = "INSERT into history (word,actionUTC,[action],statusOld,statusNew,[user],errorTypes,explain,showOld,showNew,hebrewOld,hebrewNew,hebrewDefOld,hebrewDefNew,arabicOld,arabicNew,arabicWordOld,arabicWordNew,pronunciationOld,pronunciationNew,rootOld,rootNew,partOfSpeachOld,partOfSpeachNew,binyanOld,binyanNew,genderOld,genderNew,numberOld,numberNew,infoOld,infoNew,exampleOld,exampleNew,imgLinkOld,imgLinkNew,imgCreditOld,imgCreditNew,labelsOld,labelsNew) VALUES ("&wordID&",'"&utcNow&"',"&action&","&statusOld&","&status&","&session("userID")&",'"&errorTypes&"','"&explain&"',"&showOld&","&show&",'"& hebrewOld&"','"& hebrew&"','"& hebDefOld&"','"& hebDef&"','"&arabicOld&"','"&arabic&"','"&arabicWordOld&"','"&arabicWord&"','"&pronunciationOld&"','"&pronunciation&"',"&rootOld&","&root&","&partOfSpeachOld&","&partOfSpeach&","&binyanOld&","&binyan&","&genderOld&","&gender&","&numberOld&","&number&",'"&infoOld&"','"&info&"','"&exampleOld&"','"&example&"','"&imgLinkOld&"','"&imgLink&"','"&imgCreditOld&"','"&imgCredit&"','"&labelsOldStr&"','"&labelsNewStr&"')"
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","11_history_ins",durationMs,""



'Inserting only the memo field to resolve error 80040e57'

startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","12_history_str",""

mySQL = "SELECT max(id) FROM history"
res.open mySQL, con
	if res(0) <> maxId then

		mySQL = "UPDATE history SET searchStringOld='"&searchStringOld&"',searchStringNew='"&searchString&"' WHERE id="&res(0)

		cmd.CommandType=1
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	end if
res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","12_history_str",durationMs,""


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","13_update",""

mySQL = "UPDATE words SET lockedUTC='', show="&show&",status="&status&",arabic='"&arabic&"',arabicWord='"&arabicWord&"',hebrewTranslation='"& hebrew&"',"&_
		"hebrewDef='"& hebDef &"',pronunciation='"&pronunciation&"',searchString='"&searchString&"',partOfSpeach="&partOfSpeach&",binyan="&binyan&_
		",gender="&gender&",[number]="&number&",info='"&info&"',example='"&example&"',imgLink='"&imgLink&"',imgCredit='"&imgCredit&"',hebrewClean='"& hebClean&_
		"',sndxHebrewV1='"&soundex(hebrew)&"',arabicClean='"&arbClean&"',sndxArabicV1='"&soundex(taatik)&"',arabicHebClean='"&taatikClean&_
		"',hebrewCleanMore='"& hebrewCleanMore &"', arabicCleanMore='"&arabicCleanMore&"', arabicHebCleanMore='"&arabicHebCleanMore&"' WHERE id="&wordId

cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","13_update",durationMs,""


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","14_labels_del",""

mySQL = "DELETE FROM wordsLabels WHERE wordID="&wordId
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","14_labels_del",durationMs,""



startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","edit.update.asp","15_labels_ins",""

for i=1 to lblCnt
	if labelsNewArr(i)="on" then 
		mySQL = "INSERT INTO wordsLabels (wordID,LabelID) VALUES ("&wordId&","&i&")"
		cmd.CommandText=mySQL
		Set cmd.ActiveConnection=con
		cmd.execute ,,128
	end if
next

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","edit.update.asp","15_labels_ins",durationMs,""




dim uName,userEmail

startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","edit.update.asp","username email",""

	mySQL = "SELECT username,Email FROM users WHERE id="&session("userID")
	res.open mySQL, con
		uName = res(0)
		userEmail = res(1)
	res.close

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","edit.update.asp","username email",durationMs,""




'response.END

session("msg") = "העריכה התבצעה בהצלחה"



dim temp

if Request.ServerVariables("SERVER_NAME") = "rothfarb.info" then
	temp = "send_email_wordEdit.php?wordID="&wordId&"&arabic="&arabicWord&"&username="&uName&"&userEmail="&userEmail
	'Response.Redirect server.HTMLencode("send_email_wordEdit.php?wordID="&wordId&"&arabic="&arabicWord&"&username="&uName&"&userEmail="&userEmail)
	Response.Redirect "send_email_wordEdit.php?wordID="&wordId&"&arabic="&arabicWord&"&username="&uName&"&userEmail="&userEmail
else
	response.Redirect "../word.asp?id="&wordID
end if %>