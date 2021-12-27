$path_from_logs = "C:\Sites\*\logs\*\*.log" 
$older_days = "-15"

# Поиск по дате создания и удаление файлов по маске старше X дней
Get-ChildItem $path_from_logs | Where CreationTime -lt (Get-Date).AddDays($older_days) | Remove-Item -Force

# Поиск по дате изменения и удаление файлов по маске старше X дней
Get-ChildItem $path_from_logs | Where LastWriteTime -lt (Get-Date).AddDays($older_days) | Remove-Item -Force
