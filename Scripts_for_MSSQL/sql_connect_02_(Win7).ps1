# ������ ����������
$SqlServer = "Name_Server";
$SqlCatalog = "Name_DB";
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$SqlServer; Database=$SqlCatalog; Integrated Security=True"

# ��������� ����������
$SqlConnection.Open()

# ���������� c ������� ����������
$SqlCmd = $SqlConnection.CreateCommand()
$SqlCmd.CommandText = "select state from sys.databases"
$objReader = $SqlCmd.ExecuteReader()
while ($objReader.read()) {
  echo $objReader.GetValue(0)
}
$objReader.close()
