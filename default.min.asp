<!--#include file="inc/inc.asp"-->
<!--#include file="team/inc/functions/string.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>

    <META NAME="ROBOTS" CONTENT="NOINDEX" />
    <title>מילון ערבית מדוברת - גרסא מינימלית</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="Description" content="גרסא מינימלית לבדיקות של המילון לערבית מדוברת (לדוברי עברית). שירות חינמי שנועד לעזור ללומדים ערבית מדוברת" />
    <meta name="Keywords" content="מילון, ערבית, מדוברת, עברית, עברי, ערבי, חופשי, חינם, חינמי, תרגום, תירגום, מילים, איך, אומרים, בערבית" />
    <link rel="shortcut icon" href="img/site/favicon.ico" />
    <style>
        body {max-width:600px; margin:0 auto; text-align:center; background:#effaff;font-family: Arial, Helvetica, sans-serif;}
        body,input,button {color:#266b8a;}
        h1 {font-size:1.2em; margin:7px 0 0 0;}
        h2 {font-size:0.9em; background:#cbefff;}
        h3 {font-size:0.9em; margin:0;}
        .result {position:relative; border:1px dotted #d8d7d7; width:100%; margin-bottom:2px;}
        .arb {font-size:x-large;}
        .heb,.arb,.eng {display:block;}
        .heb {text-align:right;}
        .eng {text-align:left;}
        .marker {position:absolute; left:0; BACKGROUND:YELLOW; FONT-SIZE:SMALL; PADDING:3PX;}
    </style>
</head>
<body dir="rtl"><%
dim q,qFix,msg 

if Request.QueryString("exit")="1" then 
    session.Abandon
    Session("role")=null
    Response.redirect("login.asp")
end if

'6 {MOVE BACK TO FUNCTIONS/STRING.ASP AFTER DIRECTORY SORTING}
function gereshFix(str)

    dim i,crnt

    for i=1 to len(str)
        crnt = Mid(str,i,1)
        SELECT CASE crnt
            case "'","`","‘","’","‚","′","‵","＇"
                gereshFix = gereshFix + "׳"
            case """","“","”","„","‟","″"
                gereshFix = gereshFix + "״"
            case else
                gereshFix = gereshFix + crnt
        END SELECT
    next
end function

'edit.update.asp - still used for requesting 'on' labels'
'{MOVE BACK TO FUNCTIONS/STRING.ASP AFTER DIRECTORY SORTING}
Function getString (f)
    getString = replace(f,"'","''")
End function 

dim strInput,strDisplay,strClean

strInput = request("searchString")
strDisplay = ""
strClean = ""

if len(strInput)>0 then
    strDisplay = gereshFix(strInput)
    strDisplay = Replace(strDisplay, ChrW(160), "") 'non-breaking space
    strDisplay = trim(strDisplay)
    strClean = onlyLetters(strDisplay)
end if


'REPLACE WITH FUNCTIONS FROM string.asp'
dim qq,qqFix,qDisplay
q = trim(Request("searchString"))
    dim quotes, dQuotes
    quotes = chr(34)
    dQuotes = chr(34) & chr(34)
    qq = replace(q,quotes,dQuotes) 'REPLACE QUOTE WITH DOUBLE-QUOTE, FOR LATER SQL'
    qqFix = Replace(qq, ChrW(160), "") 'REPLACE UNVISIBLE UNICODE-160 WITH NOTHING'
    qFix = Replace(q, ChrW(160), "") 'REPLACE UNVISIBLE UNICODE-160 WITH NOTHING'
    qDisplay = Replace(q,quotes,"&quot;") 'REPLACE QUOTE. FOR DISPLAY WITH HTML'
%>

<!--#include file="team/inc/functions/soundex.asp"--><%

dim countMe,id,ids,idx,skip,wordMain,title,psikArr,psikWord,found

countMe = 0 
ids = ""
skip = false
wordMain=0 %>

<div style="width:90%;margin:0 auto;">
    <h1>מילון ערבית מדוברת</h1>
    <h2 style="display:none;">גרסא מינימליסטית</h2>
    <form action=default.min.asp method="get">
        <input name="searchString" id="searchString" placeholder="הקלידו מילה" value="<%=server.HTMLEncode(strDisplay)%>" style="width:90%; font-size:1.4em; padding:5px;margin:10px;" />
        <button id="submit" type="submit" style="margin:5px auto 20px auto; font-size:1.2em;">לחצו לחיפוש</button>
    </form><%

    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","default.min.asp","main",strClean


    if len(strDisplay)>0 then

        mySQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((hebrewClean LIKE '%"& strClean &"%') OR (arabicClean LIKE '%"& strClean &"%') OR (arabicHebClean LIKE '%"& strClean &"%')) AND show"
        res.open mySQL, con
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
                    countMe = countMe+1
                else
                    psikArr = split(res("hebrewClean"),",")
                    for each psikWord in psikArr
                        if onlyLetters(strDisplay) = psikWord then
                            found = true
                            if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                            countMe = countMe+1
                        end if        
                    next
                end if 

                if (found=true) and (skip=false) then %>

            <div>
                <div class="result"><%
                        Select Case res("status")
                        Case -1 %>
                            <span class="marker">ערך בבדיקה</span><%
                        Case 0 %>
                            <span class="marker">טרם נבדק</span><%
                        End Select %>                 
                    <div class="heb"><%=res("hebrewTranslation")%>
                    </div>
                    <div class="arb"><%=res("arabic")%></div>
                    <div class="arb"><%=Replace(res("arabicWord"),chrw(&H0651),chrw(&H0598))%></div>
                    <div class="eng" dir="ltr"><%=res("pronunciation")%></div>
                </div>
            </div><%


        end if
        res.moveNext
    loop
end if
res.close%>
    
<span id="count1" data-count="<%=countMe%>" style="display:hidden;"></span><%
countMe=0 


    dim sndx,searchNumber,searchTitle,divClass,searchSQL,countID
    searchNumber=2
    sndx = soundex(strClean) 


    do until searchNumber=5

        SELECT CASE searchNumber
        case 2
            searchTitle = "<h2>נשמע דומה</h2>"
            searchSQL = "SELECT words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((sndxArabicV1 = '"& sndx &"') OR (sndxHebrewV1 = '"& sndx &"')) AND show"
            countID = "count2"
        case 3
            searchTitle = "<h2>רצף אותיות</h2>"
            searchSQL = "SELECT TOP 50 words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE ((hebrewClean LIKE '%"& strDisplay &"%') OR (arabicClean LIKE '%"& strDisplay &"%') OR (arabicHebClean LIKE '%"& strDisplay &"%')) AND show"
            countID = "count3"
        case 4
            searchTitle = "<h2>תוצאות נוספות</h2>"
            searchSQL = "SELECT TOP 50 words.*, wordsMedia.mediaID FROM words LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE searchString LIKE '%"& strDisplay &"%' AND show"
            countID = "count4"
        END SELECT
        searchNumber = searchNumber+1

    %>

        <%=searchTitle%>
        <div class="results"><%
            mySQL = searchSQL
            res.open mySQL, con
            if not res.EOF then
                Do until res.EOF
                    idx=Split(ids,",")
                    for each id in idx
                        if id=cstr(res("id")) then skip=true
                    next 
                    if skip = false then %>
                        <div class="result"><%
                            Select Case res("status")
                            Case -1 %>
                                <span class="marker">ערך בבדיקה</span><%
                            Case 0 %>
                                <span class="marker">טרם נבדק</span><%
                            End Select %>
                            <div class="heb"><%=res("hebrewTranslation")%>
                            </div>
                            <div class="arb"><%=res("arabic")%></div>
                            <div class="arb"><%=Replace(res("arabicWord"),chrw(&H0651),chrw(&H0598))%></div>
                            <div class="eng" dir="ltr"><%=res("pronunciation")%></div>
                        </div><%
                    countMe = countMe+1
                    end if
                    if ids = "" then ids = res("id") else ids = ids & "," & res("id")
                    skip = false
                    res.moveNext
                Loop
            end if
            res.close %>
        </div>
        <span id="<%=countID%>" data-count="<%=countMe%>" style="display:none;"></span><%
        countMe=0 
    loop
    end if 

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","default.min.asp","main",durationMs,strClean

%>

<div>
    <p style="font-size:small; max-width:300px; width:95%; margin:0 auto; ">
    גרסא זו היא גרסא מינימליסטית של האתר הרגיל.
    מיועד למקרים בהם האתר הרגיל עובד לכם לאט או להטמעה באתרים אחרים (באישור בלבד)</p>
    <br/>
    <a href=".">לגרסא הרגילה</a>
</div>
<div style="display:none;">
    <a href="">תרמו לפרויקט</a>
</div>
<div style="display:none;">
    <a href="">תנאי שימוש וזכויות יוצרים</a>
</div>

<div style="padding-bottom:100px;" dir="ltr"><%
response.Flush

'INSERT TO SEARCH HISTORY / STATS'
If len(strDisplay)>0 then
    startTime = timer()
    'openDB "arabicSearch"
    openDbLogger "arabicSearch","O","default.min.asp","search history",strClean

    mySQL = "SELECT id,searchCount FROM wordsSearched WHERE typed='"&strDisplay&"'"
    res.open mySQL, con
    if res.EOF then
        mySQL = "INSERT into wordsSearched(typed) VALUES('"&strDisplay&"')"
    else
        mySQL = "UPDATE wordsSearched SET searchCount="&(res("searchCount")+1)&" WHERE typed='"&strDisplay&"'"
    end if
    res.close
    con.execute mySQL

    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicSearch","C","default.min.asp","search history",durationMs,strClean
end if %>
</div>