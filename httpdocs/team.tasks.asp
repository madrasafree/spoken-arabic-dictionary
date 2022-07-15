<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>משימות</title>
    <!--#include file="inc/header.asp"-->
    <style>
        #newTask {
            font-size: initial;
            font-weight: initial;
            padding: 5px 20px;
            background: #eae65d;
            float: left;
            }
        #editTask {
            margin-left:20px;
            padding: 5px 20px;
            background: #eae65d;
            }
        #tasks ul {
            list-style-type:none;
            list-style: none;
            padding:0;
            border-top: 1px dashed #9fa1a2;
            }
        .task {
            cursor:pointer;
            padding: 8px 6px 8px 0px;
            background: white;
            font-family: 'Alef', sans-serif;
            border-bottom: 1px dashed #9fa1a2;
            }

        .task[data-private="True"] {color:#f30e0e;}
        #taskVotes[data-myVote="True"] {
            background: #e5f1ff;
            border-color: #7994b2;
            }

        .vote {
            text-align:left;
            background: #eae65d;
            padding: 5px 10px;
            margin: 5px 0 0 20px;
            }

        #sort {
            padding: 5px 10px;
            border-radius: 20px;
            border-color: #808080;
            }
        #sort:focus, #filterToggle:focus {outline:none;}
        #sort option {min-height:1.5em;}

        #filterToggle,#filterSubmit {
            background-color: #7994b2;
            border: none;
            color: white;
            padding: 8px 30px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            letter-spacing: 0.2em;
            }

        #filterSubmit {
            border-radius: 10px;
            padding: 4px 8px;
            letter-spacing: initial;
        }

        #filterOptions {
                padding: 5px;
                border-style: solid;
                border-color: #7994b2;
                border-image: initial;
                background: #7994b22e;
                display: block;
                border-width: 1px 0 3px 0;
                margin-top: 4px;
            }

        .priority {font-size:small; margin-right:5px;}
        .urgent {color:#b70b0b80;}
        .important {color:#ff980080;}
        .regular,.low {color:#aaaaaa80;}

        #taskTitle {font-size:large;}
        .taskStatus { 
            display:table-cell;
            width:25%;
            border-radius:0px; 
            padding:0px 4px;
            text-align:center;
            }
        [data-status="1"] .taskStatus {color:white; background: #479B35;}
        [data-status="2"] .taskStatus {color:#2d6121; background: #9CDA8E;}
        [data-status="3"] .taskStatus {color:#1f1c04; background: #B9AE40;}
        [data-status="9"] .taskStatus {color:#504b0f; background: #E4DA72;}
        [data-status="15"] .taskStatus {color:#6b0a6b; background: #FFF7A6;}
        [data-status="42"] .taskStatus {color:#1483c3; background: #e2fbff;}
        [data-status="88"] .taskStatus {color:#790a0a; background: #ff00002b;}
        [data-status="99"] .taskStatus {color:#565656; background: #0000003b;}
        
        .taskMore {display:none;}
        .taskNotes {
            margin: 4px 0px 4px 10px;
            border-right: 2px solid gray;
            padding: 6px 9px;
            background: #efefef;
            font-style: italic;
            font-size: small;
            }
        .subTasks {background:whitesmoke; margin: 10px 40px 10px 20px; padding: 4px 24px; border-radius: 10px;}
        #taskVotes {
            display:table-cell;
            width: 8%;
            text-align: center;
            padding: 0px 4px 2px 4px;
            background: white;
            border: 1px dotted lightgray;
            }
        #taskSection {
            display:table-cell;
            width:25%;
            text-align:center;
            border:0px solid gray;
            background:#eeeeee44;
            }
        #taskType {
            display:table-cell;
            width:25%;
            text-align:center;
            border:0px solid gray;
            background:#eeeeee;
            }

        .done {color:#80808099; list-style:none; text-indent:-1.2em;}
        .done::before {content: "\2714\0020";}

    </style>
    <script>
        $(document).ready(function(){
            //STARTING POSITIONS
            $("#filterOptions").hide(); //hide filter panel
            filterDefault(); //checkbox bottons to default
            filterSubmit(); // submit filter

            //Toggle FILTER PANEL
            $("#filterToggle").click(function(){
                $("#filterOptions").slideToggle();
            });

            //SELECT / CLEAR ALL
            $("#filter2").click(function(){
                if ($("#filter2").is(":checked")) { // if 'select all' checked
                    $("#filterOptions input[type=checkbox]").prop("checked",true); // select all
                    $("#filter1").prop("checked",false);
                    $("#filter3").prop("checked",false);
                } else {
                    $("#filterOptions input[type=checkbox]").prop("checked",false); // clear all
                }
            });

            //FILTER - DEFAULT
            $("#filter1").click(function(){
                if ($("#filter1").is(":checked")) filterDefault();
            });

            function filterDefault(){
                $("#filterOptions input[type=checkbox]").prop("checked",true);
                $("#filter2").prop("checked",false);
                $("#filter3").prop("checked",false);
                $("#status42").prop("checked",false);
                $("#status99").prop("checked",false);
            }

            //FILTER - CUSTOM
            $("#choices input[type=checkbox]").click(function(){ // if click on checkbox inside 'choices' table
                $("#filter1").prop("checked",false); // uncheck 'default'
                $("#filter2").prop("checked",false); // uncheck 'all'
                $("#filter3").prop("checked",true); // check 'custom' 
            });

            $("#allStatus").click(function(){
                if ($("#allStatus").is(":checked")) {
                    $("input[id*='status']").prop("checked",true);
                } else {
                    $("input[id*='status']").prop("checked",false);
                }
            });

            $("#allPriorities").click(function(){
                if ($("#allPriorities").is(":checked")) {
                    $("input[id*='priority']").prop("checked",true);
                } else {
                    $("input[id*='priority']").prop("checked",false);
                }
            });

            $("#allTypes").click(function(){
                if ($("#allTypes").is(":checked")) {
                    $("input[id*='type']").prop("checked",true);
                } else {
                    $("input[id*='type']").prop("checked",false);
                }
            });

            $("#allSections").click(function(){
                if ($("#allSections").is(":checked")) {
                    $("input[id*='section']").prop("checked",true);
                } else {
                    $("input[id*='section']").prop("checked",false);
                }
            });
            
            //FILTER - SUBMIT
            $("#filterSubmit").click(function(){
                filterSubmit();
                $("#filterOptions").slideToggle();
            });

            function filterSubmit(){
                if ($("#filter2").is(":checked")) { // if 'select all'
                    $("#tasksUL").children().show(); // show all tasks
                } else {
                    $("#tasksUL").children().show(); // hide all tasks
                    

                    // run 1st time - Type
                    var isChecked = [] //CREATE var
                    $("input[name^='type']:checked").each(function () // for each checked type input
                    {
                        isChecked.push(Number.parseInt($(this).val())); // insert value to array
                    });
                    $("#tasksUL .task").each(function(index,element){ // for each task
                        if (!isChecked.includes($(element).data("type"))) { // if data-type is in array
                            $(element).hide() // HIDE task
                        };
                    });

                    // run 2nd time - Status
                    isChecked = [] //clear var
                    $("input[name^='status']:checked").each(function () // for each checked status input
                    {
                        isChecked.push(Number.parseInt($(this).val())); // insert value to array
                    });
                    $("#tasksUL .task").each(function(index,element){ // for each task
                        if (!isChecked.includes($(element).data("status"))) { // if data-status is in array
                            $(element).hide() // HIDE task
                        };
                    });

                    // run 3nd time - Priority
                    isChecked = [] //clear var
                    $("input[name^='priority']:checked").each(function () // for each checked proprity input
                    {
                        isChecked.push(Number.parseInt($(this).val())); // insert value to array
                    });
                    $("#tasksUL .task").each(function(index,element){ // for each task
                        if (!isChecked.includes($(element).data("priority"))) { // if data-priority is NOT in array
                            $(element).hide() // HIDE task
                        };
                    });

                    // run 4th time - Section
                    isChecked = [] //clear var
                    $("input[name^='section']:checked").each(function () // for each checked section input
                    {
                        isChecked.push(Number.parseInt($(this).val())); // insert value to array
                    });
                    $("#tasksUL .task").each(function(index,element){ // for each task
                        if (!isChecked.includes($(element).data("section"))) { // if data-section is in array
                            $(element).hide() // HIDE task
                        };
                    });

                console.log("all tasks:" + $(".task").length);
                console.log("hidden tasks:" + $(".task[style='display: none;']").length);

                }
            }
            

            var dataValue
            // SORT tasks acording to user's preferece
            $("#sort").change(function(){
                dataValue = this.value;
                if (dataValue == "priority" || dataValue == "status"){ 
                    $("#tasks .task").sort(sort_list_desc).appendTo("#tasksUL");
                } else {
                    $("#tasks .task").sort(sort_list).appendTo("#tasksUL");                
                }
            });

            function sort_list(b, a){           
            return ($(b).data(dataValue)) < ($(a).data(dataValue)) ? 1 : -1;    
            }

            function sort_list_desc(b, a){
                //console.log({a,b});
            return ($(b).data(dataValue)) > ($(a).data(dataValue)) ? 1 : -1;    
            }

            // TOGGLE more info
            $(".task").click(function(){
                $(this).children(".taskMore").slideToggle();
            });



        });
    </script>

</head>
<body>
<!--#include file="inc/top.asp"--><%
dim taskVotes
 %>

<div class="table" id="tasks">
    <h1>משימות <%
        if (session("role")=15) then %>
        <span id="newTask"><a href="team.task.new.asp">משימה חדשה</a></span><%
        end if %>
    </h1>
    <table style="width:100%;">
        <tr>
            <td style="padding:5px;"> 
                <label for="sort">מיון לפי:</label>

                <select id="sort">
                    <option value="edit">עריכה אחרונה</option>
                    <option value="status">סטטוס טיפול</option>
                    <option value="votes">דירוג משתמשים</option>
                    <option value="priority">דחיפות</option>
                    <option value="id">מס"ד</option>
                </select>            
            </td>
            <td style="text-align:left;">
                <button id="filterToggle">סינון</button>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div id="filterOptions">
                    <div style="text-align:left;">
                        <input id="filterSubmit" type="submit" value="אישור">
                    </div>    
                    <table style="width:90%; margin:10px auto;">
                        <tr style="vertical-align:top;">
                            <td>
                                <input type="checkbox" id="filter1" name="filter1" value="default">
                                <label for="filter1">ברירת מחדל</label>
                                <br/>
                                <input type="checkbox" id="filter3" name="filter3" value="custom" DISABLED>
                                <label for="filter3">מותאם אישית</label>
                                <br/>
                                <br/>
                            </td>
                            <td>
                                <input type="checkbox" id="filter2" name="filter2" value="showAll" checked>
                                <label for="filter2">הצג / נקה הכל</label>
                                <br/>
                                <br/>
                            </td>
                        </tr>
                        <tr id="choices">
                            <td style="vertical-align:top;">
                                <br/>
                                <input type="checkbox" id="allStatus" name="allStatus" value="allStatus">
                                <label for="allStatus"><u>סטטוס:</u></label>
                                <br/>
                                <input type="checkbox" id="status1" name="status1" value="1">
                                <label for="status1">בטיפול</label>
                                <br/>
                                <input type="checkbox" id="status2" name="status2" value="2">
                                <label for="status2">לפני הפרויקט הבא</label>
                                <br/>
                                <input type="checkbox" id="status3" name="status3" value="3">
                                <label for="status3">הפרויקט הבא</label>
                                <br/>
                                <input type="checkbox" id="status9" name="status9" value="9">
                                <label for="status9">עתידי</label>
                                <br/>
                                <input type="checkbox" id="status15" name="status15" value="15">
                                <label for="status15">הצעות ורעיונות</label>
                                <br/>
                                <input type="checkbox" id="status42" name="status42" value="42">
                                <label for="status42">בוצע</label>
                                <br/>
                                <input type="checkbox" id="status99" name="status99" value="99">
                                <label for="status99">בוטל</label>
                                <br/>
                                <br/>
                                <input type="checkbox" id="allTypes" name="allTypes" value="allTypes">
                                <label for="allTypes"><u>סוגים:</u></label>
                                <br/>
                                <input type="checkbox" id="type1" name="type1>" value="1">
                                <label for="type1">מנהלה</label>
                                <br/>
                                <input type="checkbox" id="type10" name="type10>" value="10">
                                <label for="type10">קוד - פיצ'ר חדש</label>
                                <br/>
                                <input type="checkbox" id="type11" name="type11>" value="11">
                                <label for="type11">קוד - שיפורים</label>
                                <br/>
                                <input type="checkbox" id="type12" name="type12>" value="12">
                                <label for="type12">קוד - באגים</label>
                                <br/>
                                <input type="checkbox" id="type20" name="type20>" value="20">
                                <label for="type20">תוכן - ערכים במילון</label>
                                <br/>
                                <input type="checkbox" id="type21" name="type21>" value="21">
                                <label for="type21">תוכן - מולטימדיה</label>
                                <br/>
                                <input type="checkbox" id="type29" name="type29>" value="29">
                                <label for="type29">תוכן - אחר</label>
                                <br/>
                                <input type="checkbox" id="type0" name="type0>" value="0">
                                <label for="type0">לא משויך</label>
                            </td>
                            <td style="vertical-align:top;">
                                <br/>
                                <input type="checkbox" id="allPriorities" name="allPriorities" value="allPriorities">
                                <label for="allPriorities"><u>דחיפות:</u></label>
                                <br/>
                                <input type="checkbox" id="priority1" name="priority1" value="1">
                                <label for="priority1">דחוף</label>
                                <br/>
                                <input type="checkbox" id="priority2" name="priority2" value="2">
                                <label for="priority2">חשוב</label>
                                <br/>
                                <input type="checkbox" id="priority3" name="priority3" value="3">
                                <label for="priority3">רגיל</label>
                                <br/>
                                <input type="checkbox" id="priority5" name="priority5" value="5">
                                <label for="priority5">נמוך</label>
                                <br/>
                                <input type="checkbox" id="priority99" name="priority99" value="99">
                                <label for="priority99">ללא</label>
                                <br/>
                                <br/>
                                <input type="checkbox" id="allSections" name="allSections" value="allSections">
                                <label for="allSections"><u>חלק באתר:</u></label>
                                <br/>
                                <input type="checkbox" id="section1" name="section1>" value="1">
                                <label for="section1">מנוע חיפוש</label>
                                <br/>
                                <input type="checkbox" id="section2" name="section2>" value="2">
                                <label for="section2">דף מילה</label>
                                <br/>
                                <input type="checkbox" id="section3" name="section3>" value="3">
                                <label for="section3">רשימות אישיות</label>
                                <br/>
                                <input type="checkbox" id="section4" name="section4>" value="4">
                                <label for="section4">רשימות קבועות</label>
                                <br/>
                                <input type="checkbox" id="section5" name="section5>" value="5">
                                <label for="section5">משחקים</label>
                                <br/>
                                <input type="checkbox" id="section6" name="section6>" value="6">
                                <label for="section6">משפטים</label>
                                <br/>
                                <input type="checkbox" id="section0" name="section0>" value="0">
                                <label for="section0">אחרים</label>
                            </td>
                        </tr>
                    </table>

                </div>
            </td>
        </tr>
    </table>
    <ul id="tasksUL"><%
    

    startTime = timer()
    'openDB "arabicManager"
    openDbLogger "arabicManager","O","team.tasks.asp","single",""

    if (session("role")=15) then
        mySQL = "SELECT * FROM tasks ORDER BY dateEdit DESC"
    else
        mySQL = "SELECT * FROM tasks WHERE private = off ORDER BY dateEdit DESC"
    end if
    res.open mySQL, con
    if res.EOF then %>
        <li>לא נמצאו משימות</li>
        <%
    else
        do until res.EOF
        
            mySQL = "SELECT votes FROM tasksVotes WHERE taskID="&res("id")
            res2.open mySQL, con
                if res2.EOF then taskVotes = 0 else taskVotes = res2(0)
            res2.close
         %> 
            <li class="task" data-edit="<%=right(iso2nums(res("dateEdit")),12)%>" data-private="<%=res("private")%>" data-type="<%=res("type")%>" data-section="<%=res("section")%>" data-votes="<%=taskVotes%>" data-priority="<%=res("priority")%>" data-id="<%=res("id")%>" data-status="<%=res("status")%>"><%
            SELECT CASE res("priority")
            case 1 %>
                <span title="דחוף" class="priority urgent">⬤</span><%
            case 2 %>
                <span title="חשוב" class="priority important">⬤</span><%
            case 3 %>
                <span title="רגיל" class="priority regular">⬤</span><%
            case 5 %>
                <span title="נמוך" class="priority low">◯</span><%
            case else %>
                <span title="לא נבחרה רמת דחיפות" class="priority low">⊗</span><%
            END SELECT %>
                <span id="taskTitle" style="margin-right:5px;"><%=res("title")%></span>
                <div class="taskMore"><%
                    if len(res("notes"))>0 then %>
                    <div class="taskNotes"><%=res("notes")%></div><%
                    end if
                    if res("img") then %>
                        צילום מסך:
                        <div style="text-align:left; padding:0 30px 0 10px;">
                            <img src="img/tasks/<%=res("id")%>.jpg" alt="תמונה או צילום מסך להמחשת המשימה" style="width:100%; border:1px solid #d4e7fb;">
                        </div><%
                    end if %>
                    <ol class="subTasks"><%
                    mySQL = "SELECT * FROM subTasks WHERE task ="&res("id")&" ORDER BY place"
                    res2.open mySQL, con
                        if res2.EOF then %>
                            <div style="text-align:center;">לא נמצאו תת-משימות</div><%
                        else
                            do until res2.EOF %>
                                <li <%
                                if res2("isDone") then%> class="done"<%end if%>><%=res2("title")%></li><%
                                res2.moveNext
                            loop
                        end if
                    res2.close %>
                    </ol>
                    <div style="text-align:left; margin-left:20px; font-size:small;">
                        <div title="<%=res("dateStart")%>">פתיחה: <%=left(res("dateStart"),10)%></div><%
                        if res("dateStart") <> res("dateEdit") then %>
                        <div title="<%=res("dateEdit")%>">עריכה: <%=left(res("dateEdit"),10)%></div><%
                        end if
                        if res("status")=42 then %>
                        <div title="<%=res("dateEnd")%>">סיום: <%=left(res("dateEnd"),10)%></div><%
                        end if %>
                        <div>מס"ד: <%=res("id")%></div>
                    </div><%
                    dim userID,myVote
                    if session("userID") then userID = session("userID") else userID = 0
                    mySQL = "SELECT * FROM tasksVoting WHERE taskID = "&res("id")&" AND userID = "&userID
                    res2.open mySQL, con
                    if res2.EOF then 
                        myVote = false %>
                    <div style="margin:0 20px 20px 0;">
                        <span class="vote" title="הצבעה בעד קידום משימה זו">
                            <a href="team.task.vote.asp?tID=<%=res("ID")%>&vote=up">
                                הצבעת תמיכה במשימה זו
                            </a>
                        </span>
                    </div><%
                    else 
                        myVote = true %>
                    <div style="margin:0 20px 20px 0;">
                        <span class="vote" title="הסרת הצבעה בעד קידום משימה זו">
                            <a href="team.task.vote.asp?tID=<%=res("ID")%>&vote=down">
                            הסרת הצבעת תמיכה במשימה זו
                            </a>
                        </span>
                    </div><%
                    end if 
                    res2.close %><%
                    if session("userID")=1 then %>
                    <div style="margin:0 20px 20px 0;">
                        <span id="editTask">
                            <a href="team.task.edit.asp?id=<%=res("id")%>">
                                <span class="material-icons" style="font-size:13px;">edit</span> עריכה
                            </a>
                        </span>
                    </div><%
                    end if %>
                </div>
                <div id="taskBottom" style="display:table; width:100%; padding-top:5px; font-size: small;">
                    <div style="display:table-row;">
                        <div style="display:table-cell; width:5%;">&nbsp;
                        </div>
                        <div id="taskType" title="סוג משימה"><%
                            SELECT CASE res("type") 
                                case 1 %>מנהלה<%
                                case 10 %>קוד - פיצ'ר חדש<%
                                case 11 %>קוד - שיפורים<%
                                case 12 %>קוד - באגים<%
                                case 20 %>תוכן - ערכים במילון<%
                                case 21 %>תוכן - מולטימדיה<%
                                case 29 %>תוכן - אחר<%
                                case 0 %>לא משויך<%
                            END SELECT %>
                        </div>
                        <div id="taskSection" title="חלק באתר"><%
                            SELECT CASE res("section") 
                                case 1 %>מנוע חיפוש<%
                                case 2 %>דף מילה<%
                                case 3 %>רשימות אישיות<%
                                case 4 %>רשימות קבועות<%
                                case 5 %>משחקים<%
                                case 6 %>משפטים<%
                                case 0 %>אחר<%
                            END SELECT %>
                        </div>
                        <div class="taskStatus" title="סטטוס טיפול"><%
                            SELECT CASE res("status")
                                case 1 %>בטיפול<%
                                case 2 %>לפני הפרויקט הבא<%
                                case 3 %>הפרויקט הבא<%
                                case 9 %>עתידי<%
                                case 15 %>הצעות ורעיונות<%
                                case 42 %>בוצע<%
                                case 99 %>בוטל<%
                            END SELECT %>
                        </div>
                        
                        <div style="display:table-cell;width:8%;">&nbsp;</div>
                        <div id="taskVotes" data-myVote="<%=myVote%>" title="דירוג משתמשים">
                            <%=taskVotes%>
                        </div>
                        <div style="display:table-cell; width:5%;">&nbsp;</div>
                    </div>
                </div>
            </li><%
            res.movenext
        loop
    end if
    res.close 
    
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicManager","C","team.tasks.asp","single",durationMs,""
    
    %>
    </ul>
</div>
<!--#include file="inc/trailer.asp"-->