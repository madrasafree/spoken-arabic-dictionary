<!--#include file="inc/inc.asp"--><%

dim debugMode,LID,maxPos
LID = Request("lid")

debugMode = FALSE
if debugMode then response.write "<b>Debug Mode - START</b><br>"

if debugMode = false then 
    response.write "OOPS! Something went wrong..."
    response.write "<br>It would be very helpful if you email us the content of this page to <br><b>arabic4hebs@gmail.com</b>"
    response.write "<br>SHUKRAN! <3"
    response.write "<br>"
    response.write "<br>ERROR ON listsToggle.asp"
    response.write "<br>list id = "&LID
end if


if len(session("userID"))<1 then 
    session("msg") = "יש להתחבר על מנת לשמור רשימה למועדפים"
    Response.Redirect "lists.asp?id="&LID
end if

maxPos = 0
if debugMode then response.write "<br>LID="&LID


startTime = timer()
'openDB "arabicWords"
openDbLogger "arabicWords","O","listsToggle.asp","single",""

'check top position from user's lists (add 1 in INSERT)
mySQL ="SELECT MAX(pos) FROM listsUsers WHERE [user]="&session("userID")
res.open mySQL, con
    if res(0)>0 then maxPos = res(0)
res.close
if debugMode then response.write "<br>max="& maxPos


'check if list is fav. 
mySQL = "SELECT * FROM listsUsers WHERE list="&LID&" AND user="&session("userID")
res.open mySQL, con
if res.EOF then
    'if not - INSERT record
    mySQL = "INSERT INTO listsUsers (list,[user],pos) VALUES ('"&LID&"','"&session("userID")&"','"&maxPos+1&"')"
else
    'if is fav - DELETE record
    mySQL = "DELETE FROM listsUsers WHERE list="&LID&" AND user="&session("userID")
end if
res.close

if debugMode then 
    response.write "<br>mySQL:<br>"& mySQL
    response.write "<br><br><b>END Debug Mode</b>"
    response.end
end if
cmd.CommandType=1
cmd.CommandText=mySQL
Set cmd.ActiveConnection=con
cmd.execute ,,128

endTime = timer()
durationMs = Int((endTime - startTime)*1000)
'closeDB
closeDbLogger "arabicWords","C","listsToggle.asp","single",durationMs,""

Response.Redirect "lists.asp?id="&LID
%>
