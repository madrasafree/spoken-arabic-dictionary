<!--#include virtual="/includes/inc.asp"-->
<!--#include virtual="/includes/time.asp"--><%
if session("role") <> 15 then
	session("msg") = "אין לך הרשאה מתאימה. פנה למנהל האתר"
	Response.Redirect "../team/login.asp"
end if %>
<!DOCTYPE html>
<html>
<head>
	<title>ניהול משתמשים - גרסא מלאה</title>
    <META NAME="ROBOTS" CONTENT="NONE">
<!--#include virtual="/includes/header.asp"-->
	<style>
		.mainTable {margin:0 auto; font-size:smaller; border-spacing:0; border-collapse: collapse;}
		.mainTable tr:hover {background: white;}
		.mainTable td {border-bottom:1px solid gray; border-right:1px dashed rgb(201, 201, 201); padding:2px 5px;}
	</style>
	<script>
        $(document).ready(function(){
            var dataValue
            // SORT users acording to user's preferece
            $("#loginTime").click(function(){
                dataValue = this.value;
				$(".userRow").sort(sort_list_desc).appendTo(".mainTable");
            });

            function sort_list_desc(b, a){
console.log({a,b});
            return ($(b).find(".jc").data("login")) < ($(a).find(".jc").data("login")) ? 1 : -1;    
            }
        });
	</script>
</head>
<body>
<!--#include virtual="/includes/top.asp"-->
<div><%

Sub Checkbox(role, mask)
	if (role and mask)<>0 then %>
		<img style="width:16px;height:16px;opacity:.9;" alt="V" src="https://milon.madrasafree.com/img/site/correct.png"><%
	else %>
		<img style="width:16px;height:16px;opacity:.3;" alt="X" src="https://milon.madrasafree.com/img/site/x.png" /><%
    end if
End Sub

dim userId, userName, d, gen, filter, order,dateTxt

dateTxt=intToStr(year(now),4)+"-"+intToStr(month(now),2)+"-"+intToStr(day(now),2)
'response.write "<div>"&dateTxt&"</div>"

order = "name"
filter = ""
if len(request("filter"))>0 then filter = " WHERE " & request("filter") & "=true"
if len(request("order"))>0 then order = request("order")
gen=""
userId = request("id")


startTime = timer()
'openDB "arabicUsers"
openDbLogger "arabicUsers","O","userControl.full.asp","single",""


mySQL = "SELECT * FROM users " &filter& " ORDER BY " &order
res.open mySQL, con %>

<div style="margin:20px auto; text-align:center;">
	<h2>ניהול משתמשים</h2>
	<a href="userNew.asp" style="background:#eeddcc;width:150px;border:solid 1px gray; padding:3px;">הוספת משתמש חדש</a>
</div>

<table class="mainTable">
    <tr style="background:#edc;">
		<td style="max-width:80px;"><a href="userControl.asp?filter=picture">V</a></td>
        <td style="text-align:right;"><a href="userControl.asp">שם אמיתי</a></td>
		<td>שם משתמש</td>
		<td>מייל</td>
		<td><a href="userControl.asp?filter=addWords">add</a></td>
		<td><a href="userControl.asp?order=maxLists desc">lists</a></td>
		<td><a href="userControl.asp?filter=editorWords">עורך</a></td>
		<td><a href="userControl.asp?filter=editorPics">pics</a></td>
		<td><a href="userControl.asp?filter=editorMedia">מדיה</a></td>
		<td><a href="userControl.asp?filter=speaker">דובר</a></td>
		<td><a href="userControl.asp?filter=coder">תכנת</a></td>
		<td>ערבית</td>
		<td>עברית</td>
		<td>להג</td>
		<td>עיר</td>
		<td>קרדיט</td>
		<td>לינק</td>
		<td><a href="userControl.asp?order=joinDateUTC desc">תאריך הצטרפות</a></td>
        <td id="loginTime">כניסה אחרונה</td>
        <td style="max-width:20px;">צפייה</td>
        <td style="max-width:20px;">הוספה</td>
        <td style="max-width:20px;">בקרה</td>
        <td style="max-width:20px;">ניהול</td>
        <td style="width:60px;"></td>
    </tr><%
    do until res.EOF %>
	    <tr class="userRow"><% 
	        if res("gender")="2" then 
	            gen="fe"
	        else
	            gen=""
	        end if
	        if res("picture")=true then %>
	            <td><img src="https://milon.madrasafree.com/img/profiles/<%=res("id")%>.png" title="<%=res("userName")%>" style="height:16px;" /></td><%
	        else %>
	            <td><img src="https://milon.madrasafree.com/img/profiles/<%=gen %>male.png" title="<%=res("userName")%>" style="height:16px;" /></td><%
	        end if %>
	        <td style="vertical-align:top; text-align:right;">
	            <a href="../profile.asp?id=<%=res("id")%>" target="profile<%=res("id")%>">
					<%=res("name")%>
				</a></td>
			<td><%=res("userName")%></td>
			<td style="text-align:left"><%=res("eMail")%></td>
			<td><%Checkbox res("addWords"),true%></td>
			<td><%=res("maxLists")%></td>
			<td><%Checkbox res("editorWords"),true%></td>
			<td><%Checkbox res("editorPics"),true%></td>
			<td><%Checkbox res("editorMedia"),true%></td>
			<td><%Checkbox res("speaker"),true%></td>
			<td><%Checkbox res("coder"),true%></td>
			<td><%=res("arabicLevel")%></td>
			<td><%=res("hebrewLevel")%></td>
			<td><%=res("arabicDialect")%></td>
			<td><%=res("arabicCity")%></td>
			<td><%=res("credit")%></td>
			<td><%=res("creditLink")%></td>
			<td><%
				if len(res("joinDateUTC"))>0 then%>
				<span><%Str2hebDate res("joinDateUTC")%></span><%
				end if%>
	        </td>
			<td><%
			dim jc
			mySQL = "SELECT TOP 1 loginTimeUTC FROM loginLog WHERE userID="&res("id")&" ORDER BY id DESC"
			res2.open mySQL, con
				if res2.EOF then
					jc = "2010-01-01"
				else
					jc = res2(0)
					jc = replace(jc,"T"," ")
					jc = replace(jc,"Z","")
					response.write Str2hebDate(jc)
				end if
			res2.close %>
			</td>
			<td class="jc" data-login="<%=jc%>"><%Checkbox res("role"), 1%></td>
	        <td><%Checkbox res("role"), 2%></td>
	        <td><%Checkbox res("role"), 4%></td>
	        <td><%Checkbox res("role"), 8%></td>
	        <td style="text-align:left;"><a href="userEdit.asp?id=<%=res("id")%>"><div style="background:#eeddcc;width:45px;border:solid 1px gray; text-align:center;">עריכה</div></a></td>
	    </tr><%
	    res.movenext
	loop %>
</table><%
endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicUsers","C","userControl.full.asp","single",durationMs,""
%>
</div>
</body>
</html>
