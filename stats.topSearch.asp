<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
	<title>מאה המילים שחיפשו הכי הרבה</title>
	<meta name="Description" content="רשימת המילים שחיפשו הכי הרבה" />
<!--#include file="inc/header.asp"-->
</head>
<body>
<!--#include file="inc/top.asp"--><%
dim countMe, nikud, whr, ha, i, heb
q = Trim(Request("q"))
If Len(q) > 0 then
	whr = " WHERE typed LIKE """& q &"%"""
	ha = ", המתחילות באות "& q &"'"
End if
countMe = 0
nikud = "bg"%>
<br />
<div id="pTitle">100 המילים שחיפשו הכי הרבה<%=ha %></div>

<div class="table" style="text-align:center; border-bottom:0px;">
	<span style="font-weight:bold;">סינון : </span>
	<span><a href="stats.topSearch.asp">הכול</a></span> / 
	<span><%
	heb = "אבגדהוזחטיכלמנסעפצקרשת"
	For i = 1 to 22 %>
		<a href="stats.topSearch.asp?q=<%=Mid(heb,i,1)%>"><%=Mid(heb,i,1)%></a><%
	Next %>&nbsp;
	</span>
</div>

<table class="table log" style="margin-top:10px;"><%

	'openDB "arabicSearch"
	openDbLogger "arabicSearch","O","stats.topSearch.asp","single",""

	mySQL = "SELECT TOP 100 * FROM wordsSearched"& whr &" ORDER BY searchCount DESC, typed"
	res.open mySQL, con

	    Do until res.EOF
	    if countMe mod 2 = 0 Then nikud = "bg" %>
            <tr class="<%=nikud%>">
                <td style="border-left:0px;">
					<%=res("typed")%>
				</td>
                <td style="text-align:left; border-right:0px;">
		            <%=res("searchCount")%>
		        </td>
		    </tr><%
		    res.moveNext
		    nikud = "bg2"
		    countMe = countMe + 1
		    if countMe mod 50=0 then Response.Flush
	    Loop
	    res.close

	'closeDB
	closeDbLogger "arabicWords","C","stats.topSearch.asp","single",durationMs,""

	%>
	</table>
<br />
<!--#include file="inc/trailer.asp"-->
</body>
</html>