<!--#include virtual="/includes/inc_team.asp"--><%

'1=ronen ; 73=yaniv
If (session("userID")<>1) and (session("userID")<>73) and (session("userID")<>90) then 
    session("msg") = "לקבלת הרשאה להוספת אודיו ווידאו לאתר, פנו למנהל האתר"
    response.Redirect "login.asp"
end if %>

<!DOCTYPE html>
<html>
<head>
	<title>דף שליטה במדיה</title>
    <meta name="robots" content="none">
<!--#include virtual="/includes/header.asp"-->
    <style>
        .mediaTableWrap {overflow-x: auto; width: 100%;}
        .mediaTable {width:100%; display: table; font-size:small;text-align:center; border:2px solid #ddd; margin:10px auto; min-width: 900px;}
        .mTableR {display: table-row;}
        .mTableR > div {display: table-cell; text-overflow: ellipsis; padding: 3px; border-bottom:1px solid #ccc; min-width: 60px; white-space: nowrap;}
        .mTableR > div:nth-child(3) {max-width: 100px; overflow: hidden;}
        .mTableR > div:nth-child(4) {min-width: 120px; white-space: normal; text-align: right;}
        .mTableR > div:nth-child(5) {min-width: 100px; white-space: normal; text-align: right;}
    </style>
</head>
<body>
<!--#include virtual="/includes/top.asp"-->

<div style="width:95%;max-width:100%;margin:10px auto;box-sizing:border-box;">
    <div id="pTitle"><h1>דף שליטה במדיה</h1></div>

    <div><a href="mediaNew.asp">הוסף מדיה חדשה</a></div>

    <div class="mediaTableWrap">
    <div dir="" class="mediaTable">
        <div class="mTableR" style="background: #eee;">
            <div>ID</div>
            <div>סוג</div>
            <div>קישור</div>
            <div>מה נאמר - תעתיק</div>
            <div>מילים משויכות</div>
            <div>קרדיט</div>
            <div>קרדיט לחיץ?</div>
            <div>דובר/ת</div>
            <div>מוסיפ/ת הקישור</div>
            <div>תאריך הוספה</div>
            <div>עדכון אחרון</div>
            <div>עריכה</div>
        </div><%


        'openDB "arabicWords"
        openDbLogger "arabicWords","O","mediaControl.asp","single",""


        mySQL = "SELECT * FROM media ORDER BY id DESC"
        res.open mySQL, con 
            do until res.EOF %>
            <div class="mTableR">
                <div><%=res("id")%></div>
                <div><%
                    Select Case res("mType")
                        Case 1 %>
                            <a href="http://www.youtube.com/watch?v=<%=res("mLink")%>" target="youtube">YouTube</a><%
                        Case 21 %>
                            <a href="http://clyp.it/<%=res("mLink")%>" target="clyp.it">clyp.it</a><%
                        Case 22 %>
                            soundcloud<%
                        Case 23 %>
                            local ogg<%
                    End Select %>
                </div>
                <div><%=res("mLink")%></div>
                <div dir="rtl" style="text-align:right;"><%=res("description")%></div>
                <div style="text-align:right;"><%
                    mySQL = "SELECT wordID,hebrewTranslation FROM wordsMedia INNER JOIN words ON wordsMedia.wordID=words.id WHERE mediaID="&res("id")
                    res2.open mySQL, con
                    do until res2.EOF %>
                        <div style="display:inline-block;direction:rtl;"><a href="../word.asp?id=<%=res2("wordID")%>" style="padding-left:6px;"><%=res2("hebrewTranslation")%></a></div><%
                        res2.movenext
                    loop
                    res2.close %>
                </div>
                <div><%=res("credit")%></div>
                <div><%if len(res("creditLink"))>0 then %>Yes<%else%>No<%end if%></div>
                <div><%=res("speaker")%></div>
                <div><%=res("uploader")%></div>
                <div><%=res("creationTime")%></div>
                <div><%=res("lastUpdateUTC")%></div>
                <div><a href="mediaEdit.asp?id=<%=res("id")%>">edit</a></div>
            </div><%
                res.movenext
            loop
        res.close 
        
        'closeDB
        closeDbLogger "arabicWords","C","mediaControl.asp","single",durationMs,""
        
        
        %>
    </div>
    </div>

</div>
<!--#include virtual="/includes/trailer.asp"-->