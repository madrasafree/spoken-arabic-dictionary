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
end sub 

%>
<!--#include file="includes/functions/string.asp"-->
<!--#include file="includes/functions/functions.asp"-->
<%

'GET SEARCH FROM CLIENT

dim relData,wordID,search,data,psik,count,qq,iArb,topFill

relData = split(request("relData"),",")
wordID = relData(0)
search = gereshFix(relData(1))

'search = replace(search," ","")
qq = """"
data = "["
psik = ""
count = 1


openDB "arabicWords"
'add EXACT results to array
mySQL = "SELECT id,arabic,hebrewTranslation,arabicWord FROM words WHERE show=true AND (hebrewClean = '"&search&"' OR arabicClean = '"&search&"')"
res.open mySQL, con
if res.EOF then
    data = data
else
    do until res.EOF
        iArb = res("arabic")
        if res("arabic") = Null then iArb = ""
        if res("id") <> CINT(wordID) then
            data = data & psik & "{"&qq&"id"&qq&":"& CSTR(res("id")) &","&qq&"arabic"&qq&":"&qq& iArb &qq&","&qq&"hebrew"&qq&":"&qq & res("hebrewTranslation") & qq&","&qq&"taatik"&qq&":"&qq & res("arabicWord") & qq&"}"
            count = count + 1
            psik = ","
        end if
        res.moveNext
    loop
end if
res.close

'add more results to array
topFill = 10-count
mySQL = "SELECT TOP "&topFill& " id,arabic,hebrewTranslation,arabicWord FROM words WHERE show=true AND (hebrewClean LIKE '%"&search&"%' OR arabicClean LIKE '%"&search&"%' OR arabicHebClean LIKE '%"&search&"%')"
res.open mySQL, con
if res.EOF then
    data = data
else
    do until res.EOF
        iArb = res("arabic")
        if res("arabic") = Null then iArb = ""
        if res("id") <> CINT(wordID) then
            data = data & psik & "{"&qq&"id"&qq&":"& CSTR(res("id")) &","&qq&"arabic"&qq&":"&qq& iArb &qq&","&qq&"hebrew"&qq&":"&qq & res("hebrewTranslation") & qq&","&qq&"taatik"&qq&":"&qq & res("arabicWord") & qq&"}"
            count = count + 1
            psik = ","
        end if
        res.moveNext
    loop
end if
res.close
closeDB

data = data + "]"

Response.ContentType = "application/json"
Response.CharSet = "UTF-8"
response.write data
%>