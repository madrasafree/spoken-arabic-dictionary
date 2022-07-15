<!--#include file="inc/inc.asp"--><%
dim countMe, nikud, order
order = "pos"
Select case Left(Request("order")&"p",1)
    Case "a": order = "arabicWord"
    Case "e": order = "pronunciation"
    Case "h": order = "hebrewTranslation"
End select
countMe = 0
nikud = "" %>

<!DOCTYPE html>
<html style="height:100%;">
<head>
    <title>אינדקס נושאים</title>
	<meta name="Description" content="אינדקס נושאים" />
    <!--#include file="inc/header.asp"-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <style>
        .tag {display:inline-block; cursor:pointer; margin:15px 0;}
    </style>
</head>
<body>

<!--#include file="inc/top.asp"-->
<div id="pTitle">
    אינדקס נושאים
    <div style="font-size:.7em;">
        גודל הקישור ממחיש את כמות המילים
    </div>
</div>
<div class="table">
    <!-- TAG CLOUD-->
    <div id="tagsCloud">
        <ul><%
        dim x,tagSize

        startTime = timer()
        'openDB "arabicWords"
        openDbLogger "arabicWords","O","labels.asp","single",""

        mySQL = "SELECT * FROM labels ORDER BY labelName"
        res.open mySQL, con
            Do until res.EOF
                mySQL = "SELECT count(wordID) FROM wordsLabels WHERE labelID="&res("ID")
                res2.open mySQL, con
                    x = res2(0)
                    SELECT Case true
                        case x>=0 AND x<=10
                        tagSize = "0.8em"
                        case x>=11 AND x<=30
                        tagSize = "1em"
                        case x>=31 AND x<=70
                        tagSize = "1.3em"
                        case x>=71 AND x<=120
                        tagSize = "1.5em"
                        case x>=121 AND x<=180
                        tagSize = "1.7em"
                        case x>=180 AND x<=300
                        tagSize = "1.9em"
                        case else
                        tagSize = "2.4em"
                    END SELECT
                res2.close %>
                <li style="font-size:<%=tagSize%>;" title="ישנן <%=x%> מילים בנושא זה" style="font-size:<%=tagSize%>">
                    <a href="label.asp?id=<%=res("id")%>"><%=res("labelName")%></a>
                </li><%
                res.moveNext
            Loop
        res.close
        
        endTime = timer()
        durationMs = Int((endTime - startTime)*1000)
        'closeDB
        closeDbLogger "arabicWords","C","labels.asp","single",durationMs,""
        
        %>
        </ul>
    </div>
</div>


<!--#include file="inc/trailer.asp"-->