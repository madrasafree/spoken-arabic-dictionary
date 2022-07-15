<%
'STRING MANIPULATION - VERSION 1 2018-04-13-09:50 [shuki,ronen]

'DOCUMENTATION FOLLOWS CODE'

'1
function displayToSqlQuery(str)

	dim quotes,doubleQuotes
    quotes = chr(34)
    doubleQuotes = chr(34) & chr(34)

    str = replace(str,"'","''") '1.1'
    'str = replace(str,quotes,doubleQuotes) '1.2'
    'str = replace(str,quotes,chr(34))
    str = Replace(str, ChrW(160), "") '1.3'
    str = Replace(str, ChrW(160), "") '1.3'
	str = trim(str) '1.4'

	displayToSqlQuery = str

end function

'6 {MOVE BACK TO FUNCTIONS/STRING.ASP AFTER DIRECTORY SORTING}
function gereshFix(str)

    dim i,crnt

    for i=1 to len(str)
        crnt = Mid(str,i,1)
        SELECT CASE crnt
            case "'","`","‘","’","‚","′","‵","＇"
                gereshFix = gereshFix + "׳"
            case """","“","”","„","‟","″"
                gereshFix = gereshFix + "״"
            case else
                gereshFix = gereshFix + crnt
        END SELECT
    next
end function


'1 - From DISPLAY to SQL Query
	'1.1. Replace each single "GERESH" with double "GERESH"
	'.2. Replace each single "QUOTATION MARK" with double "QUOTATION MARK"
	'.3. Remove 'no-break space' (U+00A0) / chr(160)
	'.4. Trim

'2 - From ACCESS DB to DISPLAY (Show the string to the viewer in its output form)
	'USE server.HTMLEncode(str)

'3 - From URL to ACCESS DB
	'USE Server.URLDecode(str)

'4 - From ACCESS DB to URL
	'USE Server.URLEncode(str)

'5 - From ASP to JS (escape & unescape)
	'USE escape(str)
	'https://www.safaribooksonline.com/library/view/vbscript-in-a/0596004885/re52.html

	'5.2 unescape in JS
	'???'

'6 - 'gereshFix'
	'Replace various GRESHIM / GERSHAIM to Hebrew ones
	'so that we have less string manipulations in our code
	'6.1 - Check user's input for various greshim, and replace them with hebrew geresh/gershaim respectively

'VARIOUS "GRESHIM":
	'U+0027 : APOSTROPHE {APL quote}
	'U+0060 : GRAVE ACCENT
	'U+05F3 : HEBREW PUNCTUATION GERESH
	'U+2018 : LEFT SINGLE QUOTATION MARK {single turned comma quotation mark}
	'U+2019 : RIGHT SINGLE QUOTATION MARK {single comma quotation mark}
	'U+201A : (‚)	SINGLE LOW-9 QUOTATION MARK
	'U+201B : (‛)	SINGLE HIGH-REVERSED-9 QUOTATION MARK
	'U+2032 : (′)	PRIME
	'U+2035 : (‵)	REVERSED PRIME
	'U+FF07 : (＇)	FULLWIDTH APOSTROPHE


'VARIOUS "GERSHAIMIM":
	'U+0022 : QUOTATION MARK
	'U+05F4 : HEBREW PUNCTUATION GERSHAYIM'
	'U+201C : (“)	LEFT DOUBLE QUOTATION MARK
	'U+201D : (”)	RIGHT DOUBLE QUOTATION MARK
	'U+201E : („)	DOUBLE LOW-9 QUOTATION MARK
	'U+201F : (‟)	DOUBLE HIGH-REVERSED-9 QUOTATION MARK
	'U+2033 : (″)	DOUBLE PRIME



'OLDER FUNCTIONS'

Function getString (f)
    getString = replace(f,"'","''")
End function 



%>