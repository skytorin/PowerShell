#
New-ADGroup "TestADGroup" -path 'CN=Users,DC=neo,DC=users' -GroupScope DomainLocal -Description 'Тестовая группа' -PassThru –Verbose

#
Get-ADGroup 'demo-all' -properties *

#
Get-ADGroupMember 'demo-all' | ft name

#
Get-ADGroupMember “Администраторы домена” | Get-ADUser  | ft name