Get-ChildItem "C:\Site\*\logs\*\*.log" | Where CreationTime -lt (Get-Date).AddDays(-15) | Remove-Item -Force
