Set conn = CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicWords.mdb"

conn.Execute "UPDATE words SET lockedUTC='' WHERE len(lockedUTC)>1"

' Verify
Set rs = conn.Execute("SELECT count(*) FROM words WHERE len(lockedUTC)>1")
WScript.Echo "Remaining locked entries: " & rs(0).Value

conn.Close
