<!--#include file="inc/inc.asp"-->
<!--#include file="inc/time.asp"--><%
dim x, total %>
<!DOCTYPE html>
<html>
<head>
	<title>דף צוות ראשי</title>
    <META NAME="ROBOTS" CONTENT="NONE">
<!--#include file="inc/header.asp"-->
    <style>

        #topNav {
        Z-Index: 5;
        display: flex;
        align-items: center;
        top: 0;
        height: 40px;
        background: white;
        width: 100%;
        padding: 10px;
        border-bottom: 1px solid gray;
        }


        #topNav > div {
        display: inline-block;
        margin-right: 5px;
        }

        #menuBtn {
        padding-right: 20px;
        cursor:pointer;
        }

        .material-icons {
        background: white;
        color: gray;
        padding: 7px;
        border-radius: 50%;
        border: 1px solid;
        cursor: pointer;
        }

        #searchInput {
        border: 1px solid gray;
        border-radius: 10px;
        width: 100%;
        display: flex;
        overflow: hidden;
        }

        #searchInput input{
            width: calc(100% - 70px);
        }
        #searchInput input,
        #searchInput button {
        border: 0;
        padding: 10px;
        }








        #searchBoxTop {
            border: solid gray;
            border-width: 1px 1px 1px 0;
            border-radius: 0 10px 10px 0;
            }
        h1 {font-size:1em; display:inline-block;}
        h2 {font-size:1em;}

        #mainMenu, #myMenu {display:none;}
        #mainMenu ul, #myMenu ul {
            list-style:none;
            margin:0;
            padding:10px 20px;
        }
        
        #menus {
            Z-INDEX:9;
            width:200px;
            position:fixed; right:30px; top:30px;  line-height:1.4;}
        #menusBG {
            display:none;
            Z-INDEX:5;
            position:fixed;
            top:0;
            right:0;
            height:100vh;
            width:100vw;
            background:#5a7a9ab8;
            }

        #dashboard  { width:500px; margin:0 auto; }
        .new {background-color: white; text-align: center; font-size: 3em; cursor: pointer;border: rgb(186, 218, 246) 1px solid; border-radius: 30px; margin: 0 auto; width: 98%;}
        .new a:visited, .new a:link {color: rgb(65, 145, 194);}
        #stats {display: table; width: 100%; margin-top:20px;}
        #stats > div {display: table-row;}
        #stats > div:not(:first-of-type) {cursor: pointer;}
        #stats span {display: table-cell; padding:8px 12px; text-align: right;}
        #stats span:nth-child(3n) {font-size: small;}
        #stats > div:first-of-type > span {border-bottom: 1px solid rgb(180, 180, 180);}
        #stats > div > span:first-of-type {width: 30%;}

        @media (max-width:520px) {
            #dashboard {width: 320px;}
            #stats > div > span:first-of-type {width: auto;}

            #menus {
                width:initial;
                left:30px;
            }
            #menusBG {
                background:#5a7a9a;
            }
        }
    </style>
    <script>        
        $(document).ready(function(){
            

            $("#menuBtn").click(function(){
                $("#menusBG").fadeToggle("fast");
                $("#myMenu").slideToggle();
                $("#mainMenu").slideToggle();                
            });

            $("#searchIcon").click(function(){
                $("#searchBar").fadeToggle();
                $("h1").toggle();
                if ($(this).text() == 'search' ) {
                    $("#searchBoxTop").focus();
                    $(this).text('close');
                    $(this).css('color','#b10707');
                    $(this).css('background','#ff00001f');
                }else{
                    $(this).text('search');
                    $(this).css('color','gray');
                    $(this).css('background','#ffffff');
                }
            });
        });
    </script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script>
      google.setOnLoadCallback(drawChart);
      function drawChart() {

        var data = google.visualization.arrayToDataTable([
          ['סטטוס', 'מספר מילים'],
          ['טרם נבדקו',1522],
          ['חשד לטעות',5],
          ['נמצאו תקינות',488]
        ]);

        var options = {
          title: 'תקינות המילים'
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart'));

        chart.draw(data, options);
      }
    </script>
</head>
<body>
<!--#include file="inc/topTeam.asp"-->
<div id="dashboard" style="padding-top:20px;">
    <h1>דף צוות ראשי</h1>


    <div id="stats">
        <h2>סטטיסטיקה</h2><%

        dim edits7days


        startTime = timer()
        'openDB "arabicWords"
        openDbLogger "arabicWords","O","TEST.team.old.asp","single",""

        mySQL = "SELECT count(*) FROM (SELECT word FROM history WHERE actionUTC > '"& AR2UTC(DateAdd("d",-7,now)) &"' AND actionUTC < '"& AR2UTC(now) &"' GROUP BY word);"
        res.open mySQL, con
            edits7days = res(0)
        res.close

        mySQL="SELECT COUNT(*) FROM words"
        res.open mySQL, con
            total = res(0)
        res.close%>
        <div style="background-color: rgba(173, 173, 173, 0.25);">
            <span>סך כל המילים:</span>
            <span><%=FormatNumber(total,0)%>
            </span>
            <span>(100%)</span>
        </div>
        <br/>
        <div style="background-color: rgba(173, 173, 173, 0.25);">
            <span>עריכות בשבוע האחרון:</span>
            <span><%=FormatNumber(edits7days,0)%>
            </span>
        </div>
        <br/>
        <div onclick="location.href='list.asp?status=1'" style="background-color: rgba(0, 128, 0, 0.13); color: green;">
            <span>נמצאו תקינות:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=1"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close%>
            </span>
            <span>
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <div onclick="location.href='list.asp?status=2'" style="background-color: rgba(255, 0, 0, 0.2); color: rgb(164, 22, 22);">
            <span>חשד לטעות:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=-1"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close%>
            </span>
            <span dir="ltr">
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <div onclick="location.href='list.asp?status=0'" style="background-color: rgba(255, 255, 0, 0.31); color: rgb(147, 147, 10);">
            <span>טרם נבדקו:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM words WHERE status=0"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close%>
            </span>
            <span>
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <br/>
        <div onclick="location.href='listHidden.asp'" style="background-color: rgba(173, 173, 173, 0.25); margin-top:20px;">
            <span>מילים מוסתרות:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM words WHERE show=off"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close%>
            </span>
            <span>
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <br/>
        <div style="background-color: rgba(0, 35, 128, 0.13); color:#5a85ad; margin-top:20px;">
            <span>עם ערבית:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM words WHERE show AND arabic IS NOT NULL"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close%>
            </span>
            <span>
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <div onclick="location.href='listNoArabic.asp'" style="background-color: rgba(0, 35, 128, 0.21); color:#5a85ad; margin-top:20px;">
            <span>ללא ערבית:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM words WHERE show AND arabic IS NULL"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close%>
            </span>
            <span>
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <br/><% 
            mySQL="SELECT COUNT(*) FROM words WHERE (partOfSpeach=1 OR partOfSpeach=2) AND number=1 AND show=true"
            res.open mySQL, con
                total = res(0)
            res.close %>
        <div style="background-color: rgba(0, 35, 128, 0.13); color:#5a85ad; margin-top:20px;">
            <span>משויכים לרבים:</span>
            <span><% 
                mySQL="SELECT COUNT(*) FROM wordsRelations WHERE relationType=3"
                res.open mySQL, con
                    response.write FormatNumber(res(0),0)
                    x = res(0)
                res.close %> (מתוך <%=FormatNumber(total,0)%>)
            </span>
            <span>
                (<%=round((x/total)*100,1)%>%)
            </span>
        </div>
        <div onclick="location.href='listNoPlural.asp'" style="background-color: rgba(0, 35, 128, 0.21); color:#5a85ad; margin-top:20px;">
            <span>לא משויכים:</span>
            <span><%=FormatNumber(total-x,0)%> (מתוך <%=FormatNumber(total,0)%>)
            </span>
            <span>
                (<%=100-(round((x/total)*100,1))%>%)
            </span>
        </div>
        <br/><% 
            mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=3 AND show=true"
            res.open mySQL, con
                total = res(0)
            res.close %>
        <div style="background-color: rgba(0, 35, 128, 0.13); color:#5a85ad; margin-top:20px;">
                <span>פעלים עם בניין:</span>
                <span><% 
                    mySQL="SELECT COUNT(*) FROM words WHERE partOfSpeach=3 AND binyan>0"
                    res.open mySQL, con
                        response.write FormatNumber(res(0),0)
                        x = res(0)
                    res.close %> (מתוך <%=FormatNumber(total,0)%>)
                </span>
                <span>
                    (<%=round((x/total)*100,1)%>%)
                </span>
            </div>
            <div onclick="location.href='listNoBinyan.asp'" style="background-color: rgba(0, 35, 128, 0.21); color:#5a85ad; margin-top:20px;">
                <span>ללא בניין:</span>
                <span><%=FormatNumber(total-x,0)%> (מתוך <%=FormatNumber(total,0)%>)
                </span>
                <span>
                    (<%=100-(round((x/total)*100,1))%>%)
                </span>
            </div>
        </div><%
        
        endTime = timer()
        durationMs = Int((endTime - startTime)*1000)
        'closeDB
        closeDbLogger "arabicWords","C","TEST.team.old.asp","single",durationMs,""


        %>

    <!-- DISABLED [display:none] UNTIL READY - GOOGLE CHARTS -->
    <script type="text/javascript" src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1.1','packages':['corechart']}]}"></script>
    <div id="piechart" style="display:none;width: 500px; height: 300px;"></div>

</div>
<!--#include file="inc/trailer.asp"-->
</body>
</html>