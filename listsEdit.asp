<!--#include file="inc/inc.asp"--><%
If (session("role")<2) then 
    session("msg") = "אין לך הרשאה מתאימה"
    Response.Redirect Request.ServerVariables("HTTP_REFERER")
end if

openDB "arabicUsers"
    'Checks if READ ONLY mode is Enabled
    mySQL = "SELECT allowed FROM allowEdit WHERE siteName='readonly'"
    res.open mySQL, con
    if res(0) = true then
        session("msg") = "אין כרגע אפשרות לערוך רשימות. אנא נסו שנית מאוחר יותר"
        Response.Redirect Request.ServerVariables("HTTP_REFERER")
    end if
    res.close
closeDB


 %>
<!DOCTYPE html>
<html>
<head>
	<title>עריכת רשימה קיימת</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
    <style>
        #listUpdate {
            background:#d4eaff33;
            border:1px solid #90beeaa8;
            padding:10px;
            position:relative;
            margin:0 auto;
            max-width:400px;
        }

        input[type=text], textarea {
            border-width:1px;
            border-radius:5px;
            display:block;
            margin-bottom:15px;
            padding:3px;
            width: 90%;
        }
        input[type=radio] {
            margin:.4rem;
        }
        button[type=submit] {
            bottom:10px;
            left:10px;
            position:absolute;
        }
        .tooltip < div {
            position:relative;
        }
        .tooltip {
            background: yellow;
            border: 1px solid blue;
            border-radius:10px;
            color: blue;
            padding: 4px 8px;
            position:absolute;
            visibility: hidden;

        }
        .material-icons:hover ~ .tooltip {
            visibility: visible;
        }
        
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div id="dashboard"><%
    
    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","listsEdit.asp","single",""
    
    dim lPrivacy

    mySQL = "SELECT * FROM lists WHERE id="&Request("id")
    res.open mySQL, con 
    
    lPrivacy = res("privacy") %>
    <h1 class="pTitle">עריכת רשימה קיימת</h1>

    <form id="listUpdate" action="listsEdit.update.asp">
        <input name="LID" value="<%=Request("id")%>" type="hidden" />
        <label><b>שם הרשימה</b></label>
        <input type="text" name="lTitle" required autofocus value='<%=res("listName")%>' />
        <label><b>תיאור</b></label>
        <textarea name="lDesc" cols="40" rows="5"><%=res("listDesc")%></textarea>
        <br>
        <b>דרגת פרטיות</b>
        <div>
            <input type="radio" name="lPrivacy" value="2" <%if lPrivacy=2 then response.write "checked" end if%>>
            <label>פומבי</label>
            <span class="material-icons" style="font-size:1rem;">help_outline</span>
            <span class="tooltip">יופיע באינדקס של הרשימות</span>
        </div>
        <div>
            <input type="radio" name="lPrivacy" value="1" <%if lPrivacy=1 then response.write "checked" end if%>>
            <label>לבעלי קישור</label>
            <span class="material-icons" style="font-size:1rem;">help_outline</span>
            <span class="tooltip">לא יופיע באינדקס, אך עדיין נגיש עם קישור</span>
        </div><%
        if (session("userID")=1 or session("userID")=73 or session("userID")=76) then %>
            <div>
                <input type="radio" name="lPrivacy" value="0" <%if lPrivacy=0 then response.write "checked" end if%>>
                <label>פרטי</label> (יניב, רונן, איתי)
            </div>
            <div>
                <input type="radio" name="lPrivacy" value="3" <%if lPrivacy=3 then response.write "checked" end if%>>
                <label>משותף</label> (יניב, רונן, איתי)
            </div><%
        end if%>
        <button type="submit">יאללה</button>

    </form><%
    res.close 
    
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicWords","C","listsEdit.asp","single",durationMs,""    
    %>
</div>
<!--#include file="inc/trailer.asp"-->
</body>
</html>