# Вывод основной информации о всех пользователях
Get-ADUser -Filter *

# Подробная информация об одном пользователе
Get-ADUser -identity pupkin -properties *

# Вывод имени пользователя, email и даты истечения УЗ в консоль
Get-ADUser -Filter * -properties SamAccountName, AccountExpirationDate, EmailAddress |`
 Format-Table Name, SamAccountName, EmailAddress, AccountExpirationDate 



# Вывод имени пользователея, email и даты истечения УЗ в файл TXT
Get-ADUser -Filter * -properties SamAccountName, AccountExpirationDate, EmailAddress |`
 Format-Table Name, SamAccountName, EmailAddress, AccountExpirationDate >`
  C:\temp\users_expiration_date.txt



# Вывод имени пользователя, email и даты истечения УЗ в файл CSV
Get-ADUser -Filter * -properties SamAccountName, AccountExpirationDate, EmailAddress |`
 Select Name, SamAccountName, EmailAddress, AccountExpirationDate |`
  Export-csv -path  C:\temp\users_expiration_date.csv -Append -Encoding UTF8



# Подсчет количества дней до истечения УЗ
$Date_Time_Now = Get-Date -Format s
Import-Csv "C:\temp\users_expiration_date.csv" -Delimiter ';' | foreach {
    #$CurrentObject = $_
    $Date_Time_Expiration = $_.AccountExpirationDate
    if (!$Date_Time_Expiration)
      {
        $Date_Time_Expiration = "01.01.9999 0:00:00"
      }
    $Date_Time_Expiration = Get-Date -Format s $Date_Time_Expiration
    $Date_Time_Now, $Date_Time_Expiration = $Date_Time_Now, $Date_Time_Expiration| ForEach-Object {[DateTime]$_}
    $Days_Expiration = $Date_Time_Expiration - $Date_Time_Now
    Write-Host "Дней до истечения УЗ" $_.SamAccountName : $Days_Expiration.days
  } 
  } 

