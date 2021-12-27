#Указать путь к списку пулов
$HostName="$env:computername"
$List_POOL_NAME="C:\temp\$($HostName)_List_Pool_IIS.txt"
Write-Host
Write-Host 'Используется список пулов '$List_POOL_NAME

$POOL_NAME_List=@(Import-Csv -Path $List_POOL_NAME)
Write-Host

import-module WebAdministration

#Остановка всех сайтов и пулов из списка

foreach ($thisPool in $POOL_NAME_List)
{

Write-Output ($thisPool.PoolName +" is stopping...")
$CurrentPoolName=$thisPool.PoolName

Invoke-Command   -ScriptBlock {Stop-WebSite $CurrentPoolName} -ArgumentList $CurrentPoolName
Invoke-Command   -ScriptBlock {Stop-WebAppPool -Name $CurrentPoolName} -ArgumentList $CurrentPoolName

Write-Output ($thisPool.PoolName +" stopped")
Write-Host
}

#Ожидание 10 секунд

Write-Output ("...waiting for 10 sec...")
Start-Sleep -s 10
Write-Host

#Выбор опции работы с сайтами
$confirmation_temp = Read-Host "Удалить временные файлы temp? [y/n]"
while (($confirmation_temp -ne 'y') -and ($confirmation_temp -ne 'n'))
{    $confirmation_temp = Read-Host "Удалить временные файлы temp? [y/n]"}

if ($confirmation_temp -eq "y"){Write-Host 'Temp will be deleted'}
else {Write-Host 'Okay'}
Write-Host

$confirmation_logs = Read-Host "Удалить логи logs? [y/n]"
while (($confirmation_logs -ne 'y') -and ($confirmation_logs -ne 'n'))
{   $confirmation_logs = Read-Host "Удалить логи logs? [y/n]"}

if ($confirmation_logs -eq "y"){Write-Host 'Logs will be deleted'}
else {Write-Host 'Okay'}
Write-Host

##Поиск директории сайта, удаление файлов из /temp, запуск пула

foreach ($thisPool in $POOL_NAME_List)
{
[Void][Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Administration")

$siteName = $thisPool.PoolName

$serverManager = New-Object Microsoft.Web.Administration.ServerManager
$site = $serverManager.Sites | where { $_.Name -eq $thisPool.PoolName }
$rootApp = $site.Applications | where { $_.Path -eq "/" }
$rootVdir = $rootApp.VirtualDirectories | where { $_.Path -eq "/" }

$tempPath=($rootVdir.PhysicalPath +'\temp')
$logsPath=($rootVdir.PhysicalPath +'\logs')

Write-Host $tempPath

Remove-Item $tempPath -Recurse
Write-Output ("Temporeary files of " + $thisPool.PoolName +" is deleted")
Write-Host

Write-Host $logsPath

Remove-Item $logsPath -Recurse
Write-Output ("Log files of " + $thisPool.PoolName +" is deleted")
Write-Host

Write-Output ($thisPool.PoolName +" is starting...")
$CurrentPoolName=$thisPool.PoolName

Invoke-Command   -ScriptBlock {Start-WebAppPool -Name $CurrentPoolName} -ArgumentList $CurrentPoolName
Invoke-Command   -ScriptBlock {Start-WebSite $CurrentPoolName} -ArgumentList $CurrentPoolName

Write-Output ($thisPool.PoolName +" started")
Write-Host
}


##


Write-Output "End"
Write-Host

read-host "Для выхода нажмите Enter"