<%
'DUPLICATE FILES!!! also under inc folder

'Remove chars if not Hebrew or Arabic letters, or Geresh
'VERSION 1 [fix-03] - 2018-04-20 (from various Geresh versions to HEBREW geresh)
'VERSION 2 - 2021-03-27 (add digits to regEX)
Function onlyLetters(str)
    Dim regEx,ltrs,i,crnt
    Set regEx = New RegExp
		regEx.Pattern = "[^\dא-ת,ؠ-يٱ-ٳٶ-ە'`‘’‚′‵＇׳]"
   	'regEx.Pattern = "[^\א-ת,ؠ-يٱ-ٳٶ-ە'`‘’‚′‵＇׳]"
    regEx.Global = True
    ltrs = regEx.Replace(str, "")
    for i=1 to len(ltrs)
    	crnt = Mid(ltrs,i,1)
    	SELECT CASE crnt
    		case "'","`","‘","’","‚","′","‵","＇"
    			onlyLetters = onlyLetters + "׳"
    		case else
    			onlyLetters = onlyLetters + crnt
		END SELECT
	next
End Function

'SOUNDEX VERSION 1 [Fix-02] - 2018-04-20' {run onlyLetters function on input}
Function soundex(input)
	dim ltrs, dbl,i,crnt
	ltrs = onlyLetters(input)
	dbl = false

   for i=1 to len(ltrs)
   		crnt = Mid(ltrs,i,1)
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
					if Mid(ltrs,i+1,1)="׳" then 
					 	soundex = soundex+"D"
					 	dbl=true
					else
					 	soundex = soundex+"S"
					end if

				Case "ד"
					if Mid(ltrs,i+1,1)="׳" then 
					 	dbl=true
					end if
				 	soundex = soundex+"D"


				case "ט" 
					if Mid(ltrs,i+1,1)="׳" then 
					 	soundex = soundex+"S"
					 	dbl=true
					else
						soundex = soundex+"T"
					end if

				case "ה","ח" 
					if Mid(ltrs,i+1,1)="׳" then 
					 	dbl=true
					end if
				 	soundex = soundex + "H"

				case "ג"
					if Mid(ltrs,i+1,1)="׳" then 
					 	soundex = soundex + "J"
					 	dbl=true
				 	else
					 	soundex = soundex + "K"
					end if

				case "ז"
					if Mid(ltrs,i+1,1)="׳" then 
					 	soundex = soundex + "J"
					 	dbl=true
				 	else
				 		soundex = soundex + "S"
					end if
			 
				case "ר" 
				 	soundex = soundex + "R"
					if Mid(ltrs,i+1,1)="׳" then 
					 	dbl=true
					end if

				case "ע" 
					if Mid(ltrs,i+1,1)="׳" then 
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
   		end if
   next
   
End Function %>