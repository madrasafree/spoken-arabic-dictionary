<div id="teamTools">
    אהלן <a href="<%=baseA%>profile.asp?id=<%=session("userID")%>"><%=session("name")%></a> [<a href="login.asp?exit=1">התנתק</a>], <a href="../word.new.asp">הוסף מילה</a>
    | <a href="mediaControl.asp">בנק מדיה</a>
    | <a href=".">ראשי</a>
    <span style="float:left; margin-left:40px;" dir="ltr"><%
		response.write Request.ServerVariables("SERVER_NAME") %>		
	</span>
</div>