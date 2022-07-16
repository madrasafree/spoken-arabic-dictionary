<!--#include file="inc/inc.asp"--><%
'BUG (line 47): loginTimeUTC IS A MESS (in DB)! day & month get mixed up. CHANGE FORMAT
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
    <title>מתנדבי המילון</title>
      <meta charset="UTF-8">

	<meta name="Description" content="הכירו את המתנדבים של מילון ערבית מדוברת />
    <!--#include file="inc/header.asp"-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>
        $(document).ready(function(){
            // COUNTS HOW MANY USERS IN TOTAL
            var cnt = $("#countMe").data("count");
            if (cnt > 1) $("#pt").html(cnt + ' חברי המילון ');
        });
    </script>
    <style>
    #userCount {font-size:initial;}
    .users {text-align: center;}
    .users img {width:60px; border-radius:50%; opacity: .8; padding:3px;}
    .users img:hover {border-radius:0%; opacity: 1;}
    </style>
</head>
<body>

<!--#include file="inc/top.asp"-->
<div id="pTitle">
    <div id="pt"></div>
</div>
<div style="width:95%; margin:0 auto;">
    <div class="users"><%
        dim pic
        countMe = 1

        startTime = timer()
        'openDB "arabicUsers"
        openDbLogger "arabicUsers","O","users.asp","single",""
        

        mySQL = "SELECT * FROM users WHERE id NOT IN (2,5,6,7,36,37,48) ORDER BY name"
'*<BUG>*  loginTimeUTC IS A MESS!! day & month get mixed up. CHANGE FORMAT *<BUG>*'
        res.open mySQL, con
            Do until res.EOF
                if res("picture")=true then 
                    pic=res("id")
                else
                    if res("gender")=1 then
                        pic="male"
                    else
                        pic="female"
                    end if
                end if %>
                <a href="profile.asp?id=<%=res("id")%>">
                    <img src="img/profiles/<%=pic%>.png" title="<%=res("username")%>" />
                </a><%
                countMe = countMe+1
                res.moveNext
            Loop
        res.close %>
    </div>
    <span id="countMe" data-count="<%=countMe%>"></span>
    <div dir="ltr" style="margin-top:20px;"><%
        dim psik
        psik = ""
        mySQL = "SELECT * FROM users WHERE id NOT IN (2,5,6,7,36,37,48) ORDER BY username"
        res.open mySQL, con
            Do until res.EOF %>
                <%=psik%>
                <span style="text-align:left;">
                    <a href="profile.asp?id=<%=res("id")%>"><%=res("username")%></a>
                </span><%
                psik = " - "
                res.moveNext
            Loop
        res.close 
        
        endTime = timer()
        durationMs = Int((endTime - startTime)*1000)
        'closeDB
        closeDbLogger "arabicUsers","C","users.asp","single",durationMs,""
        
        
        %>
    </div>

</div>
<!--#include file="inc/trailer.asp"-->