$dataSource = "c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"

$conn = New-Object -ComObject ADODB.Connection
$conn.Open("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=$dataSource")

# Drop the demo table if it exists
try {
    $conn.Execute("DROP TABLE users_demo")
} catch {}

# Create duplicate table structure and copy data (but we want only 3 users, so we can select empty)
$conn.Execute("SELECT * INTO [users_demo] FROM [users] WHERE 1=0")

# Insert 3 generic users
$insertAdmin = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'מנהל מערכת','admin@example.com','מנהל גנרי','admin','admin',15,1)"
$insertEditor = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'עורך מילים','editor@example.com','עורך גנרי','editor','editor',3,1)"
$insertReviewer = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'בקר מילים','reviewer@example.com','בקר גנרי','reviewer','reviewer',5,1)"

$conn.Execute($insertAdmin)
$conn.Execute($insertEditor)
$conn.Execute($insertReviewer)

$conn.Close()
Write-Host "Created users_demo table with 3 generic users successfully."
