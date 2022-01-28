# Управление группами Active Directory с помощью PowerShell

## Проверка модуля
Запрос всех модулей
```ps
Get-Command -Module ActiveDirectory
```
Запрос командлета для работы с группами AD
```ps
Get-Command -Module ActiveDirectory -Name "*Group*"
```

Установка модуля
```ps
Import-Module activedirectory
```

Cоздание новой группы в Active Directory
```ps
New-ADGroup "TestADGroup" -path 'CN=Users,DC=neo,DC=users' -GroupScope DomainLocal -Description 'Тестовая группа' -PassThru –Verbose
```

Добавить пользователей в группу Active Directory
```ps
Add-AdGroupMember -Identity TestADGroup -Members user1, user2
```

Массовое добавление пользователей в группу Active Directory чрез файл CSV
```ps
Import-CSV .\users.csv -Header users | ForEach-Object {Add-AdGroupMember -Identity ‘TestADGroup’ -members $_.users}
```

Получаем всех членов одной группы (groupA) и добавляем их в другую группу (groupB)
```ps
Get-ADGroupMember “GroupA” | Get-ADUser | ForEach-Object {Add-ADGroupMember -Identity “Group-B” -Members $_}
```

Cкопировать в новую группу и членов всех вложенных групп (рекурсивно)
```ps
Get-ADGroupMember -Identity “GroupA” -Recursive | Get-ADUser | ForEach-Object {Add-ADGroupMember -Identity “GroupB” -Members $_}
```

С Windows Server 2016 можно использовать функцию временного членства в группах безопасности AD.  
Через 2 часа этот пользователь будет автоматически удален из данной группы.
```ps
$ttl = New-TimeSpan -Hours 2
Add-ADGroupMember -Identity "Domain Admins" -Members a.ivanov -MemberTimeToLive $ttl
```

Удалить пользователей из группы
```ps
Remove-ADGroupMember -Identity TestADGroup -Members user1, user2, user3
```

Массовое удаление пользователей из группы по файлу CSV
```ps
Import-CSV .\users.csv -Header users | ForEach-Object {Remove-ADGroupMember -Identity ‘TestADGroup’ -members $_.users}
```

Получить информацию о группе AD
```ps
Get-ADGroup 'TestADGroup'
```

Подробный вывод информации о группе AD
```ps
Get-ADGroup 'TestADGroup' -properties *
```

Фильтрация вывода информации
```ps
Get-ADGroup -LDAPFilter “(name=*admins*)” | Format-Table
```
или
```ps
Get-ADGroup -Filter {name -like "*admins*"} -Properties Description,info | Select Name,samaccountname,Description,info
```

С помощью Get-ADGroup можно получить список членов группы (хранится в атрибуте members)
```ps
Get-ADGroup -Identity "Domain Admins" -Properties members | Select-Object -ExpandProperty members
```

Выести список пользователей в группе Active Directory
```ps
Get-ADGroupMember 'TestADGroup'
```
или
```ps
Get-ADGroupMember 'TestADGroup'| ft name
```

Полный список членов, в том числе всех вложенных групп
```ps
Get-ADGroupMember ‘server-admins' -recursive| ft name
```

Экспорт списка пользователей, состоящих в определённой группе в CSV файл:
```ps
Get-ADGroupMember ‘server-admins' -recursive| ft samaccountname| Out-File c:\ps\admins.csv
```





















