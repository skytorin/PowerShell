import-module WebAdministration

$ArgsFile = 'C:\temp\list_pools_sites_db.txt'

foreach ($line in (Get-Content $ArgsFile)) {
 # foreach ($char in $args) {
 #   $line = $line | ? { $_ -like "*$char*" }
 # }
 # $SiteName='Site Name = '+$line.Split(":")[0]
 # $PoolName='Pool Name = '+$line.Split(":")[1]
 # $BaseName='Base Name = '+$line.Split(":")[2]
 # $SiteName
 # $PoolName
 # $BaseName
  $SiteName=$line.Split(":")[0]
  $PoolName=$line.Split(":")[1]
  $BaseName=$line.Split(":")[2]
    
# Остановка сайта и пула из списка
  Write-Output ($PoolName +" is stopping...")
 
  Invoke-Command   -ScriptBlock {Stop-WebSite $PoolName} -ArgumentList $PoolName
  Invoke-Command   -ScriptBlock {Stop-WebAppPool -Name $PoolName} -ArgumentList $PoolName

  Write-Output ($PoolName +" stopped")
  Write-Host
# Ожидание 10 секунд
  Write-Output ("...waiting for 10 sec...")
  Start-Sleep -s 10
  Write-Host

  ### SQL





  ### SQL

# Запуск сайта и пула из списка
  Write-Output ($PoolName +" is starting...")
 
  Invoke-Command   -ScriptBlock {Start-WebAppPool -Name $PoolName} -ArgumentList $PoolName
  Invoke-Command   -ScriptBlock {Start-WebSite -Name $PoolName} -ArgumentList $PoolName

  Write-Output ($PoolName +" started")
  Write-Host
# Ожидание 10 секунд
  Write-Output ("...waiting for 10 sec...")
  Start-Sleep -s 10
  Write-Host

}





