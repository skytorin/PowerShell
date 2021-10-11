Get-FileHash -Path "C:\Backups\*.bak" -Algorithm MD5 | Format-List | Out-File Checksumm_MD5_20190921.txt
