</div>

<div id="showTime" onclick="location.href='clock.asp';" style="cursor:pointer;">
    <span id="clock" dir="LTR">
        <span id="HH"></span><span id="MM"></span>
    </span>
    <span id="taatiklock"></span>
</div>

<style>
    #lastSearches li {
        display: inline;
    }
    #lastSearches li {
        background: white;
        border: 1px solid gray;
        border-radius: 5px;
        display: inline;
        margin-left:3px;
        padding: 3px 5px;
    }
    #lastSearches li {
        background: yellow;
    }
</style>

<div>
    חיפושים אחרונים:
    <ul id="lastSearches">
    </ul>
</div>

<script>
    var getSearchString = () =>
    new URL(window.location.href).searchParams.get("searchString");

    var lastSearches = localStorage.getItem("lastSearches")
    ? JSON.parse(localStorage.getItem("lastSearches"))
    : [];

    var newSreach = getSearchString();

    if (newSreach) {
    if (lastSearches.includes(newSreach)) {
        lastSearches = lastSearches.filter((e) => e !== newSreach);
    }
    lastSearches.push(newSreach);
    }
    if (lastSearches.length > 10) lastSearches.shift();

    localStorage.setItem("lastSearches", JSON.stringify(lastSearches));

    lastSearches = JSON.parse(localStorage.getItem("lastSearches")).reverse();


    lastSearches.forEach((search) => {
        $("#lastSearches").append("<li><a href='default.asp?searchString="+search+"'>"+search+"</a></li>");
    });
</script>




<style>
    footer {
        padding: 0;
        transition: all 0.3s ease;
        width: 100%;
    }

    footer section {
        width:100%;
    }

    footer a:link, footer a:visited { 
        color: #c8e2fd;
    }

    footer a:hover {
        color: white;
        text-decoration:underline;
    }

    footer h4 {
        text-decoration:none;
        margin:0 auto 4px auto;
    }

    .footer_box {
        background-color: #c8e2fd;
        color: #5c7b9a;
    }

    .footer_box > div {
        max-width:1024px;
        margin:0 auto;
        padding: 1rem 2rem;
    }

    .footer_nav {
        background-color: #5c7b9a;
        color: #c8e2fd;
        padding:1rem 0;
    }

    footer nav {
        display:flex;
        max-width:1024px;
        margin:0 auto;
        
    }

    footer nav ul {
        flex:1 1 0;
        line-height:1.4em;
        list-style-type: none;
        margin: 0;
        padding: 10px;
        }

    #userFloat {
        position:fixed;
        bottom:20px;
        left:20px;
    }
    
    #userFloat span {
        background:white;
        padding:10px;
        border-radius:50%;
        box-shadow:#5c7b9a95 2px 2px 5px;
    }

    #userFloat span:hover {
        background:yellow;
        color:black;
        cursor:pointer;
        box-shadow:#5c7b9a 2px 2px 5px;
    }

    #loginFrm {
        DISPLAY:NONE;
        background: #eeeeee;
        border:2px solid gray;
        padding:10px;
        WIDTH:0;
    }

    #loginFrm button[type=submit]{
        background: blue;
        color:white;
        margin-top:5px;
        padding:10px;
        width:75%;
    }

    #loginFrm button[type=reset]{
        background: red;
        color:white;
        margin-top:5px;
        padding:10px;
        width:20%;
    }

    @media (max-width:900px){
        footer nav {
            flex-direction:column;
        }
        footer nav li {
            text-align:center;
            border:1px solid #c8e2fd;
            padding:1rem;
        }
    }
</style>

<footer>
    <div id="userFloat"><%
        if session("role")>2 then %>
            user<%
        else %>
            <span id="loginBtn" class="material-icons">login</span><%
        end if %>
        <form id="loginFrm" style="">
            <label for="usernameInput">שם משתמש/ת</label>
            <br>
            <input id="usernameInput" type="username" />
            <br>
            <label for="pwInput">סיסמה</label>
            <br>
            <input id="pwInput" type="password" />
            <br>
            <button type="reset">X</button>
            <button type="submit">יאללה</button>
        </form>
    </div>
    <section class="footer_box">
        <div>
            מילון ערבית מדוברת הוא פרויקט...
        </div>
    </section>
    <section class="footer_nav">
        <nav>
            <ul>
                <span class="material-icons">home</span>
                <li><a href="default.asp">דף הבית</a></li>
                <li><a href="contribute.english.asp">About</a></li>
                <li><a href="about.asp">אודות</a></li>
                <li><a href="about.asp#thanks">תודות</a></li>
                <li><a href="about.asp#copyrights">זכויות יוצרים</a></li>
                <li><a href="stats.asp">סטטיסטיקה</a></li>
            </ul>
            <ul>
                <h4 style="DISPLAY:NONE;">כלים</h4>
                <span class="material-icons">category</span>
                <li><a href="lists.all.asp">רשימות אישיות</a></li>
                <li><a href="labels.asp">מילים לפי נושאים</a></li>
                <li><a href="games.mem.asp">משחק זיכרון</a></li>
                <li><a href="clock.asp">שעון</a></li>
            </ul>
            <ul>
                <span class="material-icons">groups</span>
                <h4 style="DISPLAY:NONE;">קהילה</h4>
                <li><a href="users.landingPage.asp">תפריט משתמשים</a></li>
                <li><a href="activity.asp">פעולות אחרונות</a></li>
                <li><a href="contribute.asp">תמיכה כלכלית</a></li><%
            if session("role")>2 then %>
                <br>
                <h4><%=session("username")%></h4>
                <li><a href="profile.asp?id=<%=session("userID")%>">פרופיל משתמש</a></li>
                <li><a href="word.new.asp">הוספת מילה</a></li>
                <li><a href="login.asp?exit=1">התנתק</a><li><%
            end if %>        
            </ul>
            <ul>
                <h4 style="DISPLAY:NONE;">המילון בסושייאל</h4>
                <span class="material-icons">share</span>
                <li><a href="https://www.youtube.com/channel/UCHnLvw-TCwckLXmjYozv9tw">YouTube</a></li>
                <li><a href="https://www.facebook.com/spoken.arabic.dictionary">פייסבוק - דף</a></li>
                <li><a href="https://www.facebook.com/groups/arabic4hebsTeam/">פייסבוק - קבוצה</a></li>
            </ul>
            <ul>
                <h4 style="DISPLAY:NONE;">איפה ללמוד</h4>
                <span class="material-icons">local_library</span>
                <li><a href="where2learn.schools.asp">בתי ספר</a></li>
                <li><a href="where2learn.teachers.asp">מורים פרטיים</a></li>
                <li><a href="where2learn.meetup.asp">מפגשי תירגול</a></li>
            </ul>
        </nav>
    </section>
</footer>


	
<script>

    $("#loginBtn").on("click",function(){
        $(this).hide();
        $("#loginFrm").show().animate({width:"200px"},1000);
    });

    $("#loginFrm button[type=reset]").on("click",function(){
        $("#loginFrm").hide().animate({width:"0px"},1000);
        $("#loginBtn").show();
    });

    function toggleSearch() {
    var srch = document.getElementById("topSearch");
    srch.style.display = (srch.style.display == "inline-block") ? "none" : "inline-block";
    }	

    function toggleMenu() {
    // var lMenu = document.getElementById("nav");
    // lMenu.style.display = (lMenu.style.display == "table") ? "none" : "table";

        $("#container").toggle();
        $("#showTime").toggle();
        $("#di3aaye").toggle();
        
    }	

    function showEmail() {
    var emailPng = document.getElementById("email");
    emailPng.style.display = "inline-block";
    }	

    function hideEmail() {
    var emailPng = document.getElementById("email");
    emailPng.style.display = "none";
    }

    $(".clear-input").on("click", function(){
        $("#searchBoxTop").val("").focus();
    });

    $("#topSearch").on("submit",function(){
        if($("#searchBoxTop").val().trim() == ""){
            return false;
        }
        $("#submitTop").prop("disabled",true);
        $("#loadingAnmTop").show().attr("float","left");
        return true;
    });


</script>

<script src="inc/functions/saa3a.js?v=3"></script>

</body>
</html>