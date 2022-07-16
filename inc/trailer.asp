</div>

<div id="showTime" onclick="location.href='clock.asp';" style="cursor:pointer;">
    <span id="clock" dir="LTR">
        <span id="HH"></span><span id="MM"></span>
    </span>
    <span id="taatiklock"></span>
</div>


<!--these br's are needed cause the trailer hides the bottom part of the page-->
<br><br><br>
    <table class="footer">
        <tr>
            <td>
                <div id="inFooter" style="display:none;">
					<br>
					<a href="about.asp">אודות</a> |
                    <a href="about.asp#thanks">תודות</a> |
                    <a href="about.asp#copyrights">&copy; זכויות יוצרים</a>
                    <br>
                    <br>דיסקליימר: 
					<b>זהו לא מילון רשמי.</b> את המילים מוסיפים ובודקים משתמשי המילון בעצמם
                    <br>
				</div>
                <div style="padding:5px 8px; text-align:left;">
                    <div style="display:inline-block; float:right;">
                        <img src="img/site/info.png" style="width:24px;" onclick="toggleTable()" alt="סוג של דיסקליימר" title="סוג של דיסקליימר" />
                    </div>

                    <%
                    if session("role")>2 then %>
                    <a href="profile.asp?id=<%=session("userID")%>">
                        <img id="avatar"
                    <%
                    startTime = timer()
                    'openDB "arabicUsers"
                    openDbLogger "arabicUsers","O","inc/trailer.asp","show avatar",""
                    

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
                             style="height:24px; " title="<%=session("username")%>'s avatar" /></a><%
                        res.close

                    endTime = timer()
                    durationMs = Int((endTime - startTime)*1000)
                    'closeDB
                    closeDbLogger "arabicUsers","C","inc/trailer.asp","show avatar",durationMs,""
                    %>

                    <div style="display:inline-block;">
                        <a href="word.new.asp"><img src="img/site/add-square.png" style="width:24px;" alt="הוספת מילה" title="הוספת מילה" /></a>
                    </div><%
                    end if%>

                    <div style="display:inline-block;">
                        <a href="users.landingPage.asp"><img src="team/img/teamLogo.png" style="width:24px;" alt="התחברו למילון" title="התחברו למילון" /></a>
                    </div>
                </div>
            </td>
        </tr>
    </table>
	
	<script>
        function toggleTable() {
        var lTable = document.getElementById("inFooter");
        lTable.style.display = (lTable.style.display == "table") ? "none" : "table";
        }

        function toggleSearch() {
        var srch = document.getElementById("topSearch");
        srch.style.display = (srch.style.display == "inline-block") ? "none" : "inline-block";
        }	
    
        function toggleMenu() {
        var lMenu = document.getElementById("nav");
        lMenu.style.display = (lMenu.style.display == "table") ? "none" : "table";
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