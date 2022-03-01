$EXP_CSV = "C:\temp\users_expiration_date.csv"
$FIRST_ALERT = 30
$SECOND_ALERT = 5
$Global:From = "email@from"
#$Global:To1 = $_.EmailAddress
#$Global:To2 = ""
#$Global:To3 = ""
#$Global:To4 = ""
$Global:SMTPServer = "mail.loc" 
$Global:Subject = "Истечение подписки на техническую поддержку продуктов экосистемы НЕОСИНТЕЗ"

$HTML = @"
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<h2>Уважаемый клиет.</h2>
<br>
<h3>Хотим уведомить Вас, что через $FIRST_ALERT дней заканчивается срок действия подписки на услуги технической поддержки.</h3> 
<br>
<br>
<h4>Техническая поддержка включает в себя:</h4> 
<h4>• Возможность бесплатного получение услуг по перемещению и перераспределению лицензий;</h4>
<h4>• Обмен на новые версии программного обеспечения – предоставление новых версий ПО посредством электронной передачи данных;</h4>
<h4>• Обновления программного обеспечения – предоставление патчей, фиксов посредством электронной передачи данных;</h4>
<h4>• Рассылку информации о выпущенных новых версиях и новых обновлений со списком доработок;</h4>
<h4>• Возможность бесплатного получения новых разработок ООО «НЕОЛАНТ Сервис» для опытной эксплуатации с целью оценки их функциональных возможностей на оговоренный период времени;</h4>
<h4>• Предоставление технической информации по функциональности продуктов;</h4>
<h4>• Возможность обращения с предложением по изменению программного обеспечения, включая разработку новых функций и/или совершенствованию компонентов;</h4>
<h4>• Получение консультаций по программным продуктам по темам: базовые функции, инсталляция, настройки, решение проблемных ситуаций, обновление версий.</h4>
<br>
<br>
<h4>Каналы предоставления услуги Техническая поддержка:</h4>
<h4>- Web портал http://neosphere.neolant.com - основной канал.</h4>
<h4>- E-mail neosphere@neolant.com</h4>
<br>
<br>
<h4>--</h4>
<h4>С уважением,</h4>
<h4>Служба технической поддержки портала НЕОСФЕРА</h4>
$Messages
</body>
</html>
"@

# Удаление старого файла CSV
Remove-item $EXP_CSV

# Выгружаем даные по всем пользователям в файл CSV
Get-ADUser -Filter * -properties SamAccountName, AccountExpirationDate, EmailAddress |`
 Select Name, SamAccountName, EmailAddress, AccountExpirationDate |`
  Export-csv -path $EXP_CSV -Append -Delimiter ';' -Encoding UTF8

# 
$Date_Time_Now = Get-Date -Format s
Import-Csv $EXP_CSV -Delimiter ';' | foreach {
    #$CurrentObject = $_
    $Date_Time_Expiration = $_.AccountExpirationDate
    #$EmailAddress = $_.EmailAddress
    if ( !$Date_Time_Expiration )
      {
        $Date_Time_Expiration = "01.01.9999 0:00:00"
      }
    $Date_Time_Expiration = Get-Date -Format s $Date_Time_Expiration
    $Date_Time_Now, $Date_Time_Expiration = $Date_Time_Now, $Date_Time_Expiration| ForEach-Object {[DateTime]$_}
    $Days_Expiration = $Date_Time_Expiration - $Date_Time_Now
    if ( $Days_Expiration.days -eq $FIRST_ALERT )
      {
      Write-Host "Срок действия УЗ" $_.SamAccountName "закончится через" $FIRST_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
      #$Body = "Уважаемый клиент. Хотим уведомить, что у Вас заканчивается срок подписки на услуги технической поддержки, которая включает в себя бла, бла, бла..."
      #$Body = 'Срок действия УЗ:' + $_.SamAccountName 'закончится через:' + $SECOND_ALERT 'дней. Необходимо уведомить пользователя по адресу:' + $_.EmailAddress
      $Body = $HTML
      $Encoding = [System.Text.Encoding]::UTF8
      Send-MailMessage -From $From -to $_.EmailAddress -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To2 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer #-Attachments $data_different
      #Send-MailMessage -From $From -to $To3 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer #-Attachments $data_different
      #Send-MailMessage -From $From -to $To4 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer #-Attachments $data_different
      }
    elseif ( $Days_Expiration.days -eq $SECOND_ALERT )
      {
      Write-Host "Срок действия УЗ:" $_.SamAccountName "закончится через:" $SECOND_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
      } 
    else
      {
      Write-Host "Дней до истечения УЗ" $_.SamAccountName : $Days_Expiration.days
      }
  } 

   
