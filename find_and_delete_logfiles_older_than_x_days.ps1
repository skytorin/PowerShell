### Description: Скрипт рекурсивно ищет все лог файлы старше заданного значения и удаляет их  
### Autor: Sergeev Nick
### Date: 28.12.2021
### Run for Sheduler: PowerShell.exe -ExecutionPolicy Bypass -File "C:\Scripts\find_and_delete_logfiles_older_than_x_days.ps1"

$path_from_logs = "C:\Sites\*\logs\*\*.log" 
$older_days = "-15"

# Поиск по дате создания и удаление файлов по маске старше X дней
Get-ChildItem $path_from_logs | Where CreationTime -lt (Get-Date).AddDays($older_days) | Remove-Item -Force

# Поиск по дате изменения и удаление файлов по маске старше X дней
Get-ChildItem $path_from_logs | Where LastWriteTime -lt (Get-Date).AddDays($older_days) | Remove-Item -Force
