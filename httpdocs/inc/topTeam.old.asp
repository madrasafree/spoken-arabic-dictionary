
<!--#include file="../inc/functions/string.asp"-->

<div id="topNav">
  <div id="menuBtn"><%
    if session("role")>2 then %>
        <img <%
    openDB "arabicUsers"
        mySQL = "SELECT username,[picture],gender FROM users WHERE id="&session("userID")
        res.open mySQL, con 
            if res("picture") then %>
                  src="img/profiles/<%=session("userID")%>.png"<%
            else 
                if res("gender")=1 then %>
                      src="img/profiles/male.png"<%
                else %>
                      src="img/profiles/female.png"<%
                end if
            end if %>
              style="height:40px; border-radius:50%; border:1px solid #d0ddeb;" title="<%=session("username")%>'s avatar" /><%
        res.close
    closeDB
    else %>
        <span class="material-icons" style=" background:white;padding:7px; border-radius:50%; border:1px solid; cursor:pointer;">menu</span>
      <%
    end if %>
    </div>
  <div id="toggleSearch">
    <span class="material-icons">search</span>
  </div>
  <div id="searchInput">
    <input type="text"/>
    <button type="submit">
    חפש
    </button>
  </div>
  <div id="logo">
    <span class="material-icons">android</span>
  </div>
</div>



<div id="menus">
  <div id="myMenu" style="background:white;">
    <ul><%
      if session("role")>2 then %>
      <li><a href="profile.asp?id=<%=session("userID")%>">הפרופיל שלי</a></li>
      <li><a href="team.asp">דף צוות ראשי</a></li>
      <li><a href="word.new.asp">הוסף מילה חדשה</a></li>
      <li><a href="login.asp?exit=1">התנתק</a></li><%
      else %>
      <li><a href="login.asp">התחבר</a></li><%
      end if%>
    </ul>
  </div>
  <div id="mainMenu" style="background:#d4e7fb;">
    <ul>
      <li><a href="default.asp">דף ראשי</a></li>
      <li><a href="labels.asp">רשימות נושאים</a></li>
      <li><a href="lists.all.asp">רשימות אישיות</a></li>
      <li><a href="games.mem.asp">משחק זיכרון</a></li>
      <li><a href="guide.asp">מדריך שימוש</a></li>
      <li><a href="where2learn.asp">איפה ללמוד</a></li>
      <li><a href="links.asp">קישורים</a></li>
      <li><a href="about.asp">אודות</a></li>
      <li><a href="activity.asp">פעולות אחרונות</a></li>
      <li><a href="contribute.asp">תמיכה בפרויקט <span style="color:#c34141;">♡</span></a></li>
    </ul>
  </div>
</div>

<div id="menusBG">
</div>

<div style="display:inline-block; border:1px solid gray;">
  <span id="searchIcon" class="material-icons" title="הצגת שדה חיפוש" style="background:white; padding:7px; border-radius:50%; border:1px solid; cursor:pointer;">search
  </span>
</div>

<div id="bread" style="display:inline-block; border:1px solid gray;">
  <a href="">מילון ערבית מדוברת</a> /
  <a href=""><h1>דף צוות ראשי</h1></a>
</div>

<div id="searchBar" style=" DISPLAY:NONE; width:100%; text-align:center; min-width:320px;">
    <form id="topSearch" action="." style="text-align:center; display:inline-block; padding:4px; margin-top:6px;">
        <span id="searchTop" style="border-bottom-left-radius:0px; border-top-left-radius:0px;" >
            <input onclick="this.select();" type="text" id="searchBoxTop" name="searchString" value="<%=server.HTMLEncode(trim(gereshFix(request("searchString"))))%>" style="width:40vw; outline:none; background-color:white; padding: 0 30px; background-size:24px; height:40px; "/></span><button type="submit" style="
    background: #90beea;
    border-radius: 10px 0 0 10px;
    color: white;
    font-weight: bold;
    letter-spacing: 2px;
    font-size: larger;
    border: solid gray;
    border-width: 1px 0 1px 1px;
    height: 42px;">יאללה</button>
    </form>
</div>

<div style="display:inline-block; ">
    <a href="default.asp">
        <img src="img/site/logo_small.png" alt="מילון ערבית מדוברת" style="height:40px;" />
    </a>
</div>
