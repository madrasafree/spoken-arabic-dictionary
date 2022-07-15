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


<div id="banner" style="z-index:3; text-align:center; min-width:320px;">
    <span style="position:fixed; top:5px; right:6px; ">
        <a id="toggleMenu" href="#" onclick="toggleMenu();">
            <img src="<%=baseA%>img/site/menu.png" title="תפריט" alt="תפריט" />
        </a>
    </span>
    <form action="<%=baseA%>default.asp" style="text-align:center; display:inline-block; padding:4px;">
        <span id="searchTop" style="border-bottom-left-radius:0px; border-top-left-radius:0px;" >
            <input onclick="this.select();" type="text" id="searchBoxTop" name="searchString" value="<%=server.HTMLEncode(trim(gereshFix(request("searchString"))))%>" style="background-color:white; background-image:url(<%=baseA%>img/site/search.png); background-repeat:no-repeat; background-position:right; padding-right:30px; background-size:24px; "/>
        </span>
        <input type="submit" style="display:none;">
    </form>
    <span style="position:fixed; top:3px; left:4px; ">
        <a href="default.asp">
            <img src="img/teamLogo.png" alt="צוות המילון" title="צוות המילון" style="height:34px;" />
        </a>
    </span>
</div>

<div id="container">

    <div id="nav" class="navNew" style="z-index:3;"><%
        dim cURL
        cURL = mid(Request.ServerVariables("url"),22) %>
	    <ul>
		    <li<%if cURL="default.asp" then%> class="current"<%end if%>><a href="<%=baseA%>default.asp">ראשי</a></li>
            <li class="hr"></li>
		    <li<%if left(cURL,5)="label" then%> class="current"<%end if%>><a href="<%=baseA%>label.asp?id=1">מילים לפי נושאים<span style="font-size:80%;"></span></a></li>
		    <li<%if cURL="list.vids.asp" then%> class="current"<%end if%>><a href="<%=baseA%>list.vids.asp">מילים עם סירטון</a></li>
            <li<%if cURL="list.audio.asp" then%> class="current"<%end if%>><a href="<%=baseA%>list.audio.asp">מילים עם אודיו</a></li>
		    <li<%if cURL="list.pics.asp" then%> class="current"<%end if%>><a href="<%=baseA%>list.pics.asp">מילים עם תמונה</a></li>
		    <li<%if cURL="list.asp" then%> class="current"<%end if%>><a href="<%=baseA%>list.asp">כל המילים <span style="font-size:80%;"></span></a></li>
            <li<%if left(cURL,5)="lists" then%> class="current"<%end if%>><a href="<%=baseA%>lists.all.asp">רשימות</a></li>
            <li class="hr"></li>
            <li<%if cURL="where2learn.asp" then%> class="current"<%end if%>><a href="<%=baseA%>where2learn.asp">איפה ללמוד</a></li>
            <li<%if cURL="games.mem.asp" then%> class="current"<%end if%>><a href="<%=baseA%>games.mem.asp">משחק זיכרון</a></li>
		    <li<%if cURL="links.asp" then%> class="current"<%end if%>><a href="<%=baseA%>links.asp">קישורים</a></li>
		    <li<%if cURL="about.asp" then%> class="current"<%end if%>><a href="<%=baseA%>about.asp">אודות</a></li>
		    <li<%if cURL="team.asp" then%> class="current"<%end if%>><a href="<%=baseA%>team.asp">דרושים</a></li>
	    </ul>
        <span style="position:absolute; top:10px; left:0;" onclick="toggleMenu();"><a href="#">x</a></span>
    </div>	
    <br />
    <%if msg <> "" then %><div id="message"><%=msg%></div><%end if %>