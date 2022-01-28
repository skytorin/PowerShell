$date_now = (Get-Date -Format dd.MM.yyyy)
Get-FileHash -Path "C:\Backups\*.bak" -Algorithm MD5 | Format-List | Out-File Checksumm_MD5_$date_now.txt
