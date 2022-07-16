<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "team/login.asp" %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX, FOLLOW">
    <title>כל המילים במילון</title>
	<meta name="Description" content="כל המילים במילון בדף אחד" />
    <!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"--><%
dim suggest, order, pLetter
order = "hebrewTranslation"
Select case Left(Request("order")&"h",1)
    Case "e": order = "pronunciation"
    Case "a": order = "arabicWord"
End select
%>

<div id="pTitle">כל המילים במילון</div>
<br />
<div class="table" style="text-align:center;">
    <b>דף זה עלול לעלות לאט</b>, מכיוון שהוא מכיל את כל המילים במילון
</div>

<br>
<div id="simpleList"><%


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","admin.listAllWords.asp","single",""

	mySQL = "SELECT words.id, arabicWord, hebrewTranslation, pronunciation, userName FROM words LEFT JOIN " & _
	    "(SELECT * FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T " & _
	    "ON words.creatorID=T.ID WHERE words.show ORDER BY "& order
	    res.open mySQL, con
	    Do until res.EOF
            if left(res("hebrewTranslation"),1) <> pLetter then %>
                <span class="letter"><%=left(res("hebrewTranslation"),1)%></span> <%
            end if %>
            <div class="simpleDiv" onclick="location.href='word.asp?id=<%=res("id")%>'">
                <span class="heb"><%=res("hebrewTranslation")%></span>
                <span class="arb"><% 
                    dim ht
                    ht=res("arabicWord")
                    if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
                        ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
                    end if %>
                    <%=ht%>
                </span>
                <span class="eng"><%=res("pronunciation")%></span>
            </div><%
		    pLetter = left(res("hebrewTranslation"),1)
            res.moveNext
	    Loop
	    res.close 
        
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","admin.listAllWords.asp","single",durationMs,""
        
        
        %>
</div>
<br>
<!--#include file="inc/trailer.asp"-->