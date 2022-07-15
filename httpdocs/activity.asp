<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%


startTime = timer()
'openDB "arabicWords" 
openDbLogger "arabicWords","O","activity.asp","single",""

dim a,x,i,nowUTC,actionUTC,actionClass

'LABELS' NAMES for EDITED WORD - EXTRA INFO
dim lblCNT
mySQL = "SELECT COUNT(id) FROM labels"
res.open mySQL, con
    lblCNT = res(0)
res.close

redim labelNames(lblCNT)

mySQL = "SELECT * FROM labels"
res.open mySQL, con
    do while not res.EOF
        labelNames(i) = res("labelName")
        i=i+1
        res.movenext
    loop
res.close

mySQL = "SELECT now() FROM words"
res.open mySQL, con
    nowUTC = res(0)
    nowUTC = DateAdd("h",7,nowUTC)
res.close

%>
<!DOCTYPE html>
<html>
<head>
	<title>פעולות אחרונות באתר</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        #dashboard {max-width:500px; margin:0 auto;}
        .actions {
            width:95%;
            max-width:400px;
            margin: 0 auto;}
        .actTable {margin:10px auto; background:#ffffff99; padding:10px; border:1px dotted #88abcc; border-radius:0 10px;} 
        .changeTop {
            margin:10px auto 0px auto;
            display: flex;
            align-items:center;
            justify-content:space-between;
            border-width: 1px 1px 1px 4px ;
            border-style:solid;
            background: white;
            padding: 10px;
            }
        .newWords {border-color:#bcb68f; background:#bcb68f20;}
        .edits {border-color:DARKSEAGREEN; background:#8fbc8f20;}
        .lists {border-color:#9c8fbc; background:#9c8fbc20;}
        .fieldRow {margin:3px auto;}
        .moreInfo {
            cursor:pointer;
            background: DARKSEAGREEN;
            border-radius: 50%;
            color: white;
            }
        .activeUserImg {background: white; width: 40px; border-radius: 50%; bottom: 50px; right: 10px;}

        .old {background:#fbc3c387;} 
        .new {background:#c3defb87;}
        .old,.new {
            padding: 0px 5px 3px 5px;
            border-radius: 4px;
        }
        .cntr {
            top: 8px;
            position: relative;
            }

        @media (max-width:400px) {
            #dashboard {width:100%;}
        }

    </style>
<!--#include file="inc/header.asp"-->
    <script>
        $(document).ready(function(){

            $(".actTable").hide();
            $(".moreInfo").html("expand_more")
            
            // HIDES / UNHIDES nearest .actTable
            $(".moreInfo").click(function(){
                $(".actTable").slideUp();
                if ($(this).html()=="expand_less"){
                    $(".moreInfo").html("expand_more");
                } else {
                    $(".moreInfo").html("expand_more");
                    $(this).html("expand_less");
                    $(this).parents(".changeTop").next().slideToggle();
                }
            });

            // SORT .actions DIVS by Date. Descending
            $(".actions").sort(sort_li).appendTo("#dashboard");

        });

        function sort_li(b, a){
        return ($(b).data('time')) < ($(a).data('time')) ? 1 : -1;    
}
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="dashboard">
    <div id="pTitle">פעולות אחרונות באתר</div>
    <div class="notice info" style="text-align:center;">
        <div style="padding:10px;margin-bottom:10px;">
            <div style="font-weight:bold; font-size:large;">תודה!!</div>
            לכל מתנדבי התוכן שעוזרים להגדיל ולשפר את המילון
        </div>
    </div><%
        actionClass="lists"
        mySQL="SELECT TOP 10 * FROM (SELECT * FROM lists LEFT JOIN (SELECT ID,username,picture,gender FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON lists.creator=T.ID ORDER BY lastUpdateUTC DESC)"
        res.open mySQL, con
        do until res.EOF
            actionUTC = res("lastUpdateUTC")
            actionUTC = Replace(actionUTC,"T"," ")
            actionUTC = Replace(actionUTC,"Z","")  %>
            <div class="actions" data-time="<%=res("lastUpdateUTC")%>">
                <div class="changeTop <%=actionClass%>">                
                    <div style="line-height:0; padding-left:15px;">
                        <a href="profile.asp?id=<%=res("T.ID")%>" title="<%=res("username")%>"><% 
                            if res("picture")=true then %>
                                <img class="activeUserImg" src="img/profiles/<%=res("T.ID")%>.png" /><%
                            else %>
                                <span class="material-icons" style="font-size:40px;">account_box</span><%
                            end if %>
                        </a>
                    </div>
                    <div style="flex-grow:1;">
                        <div style="font-size:small;">
                            <span style="color:#aaa;" title="lastUpdateUTC = <%=res("lastUpdateUTC")%> | nowUTC = <%=nowUTC%>"><%
                                call secPast(actionUTC,nowUTC) %>
                            </span>
                            - <a href="profile.asp?id=<%=res("T.ID")%>" style="font-weight:bold;"><%=res("username")%></a>
                            - <span>עריכת רשימה</span>
                        </div>
                        <div><%
                            if res("privacy")>1 or res("T.ID")=session("userID") then %>
                            <b><a href="lists.asp?id=<%=res("lists.id")%>">
                                <%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%>
                            </a></b><%
                            else %>
                                <small>[רשימה שאינה פומבית]</small><%
                            end if %>                
                            <span class="material-icons" style="float:left;"><%
                                select case res("privacy")
                                    case 0 %>lock<%
                                    case 1 %>lock_open<%
                                    case 2 %>public<%
                                    case 3 %>group<%
                                end select %>
                            </span>
                        </div>
                    </div>
                </div>
            </div><%
            res.moveNext
        loop
        res.close

        actionClass="newWords"
        mySQL="SELECT TOP 20 * FROM (SELECT * FROM words LEFT JOIN (SELECT ID,username,picture,gender FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON words.[creatorID]=T.ID WHERE show ORDER BY words.ID DESC)"
        res.open mySQL, con
        Do until res.EOF
            actionUTC = res("creationTimeUTC")
            actionUTC = Replace(actionUTC,"T"," ")
            actionUTC = Replace(actionUTC,"Z","") %>
            <div class="actions" data-time="<%=res("creationTimeUTC")%>">
                <div class="changeTop <%=actionClass%>">                
                    <div style="line-height:0; padding-left:15px;">
                        <a href="profile.asp?id=<%=res("T.ID")%>" title="<%=res("username")%>"><% 
                            if res("picture")=true then %>
                                <img class="activeUserImg" src="img/profiles/<%=res("T.ID")%>.png" /><%
                            else %>
                                <span class="material-icons" style="font-size:40px;">account_box</span><%
                            end if %>
                        </a>
                    </div>
                    <div style="flex-grow:1;">
                        <div style="font-size:small;">
                            <span style="color:#aaa;" title="creationTimeUTC = <%=res("creationTimeUTC")%> | nowUTC = <%=nowUTC%>"><%
                                call secPast(actionUTC,nowUTC) %>
                            </span>
                            - <a href="profile.asp?id=<%=res("T.ID")%>" style="font-weight:bold;"><%=res("username")%></a>
                            - <span>מילה חדשה</span>
                        </div>
                        <div>
                            <div style="font-weight:bold;"><a href="word.asp?id=<%=res("words.id")%>">
                                <%=res("hebrewTranslation")%></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div><%
            res.movenext
        loop
        res.close


        actionClass="edits"
        mySQL="SELECT TOP 30 * FROM (SELECT * FROM history LEFT JOIN (SELECT ID,username,picture,gender FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON history.[user]=T.ID ORDER BY actionUTC DESC)"
        res.open mySQL, con
        Do until res.EOF 
            actionUTC = res("actionUTC")
            actionUTC = Replace(actionUTC,"T"," ")
            actionUTC = Replace(actionUTC,"Z","") %>
            <div class="actions" data-time="<%=res("actionUTC")%>">
                <div class="changeTop <%=actionClass%>">                
                    <div style="line-height:0; padding-left:15px;">
                        <a href="profile.asp?id=<%=res("T.ID")%>"><% 
                            if res("picture") then %>
                                <img class="activeUserImg" title="<%=res("username")%>" src="img/profiles/<%=res("T.ID")%>.png" /><%
                            else %>
                                <span class="material-icons" style="font-size:40px;">account_box</span><%
                            end if %>
                        </a>
                    </div>
                    <div style="flex-grow:1;">
                        <div style="font-size:small;">
                            <span style="color:#aaa;" title="actionUTC = <%=actionUTC%> | nowUTC = <%=nowUTC%>"><%
                                call secPast(actionUTC,nowUTC) %>
                            </span>
                            - <a href="profile.asp?id=<%=res("T.ID")%>" style="font-weight:bold;"><%=res("username")%></a>
                            - <span>עריכת מילה</span>
                        </div>
                        <div>
                            <div>
                                <span style="font-weight:bold;"><a href="word.asp?id=<%=res("word")%>"><%
                                if res("hebrewNew")<>"" then%>
                                    <%=res("hebrewNew")%><%
                                else
                                    mySQL = "SELECT hebrewTranslation FROM words WHERE id="&res("word")
                                    if not res.EOF then
                                        res2.open mySQL, con
                                            response.write res2(0)
                                        res2.close
                                    else
                                        response.write "<b>res.EOF</b>"
                                    end if
                                end if %></a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div style="line-height:0;">
                        <span class="moreInfo material-icons" style="font-size:24px;">expand_more</span>
                    </div>
                </div>
                            
                <div class="actTable" id="action<%=res(0)%>"><%
                if res("explain")<>"" then %>
                    <div style="text-align:center;">
                        <span style="font-size:small;">הסבר לעריכה:</span> 
                        <span style="color:gray; font-style:italic;">"<%=res("explain")%>"</span>
                    </div><%
                else %>&nbsp;<%
                end if %><%

                if res("hebrewNew")<>res("hebrewOld") then %>
                <div class="fieldRow">
                    <span class="field">עברית</span>
                    <span class="old"><%=res("hebrewOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("hebrewNew")%></span>
                </div><%
                end if

                if res("hebrewDefNew")<>res("hebrewDefOld") then %>
                <div class="fieldRow">
                    <span class="field">פירושון</span>
                    <span class="old"><%=res("hebrewDefOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("hebrewDefNew")%></span>
                </div><%
                end if

                if res("arabicNew")<>res("arabicOld") then%>
                <div class="fieldRow">
                    <span class="field">ערבית</span>
                    <span class="old"><%=res("arabicOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("arabicNew")%></span>
                </div><%
                end if
                    
                if res("arabicWordNew")<>res("arabicWordOld") then%>
                <div class="fieldRow">
                    <span class="field">תעתיק עברי</span>
                    <span class="old"><%=res("arabicWordOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("arabicWordNew")%></span>
                </div><%
                end if

                if res("pronunciationNew")<>res("pronunciationOld") then%>
                <div class="fieldRow">
                    <span class="field">תעתיק לועזי</span>
                    <span dir="ltr" class="old" style="white-space:nowrap;"><%=res("pronunciationOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span dir="ltr" class="new" style="white-space:nowrap;"><%=res("pronunciationNew")%></span>
                </div><%
                end if

                if res("statusNew")<>res("statusOld") then %>
                <div class="fieldRow">
                    <span class="field">סטטוס</span>
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
                    <span class="material-icons cntr">keyboard_backspace</span>
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
                </div><%
                end if 

                if res("showNew")<>res("showOld") then %>
                <div class="fieldRow">
                    <span class="field">תצוגה</span>
                    <span class="old"><%
                        if res("showOld")=True then %>מוצג<%else%>מוסתר<%end if%>
                    </span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%
                        if res("showNew")=True then %>מוצג<%else%>מוסתר<%end if%>
                    </span>
                </div><%
                end if

                if res("searchStringNew")<>res("searchStringOld") then%>
                <div class="fieldRow">
                    <span class="field">מילות חיפוש</span>
                    <span class="old"><%=res("searchStringOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("searchStringNew")%></span>
                </div><%
                end if

                if res("rootNew")<>res("rootOld") then%>
                <div class="fieldRow">
                    <span class="field">צורת מקור</span>
                    <span class="old"><%=res("rootOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("rootNew")%></span>
                </div><%
                end if

                if res("partOfSpeachNew")<>res("partOfSpeachOld") then%>
                <div class="fieldRow">
                    <span class="field">חלק דיבר</span>
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
                    <span class="material-icons cntr">keyboard_backspace</span>
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
                </div><%
                end if

                if res("binyanNew")<>res("binyanOld") then %>
                <div class="fieldRow">
                    <span class="field">בניין</span>
                    <span class="old"><%=res("binyanOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("binyanNew")%></span>
                </div> <%
                end if
                
                if res("genderNew")<>res("genderOld") then%>
                <div class="fieldRow">
                    <span class="field">מין</span>
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
                    <span class="material-icons cntr">keyboard_backspace</span>
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
                </div><%
                end if

                if res("numberNew")<>res("numberOld") then%>
                <div class="fieldRow">
                    <span class="field">מספר</span>
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
                    <span class="material-icons cntr">keyboard_backspace</span>
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
                </div><%
                end if

                if res("infoNew")<>res("infoOld") then%>
                <div class="fieldRow">
                    <span class="field">הערות</span>
                    <span class="old"><%=res("infoOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("infoNew")%></span>
                </div><%
                end if

                if res("exampleNew")<>res("exampleOld") then%>
                <div class="fieldRow">
                    <span class="field">דוגמאות</span>
                    <span class="old"><%=res("exampleOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("exampleNew")%></span>
                </div><%
                end if

                if res("imgLinkNew")<>res("imgLinkOld") then%>
                <div class="fieldRow">
                    <span class="field">קישור לתמונה</span>
                    <span class="old" style="font-size:small;word-break:break-all;"><%=res("imgLinkOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new" style="font-size:small;word-break:break-all;"><%=res("imgLinkNew")%></span>
                </div><%
                end if

                if res("imgCreditNew")<>res("imgCreditOld") then%>
                <div class="fieldRow">
                    <span class="field">קרדיט תמונה</span>
                    <span class="old" style="font-size:small;"><%=res("imgCreditOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new" style="font-size:small;"><%=res("imgCreditNew")%></span>
                </div><%
                end if

                if res("linkDescNew")<>res("linkDescOld") then%>
                <div class="fieldRow">
                    <span class="field">סוג קישור</span>
                    <span class="old"><%=res("linkDescOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("linkDescNew")%></span>
                </div><%
                end if

                if res("linkNew")<>res("linkOld") then%>
                <div class="fieldRow">
                    <span class="field">קישור</span>
                    <span class="old"><%=res("linkOld")%></span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%=res("linkNew")%></span>
                </div><%
                end if

                if res("labelsNew")<>res("labelsOld") then%>
                <div class="fieldRow">
                    <span class="field">תגיות</span>
                    <span class="old"><%
                        if res("labelsOld")<>"" then
                            a=Split(res("labelsOld"),",")
                            for each x in a
                                response.write(labelNames(x) & "; ")
                            next
                        else %>&nbsp;<%
                        end if %>
                    </span>
                    <span class="material-icons cntr">keyboard_backspace</span>
                    <span class="new"><%
                        if res("labelsNew")<>"" then
                            a=Split(res("labelsNew"),",")
                            for each x in a
                                response.write(labelNames(x) & "; ")
                            next
                        else %>&nbsp;<%
                        end if %>
                    </span>
                </div><%
                end if %>
            </div>
        </div> <%
        res.movenext
    loop
    res.close %>
</div><%

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","activity.asp","single",durationMs,""

%>



<!--#include file="inc/trailer.asp"-->
</body>
</html>