<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "team/login.asp" %>
<!DOCTYPE html>
<html>
<head>
	<title>'</title>
    <meta name="robots" content="none">
<!--#include file="inc/header.asp"-->
</head>
<body>

<div style="max-width:800px; margin:0 auto;"><%

    Dim customSelect,fld

    customSelect = request("query")

    if (len(customSelect)=0) or (customSelect=null) then
        customSelect = " * FROM words WHERE len(hebrewTranslation)>26" 
    end if

    response.write "<br/>customSelect = "&customSelect %>

    <h1>SELECT</h1>
    <form dir="ltr" style="text-align:center;" action="select.asp">
        <input type="text" name="query" value="<%=customSelect%>" style="min-width:500px;" />
        <button type="submit">RUN</button>
    </form><%

    openDB "arabicWords"
    mySQL = "SELECT "&customSelect
    res.open mySQL, con
    do until res.EOF %>
        <div onclick="location.href='word.asp?id=<%=res("id")%>'"><%
        For Each fld In res.Fields %>
            <span><%=fld.Value%></span><%
        Next %>
        </div><%
        res.movenext
    loop
    closeDB %>
</div>
</body>