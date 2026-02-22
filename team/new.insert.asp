<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!--#include file="inc/functions/soundex.asp"-->
<!--#include file="inc/functions/string.asp"-->
<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"-->
<!DOCTYPE html>
<html>
<head>
	<meta charset='utf-8'>
</head>
<!--#include file="inc/top.asp"-->
<%
dim q,qFix 'TEMP from team/inc/top.asp'

if (session("role") and 2) = 0 then Response.Redirect "login.asp"

Dim wordID,msg,maxID,myMail,nowUTC
Dim arabic,arabicWord,hebrew,hebDef,pronunciation
Dim	partOfSpeach,binyan,gender,number,example,info
Dim imgLink,imgCredit,youtube,status,i
Dim taatik,hebClean,arbClean,taatikClean
Dim hebrewCleanMore,arabicCleanMore,arabicHebCleanMore


'openDB "arabicWords"
openDbLogger "arabicWords","O","new.insert.asp","words",""


dim lblCNT
mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
    lblCNT = res(0)
res.close
redim label(lblCNT)


hebrew = gereshFix(request("hebrewTranslation"))
hebDef = gereshFix(request("hebDef"))
arabic = gereshFix(request("arabic"))
arabicWord = gereshFix(request("arabicWord"))

pronunciation = gereshFix(request("pronunciation"))
example = gereshFix(request("example"))
info = gereshFix(request("info"))
imgLink = gereshFix(request("imgLink"))
imgCredit = gereshFix(request("imgCredit"))

partOfSpeach = CLng(Request("partOfSpeach"))
binyan = CLng(Request("binyan"))
gender = CLng(Request("gender"))
number = CLng(Request("number"))

if (session("role") And 4)>0 then status=1 else status=0
if session("userID") = 1 then status=0

    
youtube = request("youtube")
if youtube = empty then
    'Response.Write "<br/>no youtube vid today"
else
    youtube = gereshFix(request("youtube"))
end if

for i=1 to lblCNT
	label(i)=request("label"&cstr(i))
next

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



nowUTC = AR2UTC(now())

'TEMP SEARCH STRING VALUE - REMOVE CODE WHEN FIELD REMOVE FROM DB
dim searchString
searchString = ""

Set cmd=Server.CreateObject("adodb.command")
mySQL = "INSERT INTO words (arabic,arabicWord,hebrewTranslation,hebrewDef,pronunciation,partOfSpeach,binyan,gender,[number],example,info,"&_
		"creatorID,creationTimeUTC,imgLink,imgCredit,status,sndxHebrewV1,sndxArabicV1,hebrewClean,arabicClean,arabicHebClean,"&_
		"hebrewCleanMore,arabicCleanMore,arabicHebCleanMore,searchString) VALUES ('"&_
		arabic&"','"&arabicWord&"','"& hebrew&"','"& hebDef &"','"&pronunciation&"',"&partOfSpeach&","&binyan&","&gender&","&number&",'"&example&"','"&info&"',"&_
		session("userID")&",'"&nowUTC&"','"&imgLink&"','"&imgCredit&"',"&status&",'"&soundex(hebrew)&"','"&soundex(taatik)&"','"& hebClean&"','"&arbClean&"','"&taatikClean&"','"&_
		hebrewCleanMore&"','"&arabicCleanMore&"','"&arabicHebCleanMore&"','"&searchString&"')"
cmd.CommandType=1
cmd.CommandText=mySQL
'Response.Write "<br/>"& mySQL
'Response.End
Set cmd.ActiveConnection=con
cmd.execute ,,128

mySQL = "SELECT MAX(id) FROM words"
Set res = con.Execute (mySQL)
maxID = res(0)

if len(youtube)=0 then 
    'response.write "<br/>len(youtube)=0"
else
	mySQL = "INSERT INTO wordsLinks (wordID, description, link) VALUES (" & maxID & ",'YouTube Embed',"&youtube&")"
    'Response.Write "<br/>" & mySQL
    'Response.end
	cmd.CommandText=mySQL
	cmd.execute ,,128
end if


for i=1 to lblCNT
	if label(i)="on" then 
		mySQL = "INSERT INTO wordsLabels (wordID, LabelID) VALUES ("&maxID&","&i&")"
		cmd.CommandText=mySQL
		cmd.execute ,,128
	end if
next




dim newRelCnt
newRelCnt = request("relCount")
response.write "<br>newRelCnt = "&newRelCnt

if newRelCnt>0 then
	'INSERT NEW RELATIONS [2020-11]'
	dim word1,word2,newRelType,newRelID,newRelTypeStr,newRelIDStr,tmpRelID,tmpRelType
	wordID = maxID
	tmpRelID = trim(request("relID"))
	tmpRelType = trim(request("newRelType"))
	response.write "<br>tmpRelID = "&tmpRelID
	response.write "<br>tmpRelType = "&tmpRelType
	if right(tmpRelID,1) = "," then tmpRelID = left(tmpRelID,len(tmpRelID)-1)
	if right(tmpRelType,1) = "," then tmpRelType = left(tmpRelType,len(tmpRelType)-1)
	newRelIDStr = split(tmpRelID,",") 'New Relationship ID'
	newRelTypeStr = split(tmpRelType,",") 'New Relationship Type'
	for i=0 to newRelCnt-1
		response.write "<br>i = "&i
		if i=6 then exit for
		if len(newRelIDStr(i))>0 then newRelID = newRelIDStr(i) else exit for
		if len(newRelTypeStr(i))>0 then newRelType = newRelTypeStr(i) else exit for

		if newRelID>0 then 
			word1 = maxID
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

			mySQL = "INSERT INTO wordsRelations (word1, word2, relationType) VALUES ("&word1&","&word2&","&newRelType&")"
			'response.write "<br/>"&mySQL
			cmd.CommandText=mySQL
			cmd.execute ,,128
		end if
	next
end if

'If Heb/Taatik or Arabic is only 1 Character, Add its ID to "wordsShort" table
dim shortWord(3)

shortWord(1) = hebrew
shortWord(2) = arabic
shortWord(3) = arabicWord

for i=1 to 3
	if len(shortWord(i))=1 then
		if i<3 or (i=3 and hebrew<>arabicWord) then
			mySQL = "INSERT INTO wordsShort (sStr, wordID) VALUES ('"& shortWord(i) &"',"&maxID&")"
			cmd.CommandText=mySQL
			cmd.execute ,,128
		end if
	end if
next

'closeDB
closeDbLogger "arabicWords","C","new.insert.asp","words",durationMs,""



dim uName,userEmail

'openDB "arabicUsers"
openDbLogger "arabicUsers","O","new.insert.asp","username email",""


	mySQL = "SELECT username,Email FROM users WHERE id="&session("userID")
	res.open mySQL, con
		uName = res(0)
		userEmail = res(1)
	res.close

'closeDB
closeDbLogger "arabicUsers","C","new.insert.asp","username email",durationMs,""



session("msg") = "המילה <a href=""word.asp?id=" & maxID & """><span class=""nikud"">" & request("arabicWord") & "</span></a> נוספה למילון בהצלחה"

response.write "<br/>END OF INSERT"
Response.Redirect "../word.asp?id="&maxID
%>
</html>