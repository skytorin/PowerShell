### Description: Скрипт удаляет на сетевом хранилище все старые релизные бэкапы и копирует новые из локальной папки сервера
### Autor: Sergeev Nick
### Date: 20.09.2021 

$ServerName=$env:computername 

if ($ServerName -eq 'IOSERVER-SQL') {
		$LocalPathName = 'E:\MSSQL Server Backups\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL_(MSSQL-2014)\'
	}
	elseif ($ServerName -eq 'IOSERVER-SQL2') {
		$LocalPathName = 'F:\MSSQLBackUps\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL2_(MSSQL-2014)\'
	}
	elseif ($ServerName -eq 'IOSERVER-SQL3') {
		$LocalPathName = 'E:\SQLBackup\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL3_(MSSQL-2017)\'
	}
	elseif ($ServerName -eq 'IOSERVER-SQL4') {
		$LocalPathName = 'E:\Backup\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL4_(MSSQL-2017)\'
	}
	elseif ($ServerName -eq 'IOSERVER-SQL5') {
		$LocalPathName = 'E:\Backup\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL5_(MSSQL-2019)\'
	}
	elseif ($ServerName -eq 'WEBOFFICE') {
		$LocalPathName = 'E:\Backup\Before_Release\'
		$NfsPathName = 'Z:\WEBOFFICE_(MSSQL-2016)\'
	}
	elseif ($ServerName -eq 'IOSERVER-SQL17') {
		$LocalPathName = 'D:\SQLBackup\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL17_(MSSQL-2017)\'
	}
	elseif ($ServerName -eq 'IOSERVER-SQL19') {
		$LocalPathName = 'E:\Backup\Before_Release\'
		$NfsPathName = 'Z:\IOSERVER-SQL19_(MSSQL-2019)\'
	}

Remove-item "$NfsPathName\03_Release_Manual_Backup_Full\*.bak"
Copy-Item -Path "$LocalPathName\*.bak" -Destination "$NfsPathName\03_Release_Manual_Backup_Full"
