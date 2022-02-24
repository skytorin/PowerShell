Import-Csv "C:\temp\users.csv" | ForEach-Object {
$upn = $_.SamAccountName + “@neo.users”
$uname = $_.LastName + " " + $_.FirstName
New-ADUser -Name $uname `
-DisplayName $uname `
-GivenName $_.FirstName `
-Surname $_.LastName `
-EmailAddress $_.EmailAddress`
-UserPrincipalName $upn `
-SamAccountName $_.samAccountName `
-Description $_.Description `
-Title $_.Division `
-City $_.City `
-Company $_.Company `
-OfficePhone $_.OfficePhone `
-AccountExpirationDate $_.AccountExpirationDate `
-Path $_.OU `
-AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) -Enabled $true

}


