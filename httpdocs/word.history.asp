<!--#include file="inc/inc.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/time.asp"--><%

dim wordId
dim timePast,creationTimeUTC,creatorID,userName
dim actionUTC, nowUTC


wordId = request("id")



startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","word.history.asp","single",wordId

mySQL = "SELECT now() FROM words"
res.open mySQL, con
    nowUTC = res(0)
    nowUTC = DateAdd("h",7,nowUTC)
res.close

dim lblCNT
mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
    lblCNT = res(0)
res.close

redim labelNames(lblCNT)
dim a,x,i
i=1


mySQL = "SELECT * FROM labels"
res.open mySQL, con
    do while not res.EOF
        labelNames(i) = res("labelName")
        'labelNames(i) = "ok"
        i=i+1
        res.movenext
    loop
res.close


mySQL = "SELECT * FROM words LEFT JOIN " & _
	"(SELECT * FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T " & _
	"ON words.creatorID=T.ID WHERE words.id = "&wordId&" ORDER BY arabicWord"
res.open mySQL, con
    creationTimeUTC = res("creationTimeUTC")
    creatorID = res("creatorID")
    userName = res("userName")
res.close



%>
<!DOCTYPE html>
<html style="height:100%;">
<head>
<!--#include file="inc/header.asp"-->
    <title>היסטורית עריכות מילה</title>
    <meta property="og:title" content="היסטורית עריכות מילה" />
    <meta property="og:type" content="website" />
    <link rel="stylesheet" href="team/inc/arabicTeam.css" />
    <style>
        .backButton {
            background:white;
            border:1px solid gray;
            padding:10px;
        }
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div class="table" style="margin-bottom:40px;">
    <a href="word.asp?id=<%=wordId%>" class="backButton">חזרה לדף המילה</a>
</div>

<div id="editHistory" class="table team">
<%


    mySQL="SELECT TOP 50 * FROM (SELECT * FROM history LEFT JOIN (SELECT ID,username FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON history.[user]=T.ID WHERE history.word="&wordId&" ORDER BY actionUTC DESC)"
    res.open mySQL, con
    Do until res.EOF
        actionUTC = res("actionUTC")
        actionUTC = Replace(actionUTC,"T"," ")
        actionUTC = Replace(actionUTC,"Z","")  %>
        <div class="changeDiv">
            <div class="changeTop">
                <span title="<%=res("actionUTC")%>" style="width:70px;"><%
                    timePast = dateDiff("s",actionUTC,nowUTC)
                    if timePast =< 60 then
                        response.write "לפני " &timepast& " שניות"
                    else
                        if timePast =< 86400 then
                            if timepast/60 < 60 then 
                                response.write "לפני " &round(timepast/60)& " דקות"
                            else
                                response.write "לפני " &round(timepast/60/60)& " שעות"
                            end if
                        else
                            if timePast =< 172800 then
                                response.write "אתמול"
                            else
                                response.write FormatDateTime(actionUTC,1)
                            end if
                        end if
                    end if%>
                </span>
                <span style="font-weight:bold;"><%
                    Select Case res("action")
                    Case 1
                        response.write "איפוס סטטוס תקינות"
                    Case 2
                        response.write "סימון טעות או חשד לטעות"
                    Case 3
                        response.write "נבדק ונמצא תקין"
                    Case 4
                        response.write "בוצעה עריכה"                        
                    Case 5
                        response.write "הוסתר"
                    Case 6
                        response.write "ביטול הסתרה"
                    Case 7
                        response.write "העברה לארכיב"
                    Case 8
                        response.write "החזרה מארכיב" 
                    End Select %>
                </span><%
                if res("explain")<>"" then %>
                    <span> (הסבר לפעולה: <%=res("explain")%>)</span><%
                end if %>
                <span>ע"י</span>
                <span><a href="profile.asp?id=<%=res("T.ID")%>" target="user"><%=res("username")%></a></span>
                <!--<label>סוגי שגיאות</label>
                <span><%=res("errorTypes")%></span>-->
            </div><%
            Select Case res("action")
            Case 2 
                if len(res("errorTypes"))>0 then %>
                    <ul><%
                    dim errorCount, errorArray
                    errorArray = split(res("errorTypes"),",")
                    errorCount = ubound(errorArray)
                    for i=0 to errorCount
                        mySQL="SELECT errorType FROM errorTypes WHERE ID="&errorArray(i) 
                        res2.open mySQL, con %>
                        <li>
                            <%=res2(0)%>
                        </li><%
                        res2.close
                    next %>
                    </ul><%
                else
                    'REQUIRES FURTHER ATTENTIONS'
                    response.write "חסר מידע על סוג הטעות"
                end if
            Case 4 %>
                <div class="hisTable"><%

                    if res("hebrewNew")<>res("hebrewOld") then %>
                    <div>
                        <span class="field">עברית</span>
                        <span class="new"><%=res("hebrewNew")%></span>
                        <span class="old"><%=res("hebrewOld")%></span>
                    </div><%
                    end if

                    if res("arabicNew")<>res("arabicOld") then%>
                    <div>
                        <span class="field">ערבית</span>
                        <span class="new"><%=res("arabicNew")%></span>
                        <span class="old"><%=res("arabicOld")%></span>
                    </div><%
                    end if
                    
                    if res("arabicWordNew")<>res("arabicWordOld") then%>
                    <div>
                        <span class="field">תעתיק עברי</span>
                        <span class="new"><%=res("arabicWordNew")%></span>
                        <span class="old"><%=res("arabicWordOld")%></span>
                    </div><%
                    end if

                    if res("pronunciationNew")<>res("pronunciationOld") then%>
                    <div>
                        <span class="field">תעתיק לועזי</span>
                        <span class="new"><%=res("pronunciationNew")%></span>
                        <span class="old"><%=res("pronunciationOld")%></span>
                    </div><%
                    end if

                    if res("statusNew")<>res("statusOld") then %>
                    <div>
                        <span class="field">סטטוס</span>
                        <span class="new"><%
                            Select Case res("statusNew")
                            Case 1
                                response.write "תקין"
                            Case 0
                                response.write "לא נבדק"
                            Case -1
                                response.write "טעות"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                        <span class="old"><%
                            Select Case res("statusOld")
                            Case 1
                                response.write "תקין"
                            Case 0
                                response.write "לא נבדק"
                            Case -1
                                response.write "טעות"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                    </div><%
                    end if 

                    if res("showNew")<>res("showOld") then %>
                    <div>
                        <span class="field">תצוגה</span>
                        <span class="new"><%
                            if res("showNew")=True then %>מוצג<%else%>מוסתר<%end if%>
                        </span>
                        <span class="old"><%
                            if res("showOld")=True then %>מוצג<%else%>מוסתר<%end if%>
                        </span>
                    </div><%
                    end if

                    if res("searchStringNew")<>res("searchStringOld") then%>
                    <div>
                        <span class="field">מילות חיפוש</span>
                        <span class="new"><%=res("searchStringNew")%></span>
                        <span class="old"><%=res("searchStringOld")%></span>
                    </div><%
                    end if

                    if res("rootNew")<>res("rootOld") then%>
                    <div>
                        <span class="field">צורת מקור</span>
                        <span class="new"><%=res("rootNew")%></span>
                        <span class="old"><%=res("rootOld")%></span>
                    </div><%
                    end if

                    if res("partOfSpeachNew")<>res("partOfSpeachOld") then%>
                    <div>
                        <span class="field">חלק דיבר</span>
                        <span class="new"><%
                            Select Case res("partOfSpeachNew")
                            Case 0
                                response.write "לא ידוע / אחר"
                            Case 1
                                response.write "שם עצם"
                            Case 2
                                response.write "שם תואר"
                            Case 3
                                response.write "פועל"
                            Case 4
                                response.write "תואר הפועל"
                            Case 5
                                response.write "מילית יחס"
                            Case 6
                                response.write "מילת חיבור"
                            Case 7
                                response.write "מילת קריאה"
                            Case 8
                                response.write "תחילית"
                            Case 9
                                response.write "סופית"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                        <span class="old"><%
                            Select Case res("partOfSpeachOld")
                            Case 0
                                response.write "לא ידוע / אחר"
                            Case 1
                                response.write "שם עצם"
                            Case 2
                                response.write "שם תואר"
                            Case 3
                                response.write "פועל"
                            Case 4
                                response.write "תואר הפועל"
                            Case 5
                                response.write "מילית יחס"
                            Case 6
                                response.write "מילת חיבור"
                            Case 7
                                response.write "מילת קריאה"
                            Case 8
                                response.write "תחילית"
                            Case 9
                                response.write "סופית"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                    </div><%
                    end if

                    if res("binyanNew")<>res("binyanOld") then %>
                    <div>
                        <span class="field">בניין</span>
                        <span class="new"><%=res("binyanNew")%></span>
                        <span class="old"><%=res("binyanOld")%></span>
                    </div> <%
                    end if

                    if res("genderNew")<>res("genderOld") then%>
                    <div>
                        <span class="field">מין</span>
                        <span class="new"><%
                            Select Case res("genderNew")
                            Case 0
                                response.write "נטרלי"
                            Case 1
                                response.write "זכר"
                            Case 2
                                response.write "נקבה"
                            Case 3
                                response.write "לא ידוע / לא רלוונטי"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                        <span class="old"><%
                            Select Case res("genderOld")
                            Case 0
                                response.write "נטרלי"
                            Case 1
                                response.write "זכר"
                            Case 2
                                response.write "נקבה"
                            Case 3
                                response.write "לא ידוע / לא רלוונטי"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                    </div><%
                    end if

                    if res("numberNew")<>res("numberOld") then%>
                    <div>
                        <span class="field">מספר</span>
                        <span class="new"><%
                            Select Case res("numberNew")
                            Case 0
                                response.write "בלתי ספיר"
                            Case 1
                                response.write "יחיד"
                            Case 2
                                response.write "זוגי"
                            Case 3
                                response.write "רבים"
                            Case 4
                                response.write "לא נבחר"
                            Case 5
                                response.write "לא רלוונטי"
                            Case 6
                                response.write "שם קיבוצי"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                        <span class="old"><%
                            Select Case res("numberOld")
                            Case 0
                                response.write "בלתי ספיר"
                            Case 1
                                response.write "יחיד"
                            Case 2
                                response.write "זוגי"
                            Case 3
                                response.write "רבים"
                            Case 4
                                response.write "לא נבחר"
                            Case 5
                                response.write "לא רלוונטי"
                            Case 6
                                response.write "שם קיבוצי"
                            Case else
                                response.write "<b>מידע שגוי! פנה למנהל האתר.</b>"
                            End Select %>
                        </span>
                    </div><%
                    end if

                    if res("infoNew")<>res("infoOld") then%>
                    <div>
                        <span class="field">הערות</span>
                        <span class="new"><%=res("infoNew")%></span>
                        <span class="old"><%=res("infoOld")%></span>
                    </div><%
                    end if

                    if res("exampleNew")<>res("exampleOld") then%>
                    <div>
                        <span class="field">דוגמאות</span>
                        <span class="new"><%=res("exampleNew")%></span>
                        <span class="old"><%=res("exampleOld")%></span>
                    </div><%
                    end if

                    if res("imgLinkNew")<>res("imgLinkOld") then%>
                    <div style="word-wrap:break-word;">
                        <span class="field">קישור לתמונה</span>
                        <span class="new"><%=res("imgLinkNew")%></span>
                        <span class="old"><%=res("imgLinkOld")%></span>
                    </div><%
                    end if

                    if res("imgCreditNew")<>res("imgCreditOld") then%>
                    <div>
                        <span class="field">קרדיט תמונה</span>
                        <span class="new"><%=res("imgCreditNew")%></span>
                        <span class="old"><%=res("imgCreditOld")%></span>
                    </div><%
                    end if

                    if res("linkDescNew")<>res("linkDescOld") then%>
                    <div>
                        <span class="field">סוג קישור</span>
                        <span class="new"><%=res("linkDescNew")%></span>
                        <span class="old"><%=res("linkDescOld")%></span>
                    </div><%
                    end if

                    if res("linkNew")<>res("linkOld") then%>
                    <div>
                        <span class="field">קישור</span>
                        <span class="new"><%=res("linkNew")%></span>
                        <span class="old"><%=res("linkOld")%></span>
                    </div><%
                    end if

                    if res("labelsNew")<>res("labelsOld") then%>
                    <div>
                        <span class="field">תגיות</span>
                        <span class="new"><%
                            if res("labelsNew")<>"" then
                                a=Split(res("labelsNew"),",")
                                for each x in a
                                    response.write(labelNames(x) & "; ")
                                next
                            end if %>
                        </span>
                        <span class="old"><%
                            if res("labelsOld")<>"" then
                                a=Split(res("labelsOld"),",")
                                for each x in a
                                    response.write(labelNames(x) & "; ")
                                next
                            end if %>
                        </span>
                    </div><%
                    end if %>
            </div><%

            Case 7
                response.write "שליחה לארכיב"
            Case 8
                response.write "החזרה מארכיב" 
            End Select %>
        </div> <%
        res.movenext
    loop%>
    <div class="changeDiv">
        <span class="field" title="<%=creationTimeUTC%>"><%=Str2hebDate(creationTimeUTC)%> <b>המילה נוספה למילון</b> ע"י <a href="profile.asp?id=<%=creatorID%>"><%=userName%></a></span>
    </div><%
    res.close 
    
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicWords","C","word.history.asp","single",durationMs,wordId
    
    %>
</div>

<!--#include file="inc/trailer.asp"-->