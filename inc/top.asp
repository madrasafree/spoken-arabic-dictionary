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
%>

<style>

menu {
  DISPLAY:NONE;
  background:#f6f9fc;
  border-left:1px solid #cddbea;
  height:calc(100vh);
  font-size:1.4em;
  position:fixed;
  top:0;
  z-index:2;
  padding:0;
  margin:0;
 }

  menu ul {
    display:flex;
    flex-direction:column;
    gap:1%;
    height:calc(100% - 85px);
    justify-content:space-around;
    list-style:none;
    margin:0;
    padding:0 45px 45px 45px;
    width:160px;
  }

  menu li {
    background-color:#ffffff;
    border-radius:10px 0;
    text-align:center;
    flex:1;
    border: 1px solid lightgray;
    box-shadow: 1px 1px 1px #ccc;
  }

  menu li:hover {
    cursor:pointer;
    background-color:#ddd;
  }

  menu div {
  display:flex;
  padding:0;
  margin:0;
  height:100%;
  justify-content: center;
  align-items: center;
  }

menu div p {
  align-self:center;
  flex:1;
  margin:0;
}
menu li:first-child p, menu li:last-child p{
  font-size:18px;
  }
@media (max-width:600px) {
  menu {
    width:100%;
    padding:0;
  }
  menu ul {
    width: calc(100% - 60px);
    padding: 0 30px 40px 30px;
    height: calc(100% - 100px); 
     }

    menu li:first-child p, menu li:last-child p{
  font-size:1em;
  }
}



  #bar-search-container {
    background-color: #f6f9fc; 
    border-bottom: 1px solid #cddbea;
    position: sticky;
    top:0;
    z-index:2;
  }

  #bar {
    padding-bottom:4px;
    width:100%;
  }

  #bar-menu {
    cursor: pointer;
    flex:0 0 40px;
  }

  #bar-logo {
    cursor: pointer;
    flex:0 0 40px;
    padding-left:3px;
  }
  
  #bar-search {
    flex:1;
    height:40px;
    margin:0 3px;
  }
  
  #bar-search-flex {
    display:flex;
    height:40px;
  }
  
  #siteTitle {
    background: #f6f9fc;
    display:flex; 
    align-items:center; 
    justify-content:center; 
    font-size:large;
    letter-spacing:0.2em;
    padding:0.2em;
  }

  #searchBoxTop {
    -webkit-box-sizing:border-box;
    box-sizing:border-box;
    max-width:600px;
    background: white; 
    display: block; 
    width: 100%; 
    height: 94%; 
    padding: 3px 6px; 
    border: 1px dotted gray; 
    font-size:1.5em;
    margin:0 auto;
    background-image:url(assets/images/site/search.png);
    background-repeat:no-repeat;
    background-position:left;
    background-size:24px;
  }
  
  #searchBoxTop::placeholder {
    color:#bbb;
    padding-right:10px;
    font-size:0.8em;
  }

  #barSearchTools {
    DISPLAY:NONE;
    background-color: #f6f9fc;
    padding-top:5px;
  }

  #barSearchTeaser, .barSearchTools {
    max-width:600px;
    margin:0 auto;  
    }

  #barSearchTeaser {
    font-size: large;
  }

  .barSearchTools {
    visibility:HIDDEN;
    display: grid;
    grid-template-columns: 3fr 6fr;
    grid-column-gap: 10px;
  }

#clear-input, #search-button {
    border: 0;
    background: NONE;
    cursor: pointer;
    padding:5px;
    border-radius:5px;
  }

  #clear-input {
    /*visibility:HIDDEN;*/
    font-family: 'Material Icons';    
    font-size: 20px;
    background: #c7c7c7;
    color: black;
  }

  #clear-input:hover {
    background: gray;
    color: white;
  }

  #search-button {
    /*visibility:HIDDEN;*/
    font-size: 30px;
    background: #5b7a99;
    color:white;
  }

  #search-button:hover {
    background: #d4eaff;
    color: #5b7a99;
  }

  /* loading animation START - this code is DUPLIC from edit.css - MERGE needed */
  .lds-ring {
      display: inline-block;
      position: relative;
      width: 40px;
      height: 40px;
  }
  .lds-ring div {
      box-sizing: border-box;
      display: block;
      position: absolute;
      width: 32px;
      height: 32px;
      margin: 4px;
      border: 4px solid #fff;
      border-radius: 50%;
      animation: lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
      border-color: #82b1de transparent transparent transparent;
  }
  .lds-ring div:nth-child(1) {
      animation-delay: -0.45s;
  }
  .lds-ring div:nth-child(2) {
      animation-delay: -0.3s;
  }
  .lds-ring div:nth-child(3) {
      animation-delay: -0.15s;
  }
  @keyframes lds-ring {
      0% {
      transform: rotate(0deg);
      }
      100% {
      transform: rotate(360deg);
      }
  }
  /* loading animation END */  

  @media only screen and (max-width:700px) {
    .hideOnMobile {display:none;}
  }  
</style>

<div id="siteTitle">
<a href=".">
  מילון ערבית מדוברת
  </a>
</div>
<form id="bar-search-container" action="." autocomplete="off">
  <div dir="rtl" id="bar">
    <div id="bar-search-flex">
      <div id="bar-menu">
       <span class="material-icons" id="menuOpen" style="font-size: 40px; color: #5b7a99;">menu</span>
      </div>
      <div id="bar-search">
        <label for="searchBoxTop" style="DISPLAY:NONE;"> </label>
        <input id="searchBoxTop" name="searchString" type="search" value="<%=server.HTMLEncode(trim(gereshFix(request("searchString"))))%>" />
      </div>
      <div id="bar-logo">
        <a href=".">
          <img style="width:100%;" src="assets/images/site/milon-logo.png" alt="logo" />
        </a>
      </div>
    </div>
    <div id="barSearchTools">
      <div class="barSearchTools" style="height:0;">
        <button id="clear-input" type="button" title="ניקוי חיפוש">
          <span class="material-icons-outlined">close</span>
        </button>
        <input type="submit" style="DISPLAY:NONE;">
        <button id="search-button" title="חפשו במילון">
          יאללה!
        </button>
      </div>
      <div id="barSearchTeaser">
        <div style="text-align:center; border:0; line-height:1.5; padding:4px;">
            חפשו <span class="heb" style="font-size:larger; float:none;">מילה</span>, <span class="arb">כִּלְמֵה</span> <span class="or">או</span> <span class="arb">كلمة</span>
        </div>
      </div>
    </div>
    <div id="loadingAnm" style="DISPLAY:NONE; text-align:center;">
        <div class="lds-ring">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
    </div>
  </div>
</form>




<div id="container">

    <menu>
           <span class="material-icons" id="menuClose" style="cursor: pointer;font-size: 50px; color: #5b7a99;">close</span>

      <ul>
        <li><div onclick="window.location.href='default.asp'"><p>דף הבית של המילון</p></div></li>
        <li><div onclick="window.location.href='labels.asp'"><p>רשימת נושאים</p></div></li>
        <li><div onclick="window.location.href='lists.all.asp'"><p>רשימות אישיות</p></div></li>
        <li><div onclick="window.location.href='games.mem.asp'"><p>משחק זיכרון</p></div></li>
        <li><div onclick="window.location.href='guide.asp'"><p>מדריך שימוש</p></div></li>
        <li><div onclick="window.location.href='about.asp'"><p>אודות המילון</p></div></li>
        <li><div onclick="window.location.href='https://madrasafree.com'"><p>לאתר הבית של מדרסה</p></div></li>
      </ul>
    </menu>

    <div id="nav" class="navNew" style="visibility:hidden;z-index:3;"><%
%>
        <ul>
            <li><a href="default.asp">דף הבית של המילון</a></li>
            <li class="hr"></li>
            <li><a href="labels.asp">רשימות נושאים<span style="font-size:80%;"></span></a></li>
            <li><a href="lists.all.asp">רשימות אישיות</a></li>
            <li><a href="games.mem.asp">משחק זיכרון</a></li>
            <li><a href="guide.asp">מדריך שימוש <span style="font-size:80%;"></span></a></li>
            <li><a href="about.asp">אודות המילון</a></li>
            <li class="hr"></li>
            <li><a href="https://madrasafree.com">לאתר הבית של מדרסה</a></li>

        </ul>
        <span style="position:absolute; top:10px; left:0;" onclick="toggleMenu();"><a href="#">x</a></span>
    </div><%


    if msg <> "" then %>
    <div id="message">
        <%=msg%>
    </div><%
    end if %>

    <br />

    <script>

    $(function(){
    $("#menuOpen, #menuClose").click(function(){
      $("menu").toggle("slow");
      // $("#menuOpen, #menuClose").toggle();
    });
    });

      $("#searchBoxTop").focusin(function(){
        $("#bar-menu, #bar-logo").addClass("hideOnMobile");
        $("#barSearchTools").slideDown();
      });
       $("body").on('click',function(e){
        $("#bar-menu, #bar-logo").removeClass("hideOnMobile");
        $("#barSearchTools").slideUp();
      });
      
      $("#bar-search-container").keydown(function(e) {
        if (e.key === "Escape" || e.key === "Esc") {
          e.preventDefault();
          document.activeElement.blur();
          $("#barSearchTools").slideUp();
        }
        if (e.key === "Enter") {
          var isEmpty = isInputEmpty();
          if(isEmpty) e.preventDefault();
        }
      });
      
      $("#searchBoxTop").on("input focus",function(){
        var isToolsVisable=false;
        if ($(".barSearchTools").css("visibility") == "visible") isToolsVisable=true;
        if ((!isInputEmpty()==true) && (isToolsVisable==false)) {
            $(".barSearchTools").css({visibility:"visible",opacity:0.0}).animate({opacity:1.0});
            $("#barSearchTeaser").css({visibility:"hidden"});
        } else if ((isInputEmpty()==true) && (isToolsVisable==true)) {
            $(".barSearchTools").animate({opacity:0.0},150,function(){$(".barSearchTools").css({visibility:"hidden"})});
            $("#barSearchTeaser").css({visibility:"visible",opacity:0.0}).animate({opacity:1.0});
        }
      });

      $("#searchBoxTop, #clear-input, #search-button").on("click",function(e){
        e.stopPropagation(); // ignores clicking on the other elements "behind" the selected one.
      });

      $("#clear-input").on("click",function(e){
        $("#searchBoxTop").val('').focus();
      });

      function isInputEmpty(){return $("#searchBoxTop").val().trim().length == 0;}

      $("#bar-search-container").on("submit",function(e){
          var isEmpty = isInputEmpty();
          if(isEmpty) {
            e.preventDefault(); //prevent the default action
            $("#searchBoxTop").focus();
            return false;
          } else {
            $("#loadingAnm").show();
            $("#barSearchTools").hide();
            return true;
          }
      });

   </script>
