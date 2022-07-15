<%@ Language="VBScript" CodePage="65001" LCID="1037" %>
<%
Option Explicit
dim res, res2, res3, con, mySQL, cmd, userIP, opTime
dim baseA, baseT

baseA = ""
baseT = baseA + "/team/"

sub OpenDbLogger(db,opType,afPage,opNum,sStr)
	userIP = Request.Servervariables("REMOTE_HOST")
	opTime = AR2UTC(now())
	OpenDB(db)
	mySQL = "INSERT INTO log (opType,afDB,afPage,opNum,userIP,opTimestamp,sStr) VALUES ('"&opType&"','"&db&"','"&afPage&"','"&opNum&"','"&userIP&"','"&opTime&"','"&sStr&"')"
	con.execute mySQL
end sub

sub CloseDbLogger(db,opType,afPage,opNum,durationMs)
	userIP = Request.Servervariables("REMOTE_HOST")
	opTime = AR2UTC(now())
	mySQL = "INSERT INTO log (opType,afDB,afPage,opNum,userIP,opTimestamp,durationMs) VALUES ('"&opType&"','"&db&"','"&afPage&"','"&opNum&"','"&userIP&"','"&opTime&"','"&durationMs&"')"
	con.execute mySQL
  closeDb
end sub

sub OpenDB(db)
	set con = Server.CreateObject("adodb.connection")
	set res = Server.CreateObject("adodb.recordset")
	set res2 = Server.CreateObject("adodb.recordset")
	set res3 = Server.CreateObject("adodb.recordset")
	set cmd = Server.CreateObject("adodb.command")
	con.provider = "microsoft.jet.oledb.4.0"
	con.Open Server.MapPath("App_Data/"&db&".mdb")
end sub

sub closeDB
	set res = nothing
	set res2 = nothing
	set res3 = nothing
	set con = nothing
end sub

Sub Go(url)
	If con.State=1 Then	con.Close
	CloseDB
	Response.Redirect url
End Sub

Response.CodePage = 65001
Response.CharSet = "UTF-8"

%><!--#include file="inc/functions/string.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/functions/soundex.asp"--><%


dim clientID,clientPW,sStr,psik,strDisplay,strClean

psik=""
clientID = request("id")
clientPW = request("pw")
sStr = request("sStr")
if len(sStr)=0 then 
    response.write "{""isError"":true,""msg"":""empty string""}" 
    response.end
end if

strDisplay = ""
strClean = ""

if len(sStr)>0 then
    strDisplay = gereshFix(sStr)
    strDisplay = Replace(strDisplay, ChrW(160), "") 'non-breaking space
    strDisplay = trim(strDisplay)
    strClean = onlyLetters(strDisplay)
end if

dim countMe,resultPos,found,skip,id,ids,idx,psikArr,psikWord
countMe = 0
resultPos = 0
skip = false
ids = ""

dim startTime,endTime,durationMs

if len(strClean)=0 then
    if len(strDisplay)>0 then %>
        <div style="text-align: center; padding: 5px; background: #ffd7d73d; border-bottom: 2px solid #ff8282; margin: 0 auto 80px auto; color: #ff8282;">
            <p>
                יש להשתמש באותיות בעברית וערבית בלבד (אפשר גם ספרות)
            </p>
        </div> <%
    end if
else
    startTime = timer()
    openDB "arabicWords"
    'mySQL = "SELECT * FROM words WHERE hebrewClean='"&sStr&"'"

    if len(strClean)=1 then
        mySQL = "SELECT W.*, M.mediaID "&_ 
                "FROM [words] W "&_
                "LEFT JOIN wordsMedia M ON W.id = M.wordID "&_
                "WHERE W.id IN (SELECT S.wordID FROM [wordsShort] S WHERE sStr='"&strClean&"') AND show"

    else
        mySQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE "&_
                "((hebrewClean LIKE '%"& strClean &"%') OR (hebrewCleanMore LIKE '%"& strClean &"%') OR "&_
                "(arabicClean = '"& strClean &"') OR (arabicCleanMore LIKE '%"& strClean &"%') OR"&_
                "(arabicHebClean = '"& strClean &"') OR (arabicHebCleanMore LIKE '%"& strClean &"%')) AND show"
    end if
    res.open mySQL, con, 0, 1 'adOpenForwardOnly, adLockReadOnly

    if not res.EOF then
        Do until res.EOF
            found=false
            skip = false
            idx=Split(ids,",")
            for each id in idx
                if id=cstr(res("id")) then skip=true
            next 

            if strClean = res("hebrewClean") or (strClean = res("arabicClean")) or (strClean) = res("arabicHebClean") then
                found = true
                if ids = "" then ids = res("id") else ids = ids & "," & res("id")
            else
                psikArr = split(res("hebrewClean"),",")
                for each psikWord in psikArr
                    if onlyLetters(strDisplay) = psikWord then
                        found = true
                        if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    end if        
                next
            end if 

            'CHECK FOR MORE EXACT RESULTS 1/3
            if len(res("hebrewCleanMore"))>0 then
                psikArr = split(res("hebrewCleanMore"),",")
                for each psikWord in psikArr
                    if onlyLetters(strDisplay) = psikWord then
                        found = true
                        if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    end if        
                next
            end if

            'CHECK FOR MORE EXACT RESULTS 2/3
            if len(res("arabicCleanMore"))>0 then
                psikArr = split(res("arabicCleanMore"),",")
                for each psikWord in psikArr
                    if onlyLetters(strDisplay) = psikWord then
                        found = true
                        if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    end if        
                next
            end if

            'CHECK FOR MORE EXACT RESULTS 3/3
            if len(res("arabicHebCleanMore"))>0 then
                psikArr = split(res("arabicHebCleanMore"),",")
                for each psikWord in psikArr
                    if onlyLetters(strDisplay) = psikWord then
                        found = true
                        if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    end if        
                next
            end if



    ' if res.EOF then
    '     response.write "[{""isError"":true}]"
    ' else
    '     response.write "["
    '     do until res.EOF
    '         response.write psik
    '         response.write "{"
    '         response.write """wordID"":"
    '         response.write res("ID")
    '         response.write ", "
    '         response.write """hebrew"":"
    '         response.write """"&res("hebrewTranslation")&""""
    '         response.write ", "
    '         response.write """arabic"":"
    '         response.write """"&res("arabic")&""""
    '         response.write ", "
    '         response.write """taatikHeb"":"
    '         response.write """"&res("arabicWord")&""""
    '         response.write ", "
    '         response.write """taatikEng"":"
    '         response.write """"&res("pronunciation")&""""
    '         response.write "}"
    '         res.moveNext
    '         psik = ","
    '     loop
    '     response.write "]"
    ' end if
    ' res.close



            if (found=true) and (skip=false) then 
                countMe = countMe+1
                response.write "{exact: ["
                response.write "{"
                response.write """wordId"":"& res("id") &","
                response.write """hebrew"":"& res("hebrewTranslation")
                response.write """arabic"":"& res("arabic")
                response.write """taatikHeb"":"& shadaAlt(res("arabicWord"))
                response.write """taatikEng"":"& res("pronunciation")
                response.write res("hebrewDef")
                response.write res("mediaID")
                response.write res("status")
                response.write res("partOfSpeach")
                response.write res("binyan")
                response.write res("gender")
                response.write res("number")

                'SHOW MEDIA'
                if res("mediaID") then
                    response.write "media:true"
                    mySQL = "SELECT * FROM wordsMedia INNER JOIN media ON wordsMedia.mediaID=media.ID WHERE wordsMedia.wordID="&res("id")
                    res2.open mySQL, con
                    do until res2.EOF
                        response.write res2("mType")
                        response.write res2("mLink")
                        response.write res2("creditLink")
                        response.write res2("credit")
                        res2.movenext
                    loop
                    res2.close
                end if

                'SINGLE - PLURAL'
                if res("partOfSpeach")=1 then 
                    mySQL = "SELECT * FROM wordsRelations WHERE (word1="&res("id")&" OR word2="&res("id")&") AND relationType=3"
                    res2.open mySQL, con
                    if not res2.EOF then 
                        if res2("word1") = res("id") then
                            wordMain = res2("word2")
                        else 
                            wordMain = res2("word1")
                        end if
                    end if
                    res2.close
                    if wordMain>0 then
                        mySQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE id="&wordMain
                        res2.open mySQL, con
                            response.write res2("id")
                            response.write res2("hebrewTranslation")
                            response.write res2("hebrewDef")
                            response.write res2("imgLink")
                            response.write res2("mediaID")
                            response.write res2("status")
                            response.write res2("arabic")
                            response.write shadaAlt(res2("arabicWord"))
                            response.write res2("pronunciation")
                            if ids = "" then ids = wordMain else ids = ids & "," & wordMain
                        res2.close
                        wordMain=0
                    end if
                end if

                'SHOW IMAGE'
                response.write res("imgLink")
                response.write res("imgCredit")

            end if
            res.moveNext
        loop
    end if
    res.close
    
    'closeDB
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)

    closeDB
    'closeDbLogger "arabicWords","C","default","1-FO-RO",durationMs '[db,opType,afPage,opNum,durationMs]

    
    if countMe>0 then resultPos=1
    countMe=0 

    response.write "adID"

    dim sndx,searchNumber,searchSQL,countID,skipSndx
    if len(strClean)>1 then searchNumber=2 else searchNumber=5
    sndx = soundex(strClean) 

    do until searchNumber=5
        skipSndx = false
        SELECT CASE searchNumber
        case 2
            if len(sndx)>0 then
                searchSQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((sndxArabicV1 = '"& sndx &"') OR (sndxHebrewV1 = '"& sndx &"')) AND show"
                countID = "count2"
            else
                skipSndx = true
            end if
        case 3
            searchSQL = "SELECT TOP 50 words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((hebrewClean LIKE '%"& strDisplay &"%') OR (arabicClean LIKE '%"& strDisplay &"%') OR (arabicHebClean LIKE '%"& strDisplay &"%')) AND show"
            countID = "count3"
        case 4
            searchSQL = "SELECT TOP 50 words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE searchString LIKE '%"& strDisplay &"%' AND show"
            countID = "count4"
        END SELECT
        searchNumber = searchNumber+1 


        if skipSndx = false then
                startTime = timer()
                openDB "arabicWords"
                'OpenDbLogger "arabicWords","O","default","2",strClean
                mySQL = searchSQL
                res.open mySQL, con
                if not res.EOF then
                    Do until res.EOF
                        idx=Split(ids,",")
                        for each id in idx
                            if id=cstr(res("id")) then skip=true
                        next 
                        if skip = false then
                            response.write res("id")
                            response.write res("hebrewTranslation")
                            response.write res("hebrewDef")
                            response.write res("imgLink")
                            response.write res("mediaID")
                            response.write res("status")
                            response.write res("arabic")
                            response.write shadaAlt(res("arabicWord"))
                            response.write res("pronunciation")
                            countMe = countMe+1
                        end if
                        if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                        skip = false
                        res.moveNext
                    Loop
                end if
                res.close
                endTime = timer()
                durationMs = Int((endTime - startTime)*1000)

                closeDB
                'closeDbLogger "arabicWords","C","default","2",durationMs

            if (countMe>0) and (resultPos=0) then resultPos=2 'no exact results
            if (countMe=0) and (resultPos=0) then resultPos=9 'no results
            countMe=0 'reset
        end if
    loop
end if


'RESULTS FROM SENTENCES'
if len(strClean)>0 AND inStr(strDisplay," ")>0 then 
    startTime = timer()
    openDB "arabicWords"
    mySQL = "SELECT sentences.* FROM sentences WHERE ((hebrewClean LIKE '%"& strClean &"%') OR (arabicClean LIKE '%"& strClean &"%') OR (arabicHebClean LIKE '%"& strClean &"%')) AND show"
    res.open mySQL, con
    if res.EOF then 
        if resultPos=1 then resultPos = 11
        if resultPos=2 then resultPos = 21
        if resultPos=9 then resultPos = 91
    else
        response.write "Sentences Test"
        Do until res.EOF
            response.write res("id")
            response.write res("hebrew")
            response.write res("arabic")
            response.write shadaAlt(res("arabicHeb"))
            res.moveNext
        loop
    end if
    closeDB
    endTime = timer()
end if



response.Flush


'INSERT TO SEARCH HISTORY'
if len(strDisplay)>500 then 'DISABLED - Normally it's len(strDisplay)>0
    openDB "arabicSearch"
    dim searchID

    'COUNTER & RESULT STATUS
    mySQL = "SELECT id,searchCount FROM wordsSearched WHERE typed='"&strDisplay&"'"
    res.open mySQL, con
    if res.EOF then 'if new string
        mySQL = "INSERT into wordsSearched(typed,result) VALUES('"& strDisplay &"',"& resultPos &")"
        searchID = 0
    else
        mySQL = "UPDATE wordsSearched SET searchCount="& (res("searchCount")+1) &",result="& resultPos &" WHERE typed='"& strDisplay &"'"
        searchID = res("id")
    end if
    res.close
    con.execute mySQL

    'TIMESTAMP
    if searchID = 0 then 'if new string
        mySQL = "SELECT max(ID) FROM wordsSearched" 'get maxID
        res.open mySQL, con
            searchID = res(0)
        res.close
    end if
    mySQL = "INSERT into latestSearched(searchTime,searchID) VALUES('"& AR2UTC(now()) &"',"& searchID &")"
    con.execute mySQL

    closeDB
end if %>