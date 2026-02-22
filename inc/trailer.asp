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
                <div style="padding:5px 8px; text-align:left;"><%
                    if session("role")>2 then %>
                    <a href="profile.asp?id=<%=session("userID")%>">
                        <img id="avatar"
                    <%
                    'openDB "arabicUsers"
                    openDbLogger "arabicUsers","O","inc/trailer.asp","show avatar",""
                    

                        mySQL = "SELECT username,[picture],gender FROM users WHERE id="&session("userID")
                        res.open mySQL, con 
                            if res("picture") then %>
                                 src="assets/images/profiles/<%=session("userID")%>.png"<%
                            else 
                                if res("gender")=1 then %>
                                     src="assets/images/profiles/male.png"<%
                                else %>
                                     src="assets/images/profiles/female.png"<%
                                end if
                            end if %>
                             style="height:24px; " title="<%=session("username")%>'s avatar" /></a><%
                        res.close

                    'closeDB
                    closeDbLogger "arabicUsers","C","inc/trailer.asp","show avatar",durationMs,""
                    %>

                    <div style="display:inline-block;">
                        <a href="word.new.asp"><img src="assets/images/site/add-square.png" style="width:24px;" alt="הוספת מילה" title="הוספת מילה" /></a>
                    </div><%
                    end if%>

                    <div style="display:inline-block;">
                        <a href="users.landingPage.asp"><img src="assets/images/team/teamLogo.png" style="width:24px;" alt="התחברו למילון" title="התחברו למילון" /></a>
                    </div>
                </div>
            </td>
        </tr>
    </table>
	
	<script>
        function toggleMenu() {
        var lMenu = document.getElementById("nav");
        lMenu.style.display = (lMenu.style.display == "table") ? "none" : "table";
        }

    </script>

    <script src="assets/js/saa3a.js?v=3"></script>

</body>
</html>
