# Создаём соединение
$SqlServer = "Name_Server";
$SqlCatalog = "Name_DB";
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$SqlServer; Database=$SqlCatalog; Integrated Security=True"

# Открываем соединен
$SqlConnection.Open()

# Выполнение c выводом результата
$SqlCmd = $SqlConnection.CreateCommand()
#$SqlCmd.CommandText = "select state from sys.databases"
$SqlCmd.CommandText = "select name from sysdatabases where name not IN ('master', 'model', 'tempdb', 'msdb')"
$objReader = $SqlCmd.ExecuteReader()
while ($objReader.read()) {
  echo $objReader.GetValue(0) 
  $base= $objReader.GetValue(0)
  
  $SqlCmd.CommandText = "SELECT userName FROM [$base].[dbo].[ns_sec_Users]"
  $objReader = $SqlCmd.ExecuteReader()
  echo $objReader.GetValue(0)
}
$objReader.close()
echo $base






$counter = 10
for($i=1;$i -le $counter;$i++){
$SiteAdress = "http://test.n.srv"
Start-Process $SiteAdress
}








Get-IISSite


