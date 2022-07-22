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

<form id="bar-search-container" action="." autocomplete="off">
  <div id="bar" style="background-color: #f6f9fc; border-bottom:1px solid #cddbea; position:fixed; top:0; width:100%; z-index:3; display: grid; grid-template-columns: 40px 1fr 40px; grid-template-rows: repeat(2, 46px); grid-column-gap: 10px; grid-row-gap: 10px;">

      <div id="bar-menu" style="flex: 0 0 40px; display:flex; justify-content:center; align-items:center; cursor: pointer" onclick="toggleMenu();">
        <img style="width: 100%;" src="img/site/menu.png" alt="menu"/>
      </div>
        <div>
            <label for="searchBoxTop" style="display:NONE;"></label>
          <input id="searchBoxTop" name="searchString" type="search"
            style="background: white; display: block; width: 98%; height: 70%; padding: 3px; border: 1px dotted gray; font-size:2em;"
            value="<%=server.HTMLEncode(trim(gereshFix(request("searchString"))))%>" />
        </div>

      <div id="bar-logo" style="flex: 0 0 40px; display:flex; justify-content:center; align-items:center; cursor: pointer; margin-left: 6px">
        <a href="default.asp">
            <img style="width:100%;" src="img/site/logo_small.png" alt="logo" />
        </a>
      </div>

        <div class="barSearchTools">
        </div>

        <div class="barSearchTools">
          <button id="clear-input" style="POSITION:ABSOLUTE; right:0px; bottom:-50px;  border: 0; background: NONE;"
            type="button" title="ניקוי חיפוש">
            <span style="font-family: 'Material Icons'; font-size: 20px;cursor: pointer;padding:5px;
                background: #c7c7c7; border-radius: 50%; color:white;"
              class="material-icons-outlined">
              close
            </span>
          </button>

          <button style="POSITION:ABSOLUTE; left:0px; bottom:-50px; border:0; background:none;">
            <span style="font-family: 'Material Icons'; font-size: 30px; cursor: pointer; padding:5px;
                background: #5b7a99; border-radius: 50%; color:white;"
              class="material-icons-outlined" title="חפשו במילון">
              search
            </span>
          </button>
        </div>

        <div class="barSearchTools">
        <input type="submit" style="display:none;">
        </div>
  </div>
</form>

<!--div id="bar" style="Z-INDEX:3; display: flex; position: fixed; top:0; width:100%; justify-content:space-between;
        height: 46px; background-color: #f6f9fc; border-bottom:1px solid #cddbea;">
      <div id="bar-menu" style="flex: 0 0 40px; display:flex; justify-content:center; align-items:center; cursor: pointer" onclick="toggleMenu();">
        <img style="width: 100%;" src="img/site/menu.png" alt="menu"/>
      </div--><%

dim url
url = request.ServerVariables("URL")
    'if (right(request.ServerVariables ("URL"),12)<>"/default.asp") OR (len(request("searchString"))>0) then 
    if instr(url,"xxx.asp") OR (right(url,1)="///") then 
    %>
  <form id="bar-search-container" action="." style=" display: flex; justify-content: space-between;
      flex-basis: 600px; margin: 0 6px;" autocomplete="off">
        <div style="flex: 0 0 40px">
        </div>
        <div style="POSITION:RELATIVE; flex:1;">
            <label for="searchBoxTop" style="display:NONE;"></label>
          <input id="searchBoxTop" name="searchString" type="search"
            style="background: white; display: block; width: 98%; height: 70%; padding: 3px; border: 1px dotted gray; font-size:2em;"
            value="<%=server.HTMLEncode(trim(gereshFix(request("searchString"))))%>" />


          <button id="clear-input" style="POSITION:ABSOLUTE; right:0px; bottom:-50px;  border: 0; background: NONE;"
            type="button" title="ניקוי חיפוש">
            <span style="font-family: 'Material Icons'; font-size: 20px;cursor: pointer;padding:5px;
                background: #c7c7c7; border-radius: 50%; color:white;"
              class="material-icons-outlined">
              close
            </span>
          </button>

          <button style="POSITION:ABSOLUTE; left:0px; bottom:-50px; border:0; background:none;">
            <span style="font-family: 'Material Icons'; font-size: 30px; cursor: pointer; padding:5px;
                background: #5b7a99; border-radius: 50%; color:white;"
              class="material-icons-outlined" title="חפשו במילון">
              search
            </span>
          </button>
        </div>
        <div style="flex: 0 0 40px; ">
        </div>
        <input type="submit" style="display:none;">
      </form><%
     %>
        <div style="display:flex; align-items:center; justify-content:center; font-size:large;">
            <div>מילון ערבית מדוברת</div>
        </div>    

      <div id="bar-logo" style="flex: 0 0 40px; display:flex; justify-content:center; align-items:center; cursor: pointer; margin-left: 6px">
        <a href="default.asp">
            <img style="width:100%;" src="img/site/logo_small.png" alt="logo" />
        </a>
      </div>
<%
    end if %>
</div>


<div id="container">
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