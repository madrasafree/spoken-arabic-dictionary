<%
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

<!-- Google Tag Manager (noscript) - MUST BE IMMEDIATLY AFTER BODY TAG-->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-TD8T67L"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

<div id="banner" style="z-index:3; text-align:center; min-width:320px;" title="מילון קהילתי מקוון וחינמי">
    <span style="position:fixed; top:5px; right:6px; ">
        <a id="toggleMenu" href="#" onclick="toggleMenu();">
            <img src="img/site/menu.png" title="תפריט" alt="תפריט" />
        </a>
    </span>
    <form id="topSearch" action="." style="text-align:center; display:inline-block; padding:4px;">
        <span id="searchTop" style="border-bottom-left-radius:0px; border-top-left-radius:0px;" ><%
        if (right(request.ServerVariables ("URL"),12)<>"/default.asp") OR (len(request("searchString"))>0) then %>
            <input onclick="this.select();" type="text" id="searchBoxTop" name="searchString" value="<%=server.HTMLEncode(trim(gereshFix(request("searchString"))))%>" style="background-color:white; background-image:url(img/site/search.png); background-repeat:no-repeat; background-position:right; padding-right:30px; background-size:24px; "/><%
        else %>
            <div style="font-size:large; line-height:32px;">מילון ערבית מדוברת</div><%
        end if %>
        </span>
        <input type="submit" style="display:none;">
    </form>
    <span style="position:fixed; top:3px; left:4px; ">
        <a href="default.asp">
            <img src="img/site/logo_small.png" alt="מילון ערבית מדוברת" style="height:34px;" />
        </a>
    </span>
</div>

<div id="container">

    <div style="display:none; border:0px solid red; width:320px; margin:0px auto; text-align:center;">
        <a href="default.asp" style="border:0px solid green;">
            <span style="font-size:150%;">
                מילון ערבית מדוברת
            </span>
            <span style="display:inline-block;">
                לדוברי עברית
            </span>
        </a>
    </div>
    <div id="nav" class="navNew" style="z-index:3;"><%
        dim cURL
        cURL = mid(Request.ServerVariables("url"),22) %>
        <ul>
            <li<%if cURL="default.asp" then%> class="current"<%end if%>><a href="default.asp">דף ראשי</a></li>
            <li class="hr"></li>
            <li<%if left(cURL,5)="label" then%> class="current"<%end if%>><a href="labels.asp">רשימות נושאים<span style="font-size:80%;"></span></a></li>
            <li<%if left(cURL,5)="lists" then%> class="current"<%end if%>><a href="lists.all.asp">רשימות אישיות</a></li>
            <li<%if cURL="games.mem.asp" then%> class="current"<%end if%>><a href="games.mem.asp">משחק זיכרון</a></li>
            <li class="hr"></li>
            <li<%if cURL="guide.asp" then%> class="current"<%end if%>><a href="guide.asp">מדריך שימוש <span style="font-size:80%;"></span></a></li>
            <li<%if cURL="where2learn.asp" then%> class="current"<%end if%>><a href="where2learn.asp">איפה ללמוד</a></li>
            <li<%if cURL="links.asp" then%> class="current"<%end if%>><a href="links.asp">קישורים</a></li>
            <li class="hr"></li>
            <li<%if cURL="about.asp" then%> class="current"<%end if%>><a href="about.asp">אודות</a></li>
            <li<%if cURL="about.asp" then%> class="current"<%end if%>><a href="activity.asp">פעולות אחרונות</a></li>
            <li<%if cURL="team.asp" then%> class="current"<%end if%>><a href="contribute.asp">תמיכה בפרויקט <span style="color:#c34141;">♡</span></a></li>
        </ul>
        <span style="position:absolute; top:10px; left:0;" onclick="toggleMenu();"><a href="#">x</a></span>
    </div><%

      if msg <> "" then %>
    <div id="message">
        <%=msg%>
    </div><%
    end if %>

    <br />