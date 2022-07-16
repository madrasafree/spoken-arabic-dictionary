<%
'TIME FUNCTIONS'
'version 2020-05-05 21:05'

'NOTE: GoDaddy Servers go by Arizona Time - GMT-7

'!!! THIS FUNCTION IS REPLACED By AR2UTC !!!!
function isrTime ()
  'ADD 9 HOURS TO now()
  'info: GoDaddy's Server is 9 hours behind Israel's time
  if left(Request.ServerVariables("http_host"),5)="ronen" then
    isrTime = DateAdd("h",9,now())
  else
    isrTime = now()
  end if
end function

function iso2nums (str)
  dim x
  x = str
  if len(x)>0 then 
    x = replace(x,"T","")
    x = replace(x,"-","")
    x = replace(x,":","")
    x = replace(x,"Z","")
  else
    x = 0
  end if
  'x = CInt(trim(x))
  iso2nums = x
end function

function intToStr (num, length)
	'NUM to STRING
	'Add 0 before single characters
	'info: helps keep date in ISO8601 format [yyyy-mm-ddThh:mm:ssZ]

    dim x
    x = right(string(length,"0") + cStr(num),length)
    intToStr = x
end function


function dateToStrISO8601 (date)
	'use intToStr function to change entire date to string'
	dim y
	y = year(date)&"-"&intToStr(month(date),2)&"-"&intToStr(day(date),2)&"T"&intToStr(hour(date),2)&":"&intToStr(minute(date),2)&":"&intToStr(second(date),2)&"Z"
	dateToStrISO8601 = y
end function

'REPLACED by dateToStrISO8601
function dateToStr (date) 
	'use intToStr function to change entire date to string'
	dim y
	y = year(date)&"-"&intToStr(month(date),2)&"-"&intToStr(day(date),2)&" "&intToStr(hour(date),2)&":"&intToStr(minute(date),2)&":"&intToStr(second(date),2)
	dateToStr = y
end function

function AR2UTC (date)
	'Recive date from server (in Arizona time - UTC-7)
  'Use intToStr function to Format date as STRING acording to ISO8601 + UTC : YYYY-MM-DDTHH:MM:SSZ
  dim y,u
  u = DateAdd("h",7,date) 'add 7 hours
	y = year(u)&"-"&intToStr(month(u),2)&"-"&intToStr(day(u),2)&"T"&intToStr(hour(u),2)&":"&intToStr(minute(u),2)&":"&intToStr(second(u),2)&"Z"
	AR2UTC = y
end function



function Str2hebDate(strDate) 
  'prints STRING as Hebrew Date'
  response.write mid(strDate,9,2) & " ל"
  SELECT case mid(strDate,6,2)
    case 01 response.write "ינואר"
    case 02 response.write "פברואר"
    case 03 response.write "מרץ"
    case 04 response.write "אפריל"
    case 05 response.write "מאי"
    case 06 response.write "יוני"
    case 07 response.write "יולי"
    case 08 response.write "אוגוסט"
    case 09 response.write "ספטמבר"
    case 10 response.write "אוקטובר"
    case 11 response.write "נובמבר"
    case 12 response.write "דצמבר"
  end SELECT
  response.write " "& left(strDate,4)
end function
%>