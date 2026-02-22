$ErrorActionPreference = "Stop"

try {
  $dataSource = "c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb"
  $connectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=$dataSource"
    
  $conn = New-Object System.Data.OleDb.OleDbConnection
  $conn.ConnectionString = $connectionString
  $conn.Open()
    
  # Check if users_orig exists, drop it
  try {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "DROP TABLE users_orig"
    $cmd.ExecuteNonQuery()
  }
  catch {}

  # Rename users -> users_orig using SELECT INTO and DROP
  $cmd = $conn.CreateCommand()
  $cmd.CommandText = "SELECT * INTO [users_orig] FROM [users]"
  $cmd.ExecuteNonQuery()
    
  $cmd = $conn.CreateCommand()
  $cmd.CommandText = "DROP TABLE [users]"
  $cmd.ExecuteNonQuery()

  # Rename users_demo -> users using SELECT INTO
  $cmd = $conn.CreateCommand()
  $cmd.CommandText = "SELECT * INTO [users] FROM [users_demo]"
  $cmd.ExecuteNonQuery()

  $conn.Close()
    
  "Operations Completed" | Out-File c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\tools\ps_replace_out.txt
}
catch {
  $Error[0].ToString() | Out-File c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\tools\ps_replace_err.txt
}
