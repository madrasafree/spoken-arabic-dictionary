$ErrorActionPreference = "Stop"
try {
  $dataSource = "c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"
  $connectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=$dataSource"
    
  $conn = New-Object System.Data.OleDb.OleDbConnection
  $conn.ConnectionString = $connectionString
  $conn.Open()
    
  try {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "DROP TABLE users_demo"
    $cmd.ExecuteNonQuery()
  }
  catch {}

  $cmd = $conn.CreateCommand()
  $cmd.CommandText = "SELECT * INTO [users_demo] FROM [users] WHERE 1=0"
  $cmd.ExecuteNonQuery()

  $cmd.CommandText = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'מנהל מערכת','admin@example.com','מנהל גנרי','admin','admin',15,1)"
  $cmd.ExecuteNonQuery()

  $cmd.CommandText = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'עורך מילים','editor@example.com','עורך גנרי','editor','editor',3,1)"
  $cmd.ExecuteNonQuery()

  $cmd.CommandText = "INSERT INTO [users_demo] ([userStatus],[name],[eMail],[about],[username],[password],[role],[gender]) VALUES (1,'בקר מילים','reviewer@example.com','בקר גנרי','reviewer','reviewer',5,1)"
  $cmd.ExecuteNonQuery()

  $conn.Close()
  "Success!" | Out-File c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\tools\ps_out.txt
}
catch {
  $Error[0].ToString() | Out-File c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\tools\ps_err.txt
}
