$EXP_CSV = "C:\temp\users_expiration_date.csv"
$Global:FIRST_ALERT = 30
$Global:SECOND_ALERT = 5
#$Global:DAYS_ALERT = ""
$Global:From = "email@from"
$Global:To1 = "email@to"
#$Global:To2 = ""
#$Global:To3 = ""
#$Global:To4 = ""
$Global:SMTPServer = "mail.loc" 
$Global:Subject = "Истечение подписки на техническую поддержку продуктов экосистемы НЕОСИНТЕЗ"

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
    $po_1 = ""
    $po_2 = ""
    $po_3 = ""
    $po_4 = ""
    $po_5 = ""
    $PO = Get-ADUser $_.SamAccountName -properties memberof | select memberof -expandproperty memberof
switch( $PO )
{    
    'CN=prod-neosyntez,CN=Users,DC=neo,DC=users'
    {
        $po_1 = 'СУИД НЕОСИНТЕЗ'
    }
    'CN=prod-polinom,CN=Users,DC=neo,DC=users'
    {
        $po_2 = 'САПР ПОЛИНОМ'
    }
    'CN=prod-interbridge,CN=Users,DC=neo,DC=users'
    {
        $po_3 = 'Конвертер инженерных моделей InterBridge / Средство просмотра инженерных моделей InterView'
    }
     'CN=prod-interstorage,CN=Users,DC=neo,DC=users'
    {
        $po_4 = 'Интеграционное решение InterStorage for SPF'
    } 
    'CN=prod-digital-decommissioning,CN=Users,DC=neo,DC=users'
    {
        $po_5 = 'Платформа Digital Decommissioning'
    }
    #Default
    #{
    #    'None'
    #}
}
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
      $DAYS_ALERT = $FIRST_ALERT
      $HTML = @"
<!DOCTYPE html>
<html>
<head>
  <style>
   .colortext {
     color: red; /* Красный цвет выделения */
   }
  </style>
</head>
<body>
<h2>Уважаемый клиент.</h2>
<br>
<p><h3>Хотим уведомить Вас, что через <span class="colortext">$DAYS_ALERT</span> дней заканчивается срок действия подписки на услуги технической поддержки по следующим продуктам:</h3></p> 
<h3 style="color:#4682B4"><a href="https://neosphere.neolant.com/display/neoSyn">$po_1</a></h3>  
<h3 style="color:#4682B4">$po_2</h3>
<h3 style="color:#4682B4">$po_3</h3>
<h3 style="color:#4682B4">$po_4</h3>
<h3 style="color:#4682B4">$po_5</h3>
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
      $Body = $HTML
      $Encoding = [System.Text.Encoding]::UTF8
      Send-MailMessage -From $From -to $_.EmailAddress -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      Send-MailMessage -From $From -to $To1 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To2 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To3 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To4 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      }
    elseif ( $Days_Expiration.days -eq $SECOND_ALERT )
      {
      Write-Host "Срок действия УЗ:" $_.SamAccountName "закончится через:" $SECOND_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
      $DAYS_ALERT = $SECOND_ALERT
      $HTML = @"
<!DOCTYPE html>
<html>
<head>
  <style>
   .colortext {
     color: red; /* Красный цвет выделения */
   }
  </style>
</head>
<body>
<h2>Уважаемый клиент.</h2>
<br>
<p><h3>Хотим уведомить Вас, что через <span class="colortext">$DAYS_ALERT</span> дней заканчивается срок действия подписки на услуги технической поддержки по следующим продуктам:</h3></p> 
<h3 style="color:#4682B4">$po_1</h3>
<h3 style="color:#4682B4">$po_2</h3>
<h3 style="color:#4682B4">$po_3</h3>
<h3 style="color:#4682B4">$po_4</h3>
<h3 style="color:#4682B4">$po_5</h3>
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
      $Body = $HTML
      $Encoding = [System.Text.Encoding]::UTF8
      Send-MailMessage -From $From -to $_.EmailAddress -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      Send-MailMessage -From $From -to $To1 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To2 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To3 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      #Send-MailMessage -From $From -to $To4 -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different
      } 
    else
      {
      Write-Host "Дней до истечения УЗ" $_.SamAccountName : $Days_Expiration.days
      }
  } 








   
