<%@ Language="VBScript" CodePage="65001" LCID="1037" %><%
Option Explicit
dim res, res2, con, mySQL, cmd

sub OpenDB(db)
	set con = Server.CreateObject("adodb.connection")
	set res = Server.CreateObject("adodb.recordset")
	set res2 = Server.CreateObject("adodb.recordset")
	set cmd = Server.CreateObject("adodb.command")
	con.provider = "microsoft.jet.oledb.4.0"
	con.Open Server.MapPath("App_Data/"&db&".mdb")
end sub

sub closeDB
	set res = nothing
	set res2 = nothing
	set con = nothing
end sub %>

<!--#include file="includes/functions/string.asp"-->
<!--#include file="includes/functions/functions.asp"-->
<%

dim data,psik

openDB "arabicWords"

    psik = ""
    data = "["
    mySQL = "SELECT id,listName FROM lists ORDER BY TRIM(listName)"
    res.open mySQL, con
    do until res.EOF
            data = data + psik + "{""listName"":"""&gereshFix(res("listName"))&""","
            data = data + """listID"":"""&res("id")&"""}"                        
            psik = ","
        res.moveNext
    loop
    data = data + "]"


closeDB

Response.ContentType = "application/json"
Response.CharSet = "UTF-8"
response.write data


%>