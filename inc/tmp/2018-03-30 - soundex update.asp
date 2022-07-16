<!--#include file="inc/inc.asp"--><%
If session("role") <> 15 then Response.Redirect "login.asp" 
response.write "ONE TIME FIX - DO NOT RE-USE!"

'DISABLED'
response.end
'DISABLED' %>

<!DOCTYPE html>
<html>
<head>
	<title>CREATE INITIAL SOUNDEX - version 1 (2018-03-10)</title>
    <meta name="robots" content="none">
    <meta charset="UTF-8">
    <script src="inc/functions/soundex.js"></script>
</head>
<body>
<div class="view" dir="ltr"><%
dim heb,hebClean,sndxHeb
dim arb,arbClean,sndxArb,taatik,taatikClean

response.write "<br/>FOR EACH WORD in DB (where is clean Hebrew & Taatik, no sndxArb or no sndxHeb)"
response.write "<br/>CLEAN HEBREW"
response.write "<br/>CLEAN ARABIC"
response.write "<br/>CLEAN TAATIK"
response.write "<br/>CREATE SOUNDEX from CLEAN HEBREW"
response.write "<br/>CREATE SOUNDEX from CLEAN ARABIC (if no Arabic, than from taatik)"
'response.end


Function soundex(input)
	dim ltrs, dbl,i,crnt
	ltrs = input
	'output = ""
	dbl = false

   'Remove chars if not Hebrew or Arabic letters, or Geresh
   '???

   for i=1 to len(ltrs)
   		crnt = Mid(ltrs,i,1)
   		'response.write = "crnt = "&crnt
   		if dbl = true then 
   			dbl = false
		else
			SELECT CASE crnt
				Case "א", "ו", "י"
					if i=1 then
						if crnt="א" then soundex = soundex + "A"
						if crnt="ו" then soundex = soundex + "W"
						if crnt="י" then soundex = soundex + "Y"
					end if

				Case "צ","ץ"
					if Mid(ltrs,i+1,1)="'" then 
					 	soundex = soundex+"D"
					 	dbl=true
					else
					 	soundex = soundex+"S"
					end if

				Case "ד"
					if Mid(ltrs,i+1,1)="'" then 
					 	dbl=true
					end if
				 	soundex = soundex+"D"


				case "ט" 
					if Mid(ltrs,i+1,1)="'" then 
					 	soundex = soundex+"S"
					 	dbl=true
					else
					 	soundex = soundex+"T"
					end if

				case "ה","ח" 
					if Mid(ltrs,i+1,1)="'" then 
					 	dbl=true
					end if
				 	soundex = soundex + "H"

				case "ג"
					if Mid(ltrs,i+1,1)="'" then 
					 	soundex = soundex + "J"
					 	dbl=true
				 	else
					 	soundex = soundex + "K"
					end if

				case "ז"
					if Mid(ltrs,i+1,1)="'" then 
					 	soundex = soundex + "J"
					 	dbl=true
				 	else
				 		soundex = soundex + "S"
					end if
			 
				case "ר" 
				 	soundex = soundex + "R"
					if Mid(ltrs,i+1,1)="'" then 
					 	dbl=true
					end if

				case "ע" 
					if Mid(ltrs,i+1,1)="'" then 
					 	dbl=true
					 	soundex = soundex + "R"
					else
					 	soundex = soundex + "A"
					end if

   
				case "د","ذ","ض" soundex = soundex + "D"
			    case "ص","س","ס","ز","ظ" soundex = soundex + "S"
			    case "ط","ت","ת","ث" soundex = soundex + "T"
			    case "ب","ב" soundex = soundex + "B"
			    case "ن","נ","ן" soundex = soundex + "N"
			    case "ع","ע" soundex = soundex + "A"
			    case "ة","ه","ح","خ" soundex = soundex + "H"
			    case "ك","כ","ך","ق","ק" soundex = soundex + "K"
			    case "ش","ש","ج" soundex = soundex + "J"
			    case "غ","ر" soundex = soundex + "R"
			    case "ل","ל" soundex = soundex + "L"
			    case "ف","פ","ף" soundex = soundex + "F"
			    Case "م","מ","ם" soundex = soundex + "M"
				Case else soundex = soundex + ""


			END SELECT
   			'response.write ","+ crnt
   			'response.write output
   		end if
   next
   
End Function


openDB "arabicWords"
mySQL = "SELECT * FROM words"
res.open mySQL, con 
	do until res.EOF 
		heb = res("hebrewTranslation") 
		if len(res("arabic"))>0 then 
			taatik = res("arabic")
		else
			taatik = res("arabicWord")
		end if 

		mySQL = "UPDATE words SET sndxHebrewV1='"&soundex(heb)&"', sndxArabicV1='"&soundex(taatik)&"' WHERE id="&res("id")
		cmd.CommandType=1
		cmd.CommandText=mySQL
		'Response.Write "<br/>"&mySQL
		'Response.End
		set cmd.ActiveConnection=con
		cmd.execute ,,128

		res.moveNext
	loop
res.close

response.write "<br/>ALL DONE!! :)"
response.end
closeDB
%>
</div>
</body>