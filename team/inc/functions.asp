<%
function isAndroid ()
    if inStr(lcase(Request.ServerVariables ("HTTP_USER_AGENT")),"android")>0 then
        isAndroid = true
    else
        isAndroid = false
    end if
end function

function showShada (word)
    if isAndroid then
        showShada=Replace(word,chrw(&H0651),chrw(&hFB1E))
    else
        showShada=word
    end if
end function %>
