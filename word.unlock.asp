<!--#include file="includes/inc.asp"--><%
' word.unlock.asp - Removes the lock from a word when the user cancels editing
dim wordID
wordID = request("id")

if len(wordID) > 0 AND session("role") >= 2 then
    openDB "arabicWords"
    
    ' Only unlock if the current user is the one who locked it
    mySQL = "SELECT lockedUTC FROM words WHERE id=" & wordID
    res.open mySQL, con
    if not res.EOF then
        if len(res("lockedUTC")) > 0 then
            dim lockUID
            lockUID = right(res("lockedUTC"), len(res("lockedUTC")) - 24)
            if CINT(lockUID) = session("userID") then
                mySQL = "UPDATE words SET lockedUTC='' WHERE id=" & wordID
                con.execute mySQL
            end if
        end if
    end if
    res.close
    
    closeDB
end if

response.redirect "word.asp?id=" & wordID
%>
