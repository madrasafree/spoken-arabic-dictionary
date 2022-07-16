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
    <title>הרשימות שלכם</title>
	<meta name="Description" content="רשימות מילים" />
    <!--#include file="inc/header.asp"-->
    <style>
        h2 {margin: 0 4px 4px 0; font-size:1.2em; letter-spacing:0.1em; font-weight:100;}
        button {margin:4px; min-width:50px; border-radius:20px; border:0px; background:#bad7f3; color:#3e3e3e; padding:4px 10px; box-shadow:#00000047 1px 1px;}
        button:hover {box-shadow:#00000097 2px 2px;}
        .hidden {display:none;}
        .showMore {float:left;}
        .listsWrapper {display:flex; flex-wrap:wrap; max-width:1000px; margin:0 auto;justify-content:center;}
        .listsWrapper > div {display:flex; flex-wrap:wrap; justify-content:center; width:700px;}
        .lists {width:320px; margin:5px auto; background:#6ab4fb36; padding:5px;}
        
        .lists > div , .lists > a {display:flex; justify-content:space-between; position:relative; min-height:30px; margin-bottom:5px; padding:2px 10px; background:white; border-radius:0 10px 0 0;}
        .lists > div:hover {background:#fff786; cursor:pointer; color:#2d2d2d; box-shadow:-2px 1px 2px #00000037;}
        .lists > div > span {position:relative; top:15%;}
        .listName {font-size:1em; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; padding-left:25px;}
        .listData {min-width:70px; font-size:0.75em; padding-top:3px; text-align:left;}
        .listsMine {background:#84d45c36;}
        .listsSaved {background:#84d45c36;}
        .listsNew {background:#fb936a36;}
        .listsPop {background:#fb936a36;}
        
    </style>
    <script>
        $(document).ready(function(){
            // HIDES / UNHIDES
            $(".hidden").hide();
            $(".showMore").click(function(){
                $(this).parents(".lists").find(".hidden").slideToggle();
                return false;
            });
        });
    </script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
</head>
<body>
<!--#include file="inc/time.asp"-->
<!--#include file="inc/top.asp"--><%
startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","lists.all.asp","multi. Break down","" %>


<div id="pTitle">
    הרשימות שלכם
</div>

<div class="listsWrapper">
    <div>
        <div class="lists listsMine">
        <h2>רשימות שיצרתי</h2><%
        if session("userID") then
            mySQL = "SELECT * FROM lists WHERE creator="&session("userID")&" ORDER BY listName"
            res.open mySQL, con
            if res.EOF then %>
                <div>עוד לא יצרת אף רשימה.
                <br/>מעניין מה הכפתור הזה פה למטה עושה</div><%
            else
                i=0
                do until res.EOF %>
                    <div<%if i>4 then%> class="hidden"<%end if%> onclick="location.href='lists.asp?id=<%=res("id")%>';">
                        <span class="listName"><%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%></span>
                        <span class="material-icons" style="float:left;"><%
                            select case res("privacy")
                             case 0 %>lock<%
                             case 1 %>lock_open<%
                             case 2 %>public<%
                             case 3 %>group<%
                             end select %>
                        </span>
                    </div><%
                    res.moveNext
                    i = i+1
                loop 
                if i>5 then %>
                    <button class="showMore listsMine" style="background:#84d45c66;">⇵</button><%
                end if
            end if %>
            <button class="listsMine" style="background:#84d45c66;" onclick="location.href='listsNew.asp';">רשימה חדשה</button><%
            res.close 
        else %>
            <a style="display:block;" href="login.asp?returnTo=lists.all.asp">לחצו כאן כדי להתחבר</a>
            <%
        end if%>
        </div>

        <div class="lists listsSaved">
        <h2>המועדפים שלי</h2><%
        if session("userID") then
            mySQL = "SELECT * FROM lists INNER JOIN listsUsers ON lists.ID=listsUsers.list WHERE user="&session("userID")&" ORDER BY pos"
            res.open mySQL, con
            if res.EOF then %>
                <div>עוד לא שמרת אף רשימה</div><%
            else
                i=0
                do until res.EOF %>
                    <div<%if i>4 then%> class="hidden"<%end if%> onclick="location.href='lists.asp?id=<%=res("id")%>';">
                        <span class="listName"><%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%></span>
                        <span class="material-icons" style="float:left;"><%
                            select case res("privacy")
                             case 0 %>lock<%
                             case 1 %>lock_open<%
                             case 2 %>public<%
                             case 3 %>group<%
                             end select %>
                        </span>
                    </div><%
                    res.moveNext
                    i = i+1
                loop
                if i>5 then %>
                    <button class="showMore listsSaved" style="background:#84d45c66;">⇵</button><%
                end if
            end if
            res.close 
        else %>
            <a style="display:block;" href="login.asp?returnTo=lists.all.asp">לחצו כאן כדי להתחבר</a>
            <%
        end if%>
        </div>
    </div>
    <div>
        <div class="lists listsNew">
            <h2>הכי חדשות</h2><%
            i=0
            mySQL = "SELECT TOP 10 * FROM lists WHERE privacy > 1 ORDER BY id DESC"
            res.open mySQL, con
            do until res.EOF %>
                <div<%if i>4 then%> class="hidden"<%end if%> onclick="location.href='lists.asp?id=<%=res("id")%>';">
                    <span class="listName" title="<%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%>"><%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%></span>
                    <span class="listData"><%=left(res("creationTimeUTC"),10)%>
                        <span class="material-icons" style="float:left;"><%
                            select case res("privacy")
                             case 0 %>lock<%
                             case 1 %>lock_open<%
                             case 2 %>public<%
                             case 3 %>group<%
                             end select %>
                        </span>
                    </span>
                </div><%
                res.moveNext
                i=i+1
            loop
            if i>5 then %>
            <button class="showMore listsNew" style="background:#fb936a66;">⇵</button><%
            end if
        res.close %>
        </div>

        <div class="lists listsPop">
            <h2>הכי נצפות</h2><%
            i=0
            mySQL = "SELECT TOP 10 * FROM lists WHERE privacy > 1 ORDER BY viewCNT DESC"
            res.open mySQL, con
            do until res.EOF %>
                <div<%if i>4 then%> class="hidden"<%end if%> onclick="location.href='lists.asp?id=<%=res("id")%>';">
                    <span class="listName" title="<%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%>"><%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%></span>
                    <span class="listData" title="מספר צפיות"><%=formatNumber(res("viewCNT"),0)%>
                        <span class="material-icons" style="float:left;"><%
                            select case res("privacy")
                             case 0 %>lock<%
                             case 1 %>lock_open<%
                             case 2 %>public<%
                             case 3 %>group<%
                             end select %>
                        </span>
                    </span>
                </div><%
                res.moveNext
                i=i+1
            loop
            if i>5 then %>
            <button class="showMore listsPop" style="background:#fb936a66;">⇵</button><%
            end if
            res.close %>
        </div>

    <%
if session("userID")=1 then 
dim i
mySQL = "SELECT count(id) FROM lists"
res.open mySQL, con %>

<h3>אינדקס רשימות אישיות</h3>
<div style="max-width:600px; margin:0 auto; text-align:center;">
    <p>ישנן כרגע <%=res(0)%> רשימות</p>
</div><%
res.close %>

<div class="table" style="text-align:center; padding:10px 0px;">
    <input id="searchList" />
    <div id="listSelect">
    </div>
</div><%
end if %>


        <%
    dim firstLtr
    firstLtr=""
    i=0
    mySQL = "SELECT * FROM lists LEFT JOIN (SELECT * FROM [users] IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"') AS T ON lists.creator=T.ID WHERE privacy > 1 ORDER BY TRIM(listName)"
    res.open mySQL, con 
    Do until res.EOF
        if ucase(left(trim(res("listName")),1)) <> ucase(firstLtr) then 
            if firstLtr<>"" then
                if i>5 then %>
                    <button class="showMore">⇵</button><%
                end if %>
                </div><%
            end if %>
            <div class="lists"><h2><%=left(trim(res("listName")),1)%></h2><%
            i=0
        end if %>
        <div<%if i>4 then%> class="hidden"<%end if%> onclick="location.href='lists.asp?id=<%=res("lists.ID")%>'">
            <span class="listName" title="<%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%>"><%=Replace(res("listName"),chrw(&H0651),chrw(&H0598))%></span>
            <span class="listData"><%=res("userName")%>
                <span class="material-icons" style="float:left;"><%
                    select case res("privacy")
                        case 0 %>lock<%
                        case 1 %>lock_open<%
                        case 2 %>public<%
                        case 3 %>group<%
                        end select %>
                </span>
            </span>
        </div><%
        i = i + 1
        firstLtr = left(trim(res("listName")),1)
        res.moveNext
    Loop
res.close 
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","lists.all.asp","single",durationMs,""
%>
</div>
</div>


<script>
    var listStr,lists,listsFltr,domBuilder
    function filterLists(list){
        return list["listName"].toLowerCase().includes(listStr);
    }
    $.ajaxSetup({
        async: false
    });
    $.getJSON("lists.all.json.asp",function(data){
        lists = data;
    });
    $("#searchList").on("keyup",function(){
        listStr = $(this).val().toLowerCase();
        if (listStr.length > 0) { 
            domBuilder = "<ul>";
            listsFltr = lists.filter(filterLists);
            listsFltr = listsFltr.slice(0,10);
            $.each(listsFltr, function(index, value){
                domBuilder += `<li><a href="lists.asp?id=${value.listID}">${value.listName}</a></li>`;
            });
            domBuilder += "</ul>";
        } else if (listStr.length == 0) {
            domBuilder = "";
        }
        $("#listSelect").html(domBuilder); 
    });
</script>

<!--#include file="inc/trailer.asp"-->