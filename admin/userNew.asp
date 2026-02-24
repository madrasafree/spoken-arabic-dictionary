<!--#include virtual="/includes/inc.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "../team/login.asp"
end if %>
<!DOCTYPE html>
<html>
<head>
<!--#include virtual="/includes/header.asp"-->
	<style>
		.tableA		{ background-color:#e7f3ff;font-size:150%;line-height:30px;border-bottom:0px; border-top:solid 2px #99ccff;width:600px; text-align:right;}
		.tableA td	{ border-bottom:solid 1px #99ccff; }
		.tableB		{ background-color:#e7f3ff;line-height:15px;border:solid 1px #99ccff;border-bottom:0px;width:200px;}
		.tableB td	{ border-bottom:solid 1px #99ccff; }
		.tableC		{ background-color:#e7f3ff;line-height:15px;border:solid 2px #99ccff;border-bottom:0px;}
		.tableC td	{ border-bottom:solid 2px #99ccff; }
	</style>
</head>
<body>
<div style="width:600px;margin:0px auto; text-align:left;">
<form action="userNew.insert.asp" method="post" >
<br />
    <table class="tableA" border="0" align="center" cellpadding="0" cellspacing="0">
	    <tr><td>שם מלא:             </td><td><input name="name" />               </td></tr>
	    <tr><td>דואר אלקטרוני:      </td><td><input name="eMail" />              </td></tr>
	    <tr><td style=" vertical-align:top;">אודות:      </td><td><textarea name="about" cols="40" rows="4"></textarea></td></tr>
	    <tr><td colspan="2">&nbsp;  </td></tr>
	    <tr><td>שם משתמש:           </td><td><input name="userName" />           </td></tr>
	    <tr><td>סִסמה:               </td><td><input name="password" />           </td></tr>
	    <tr><td colspan="2">&nbsp;  </td></tr>
	    <tr><td style=" vertical-align:top;">תפקיד:              </td><td>   
	        <br /><input name="role" type="checkbox" value="2" id="role2" /><label for="role2">הוספת מילים</label>
	        <br /><input name="role" type="checkbox" value="4" id="role4" /><label for="role4">בקרת מילים</label>
	        <br /><input name="role" type="checkbox" value="8" id="role8" /><label for="role8">ניהול אתר</label>
            </td></tr>
        <tr><td>מגדר:           </td><td>
            <input name="gender" id="gender1" value="1" type="radio" /><label for="gender1">זכר</label>
            <input name="gender" id="gender2" value="2" type="radio" /><label for="gender2">נקבה</label>
            </td></tr>
    </table>
    <input type="submit" value="הוסף" />
    <br /><br />
    <a href="userControl.asp">חזרה לדף שליטה</a>
</form>
</div>
</body>
</html>
