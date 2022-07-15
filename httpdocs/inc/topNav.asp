	<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" href="css/arabic_2020.css" />
	<link rel="shortcut icon" href="img/site/favicon.ico" />
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script>        
      $(document).ready(function(){
          

          $("#menu").click(function(){
              $("#menusBG").fadeIn("fast");
              $("#myMenu").slideToggle();
              $("#mainMenu").slideToggle();                
              if ($(this).text() == 'menu') {
                  $(this).text('close');
              }else{
                  $(this).text('menu');
              }
          });

          $("#searchIcon").click(function(){
              $("#searchBar").fadeToggle();
              if ($(this).text() == 'search') {
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

          $("#searchInput input").focus(function(){
            $("#searchInput").css({
              "border": "2px #70d5da solid",
              "transition": "all .1s ease-out"
              });
          });

          $("#searchInput input").focusout(function(){
            $("#searchInput").css({
              "border": "1px gray solid",
              "transition": "all .1s ease-out"
              });
          });
      });
  </script>
</head>
<body>
<form id="topSearch" action=".">
<div id="topNav" dir="rtl">
  <div>
    <span id="menu" class="material-icons">menu</span>  
  </div>
  <div id="toggleSearch">
    <span id="searchIcon" class="material-icons">search</span>
  </div>
  <div id="searchInput">
    <input style="direction:rtl;" type="text" name="searchString"/>
    <button type="submit">
    חפש
    </button>
  </div>
  <div id="logo">
    <span class="material-icons"  alt="website logo" style="opacity:0;">clear</span>
  </div>
</div>
<form>


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