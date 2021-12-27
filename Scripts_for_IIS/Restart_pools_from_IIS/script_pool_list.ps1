#Скрипт создает список всех пулов сайтов IIS

#Указать путь к списку
        $HostName="$env:computername"
        $List_POOL_NAME="C:\temp\$($HostName)_List_Pool_IIS.txt"
# подгружаем модуль		
		Import-Module WebAdministration
        
		$applicationPools = Get-ChildItem IIS:\AppPools | ? {$_.state -eq "Started"}
        $i = 0

        Write-Host
        Write-Host "PoolName"
        Set-Content -Value "PoolName" -Path $List_POOL_NAME 
       
        $applicationPools | % {
            "{1}" -f $i, $($applicationPools[$i].Name) 

            Add-Content -Value $($applicationPools[$i].Name)  -Path $List_POOL_NAME 
            $i++
        }
        read-host "Для выхода нажмите Enter"
        