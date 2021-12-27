import-module WebAdministration

$ArgsFile = 'C:\temp\list_pools_sites_db.txt'
$SqlInstance = 'IOSERVER-SQL17'

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
  
  cls  
# Остановка сайта и пула из списка
  Write-Host ("Site/Pool "+ $PoolName +" is stopping ...") -ForegroundColor DarkRed
  Invoke-Command -ScriptBlock {Stop-WebSite $PoolName} -ArgumentList $PoolName
  Invoke-Command -ScriptBlock {Stop-WebAppPool -Name $PoolName} -ArgumentList $PoolName
  Write-Output ("... waiting for 3 sec ...")
  Start-Sleep -s 3
  Write-Host  ("Site/Pool "+ $PoolName +" stopped !!!") -ForegroundColor Red
  Write-Host ("------------------------------------------------------") -BackgroundColor Black
 
### START SQL COMMANDS
# Проверка целостности БД
  Write-Host ("Check DB "+ $BaseName +" is starting ...") -ForegroundColor DarkYellow
  Invoke-Sqlcmd -Query "DBCC CHECKDB(N'$BaseName')  WITH NO_INFOMSGS" -ServerInstance "$SqlInstance" -QueryTimeout 0
  Write-Host ("Check DB "+ $BaseName +" is finish !!!") -ForegroundColor Yellow
  Write-Host ("------------------------------------------------------") -BackgroundColor Black
#
  Invoke-Sqlcmd -Query "EXECUTE msdb.dbo.sp_notify_operator @name=N'Оператор SQL',@subject=N'IOSERVER-SQL: Очистка процедурного кэша',@body=N'IOSERVER-SQL: Тест)  WITH NO_INFOMSGS" -ServerInstance "$SqlInstance" -QueryTimeout 0
  


### END SQL COMMANDS

# Запуск сайта и пула из списка
  Write-Host ("Site/Pool "+ $PoolName +" is starting ...") -ForegroundColor DarkGreen
  Invoke-Command -ScriptBlock {Start-WebAppPool -Name $PoolName} -ArgumentList $PoolName
  Invoke-Command -ScriptBlock {Start-WebSite -Name $PoolName} -ArgumentList $PoolName
  Write-Output ("... waiting for 1 sec ...")
  Start-Sleep -s 1
  Write-Host ("Site/Pool "+ $PoolName +" started !!!") -ForegroundColor Green
  Write-Host ("------------------------------------------------------") -BackgroundColor Black


}





