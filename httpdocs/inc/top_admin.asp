<!--#include file="time.asp"-->
<div class="top">
    <span><a href="default.asp">דף ראשי</a></span>
    <span><a href="userControl.asp">ניהול משתמשים</a></span>
    <span><a href="loginHistory.asp">מעקב כניסות</a></span>
    <span><a href="mark4translate.asp">סימון מילים לתרגום</a></span>
	<span style="float:left; margin-left:40px; font-size:small;" dir="ltr">
	isrTime : <u><%=isrTime()%></u>
	</span>
    <span style="float:left; margin-left:40px; font-size:small;" dir="ltr">server_name:<u><%
		dim serverName
		serverName = Request.ServerVariables("SERVER_NAME")
		response.write serverName %>
	</u></span>
</div><%
if len(session("msg"))>0 then %>
	<div style="margin-top: 40px;text-align: center;color: red;">
		<%=session("msg")%>
	</div><%
	session("msg")=""
end if %>