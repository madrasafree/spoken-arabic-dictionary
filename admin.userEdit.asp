<!--#include file="inc/inc.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "team/login.asp"
end if %>
<!DOCTYPE html>
<html>
    <head>
    <!--#include file="inc/header.asp"-->
    <style>
		.tableA		{ background-color:#e7f3ff;font-size:150%;line-height:30px;border-bottom:0px; border-top:solid 2px #99ccff;width:600px; text-align:right;}
		.tableA td	{ border-bottom:solid 1px #99ccff; }
		.tableB		{ background-color:#e7f3ff;line-height:15px;border:solid 1px #99ccff;border-bottom:0px;width:200px;}
		.tableB td	{ border-bottom:solid 1px #99ccff; }
		.tableC		{ background-color:#e7f3ff;line-height:15px;border:solid 2px #99ccff;border-bottom:0px;}
		.tableC td	{ border-bottom:solid 2px #99ccff; }
    </style>
    </head>
<body><%
Sub Checkbox(role, mask)
    %><input name="role" id="role<%=mask%>" type="checkbox" value="<%=mask%><%
    if (role and mask)<>0 then
        %>" checked="checked<%
    end if
    %>" /><%
End Sub

dim userId, userName, d

userId = request("id")

startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","admin.userEdit.asp","single",""

mySQL = "SELECT * FROM users WHERE id="&userId
res.open mySQL, con

%>
<div style="width:600px;margin:0px auto; text-align:left;">
<form action="admin.userEdit.update.asp" method="post" >
<input type="hidden" name="id" value="<%=userId%>" />
<br />
    <table class="tableA" border="0" align="center" cellpadding="0" cellspacing="0">
	    <tr><td>שם מלא:             </td><td><input name="name" value="<%=res("name")%>" />               </td></tr>
	    <tr><td>דואר אלקטרוני:      </td><td><input name="eMail" value="<%=res("eMail")%>" />              </td></tr>
	    <tr><td style="vertical-align:top;">אודות:      </td><td><textarea name="about" cols="40" rows="4"><%=res("about")%></textarea></td></tr>
	    <tr><td colspan="2">&nbsp;  </td></tr>
	    <tr><td>שם משתמש:           </td><td><input name="userName" value="<%=res("userName")%>" />           </td></tr>
	    <tr><td>סִסמה:               </td><td><input type="password" name="password" />           </td></tr>
	    <tr><td colspan="2">&nbsp;  </td></tr>
	    <tr><td style="vertical-align:top;">תפקיד:              </td><td>   
	             <%checkbox res("role"),2%><label for="role2">הוספת מילים</label>
	        <br /><%checkbox res("role"),4%><label for="role4">בקרת מילים</label>
	        <br /><%checkbox res("role"),8%><label for="role8">ניהול אתר</label>
            </td></tr>
        <tr><td>מגדר:           </td><td>
            <input name="gender" id="gender1" value="1" type="radio" <%if res("gender")="1" then %>checked="checked"<%end if %> /><label for="gender1">זכר</label>
            <input name="gender" id="gender2" value="2" type="radio" <%if res("gender")="2" then %>checked="checked"<%end if %> /><label for="gender2">נקבה</label>
        </td></tr>
        <tr><td colspan="2">&nbsp;  </td></tr>
        <tr><td>תמונה:           </td><td>
            <input name="picture" id="picture1" value="TRUE" type="radio" <%if res("picture") then %>checked="checked"<%end if %> /><label for="picture1">יש</label>
            <input name="picture" id="picture2" value="FALSE" type="radio" <%if not res("picture") then %>checked="checked"<%end if %> /><label for="picture2">אין</label>
        </td></tr>
        <tr>
            <td>מס' רשימות מקס':</td>
            <td><input name="maxLists" value="<%=res("maxLists")%>" /></td>
        </tr>
        <tr>
            <td><label for="userStatus">סטטוס חשבון:</label></td>
            <td>
                <select name="userStatus" id="userStatus">
                    <option value="1" <% if res("userStatus")=1 then %>selected<% end if%> >פעיל</option>
                    <option value="77" <% if res("userStatus")=77 then %>selected<% end if%> >מוקפא</option>
                    <option value="88" <% if res("userStatus")=88 then %>selected<% end if%> >מושהה</option>
                    <option value="99" <% if res("userStatus")=99 then %>selected<% end if%> >מחוק</option>
                </select>
            </td>
        </tr>
    </table>
    <br /><input type="submit" value="עדכן" />
    <br /><br /><a href="admin.asp">חזרה לדף שליטה</a>
</form><%
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","admin.userEdit.asp","single",durationMs,""

%>
</div>
</body>