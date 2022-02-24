$EXP_CSV = "C:\temp\users_expiration_date.csv"
$Global:FIRST_ALERT = 30
$Global:SECOND_ALERT = 5
$Global:From = "neosphera@neolant.com"
#$Global:To = "Значение из AD"
$Global:Cc = "nick555@bk.ru","n.sergeev@neolant.com"
#$Global:Bcc = ""
$Global:SMTPServer = "mail.loc" 
$Global:Subject = "Истечение подписки на техническую поддержку продуктов экосистемы НЕОСИНТЕЗ"

# Функция отправки оповещения кастомерам и в копии заинтертесованные лица
function SendAlert {   
$HTML = @"
<!DOCTYPE html>
<html>
<head>
  <style>
   .colortext_1 {
     color: red;
   }
  </style>
</head>
<body>
<h2 style="color:#4682B4">Уважаемый $GIVENNAME!</h2>
<br>
<p><h3 style="color:#4682B4">Хотим уведомить Вас, что через <span class="colortext_1">$DAYS_ALERT</span> дней заканчивается срок действия подписки на услуги технической поддержки по следующим продуктам:</h3></p> 
<h3><a href="https://neosphere.neolant.com/display/neoSyn">$po_1</a></h3>  
<h3><a href="https://neosphere.neolant.com/display/POLYNOM">$po_2</a></h3>  
<h3><a href="https://neosphere.neolant.com/display/IN">$po_3</a></h3>  
<h3><a href="https://neosphere.neolant.com/display/InterStorage">$po_4</a></h3>  
<h3><a href="https://neosphere.neolant.com/display/PAKDD">$po_5</a></h3>  
<p><h4 style="color:#4682B4">Дата и время окончания действия учетной записи "$Alert_login" на портале НЕОСФЕРА: <span class="colortext_1">$Alert_Date_Time_Expiration</span></h4></p>
<h4 style="color:#4682B4">Для приобретения подписки на  услуги технической поддержки необохдимо обратиться по адресу: info@neolant-srv.ru</h4>
<br>
<br>
<h3 style="color:#4682B4">Техническая поддержка включает в себя:</h3> 
<h4 style="color:#4682B4">• Возможность бесплатного получение услуг по перемещению и перераспределению лицензий;</h4>
<h4 style="color:#4682B4">• Обмен на новые версии программного обеспечения – предоставление новых версий ПО посредством электронной передачи данных;</h4>
<h4 style="color:#4682B4">• Обновления программного обеспечения – предоставление патчей, фиксов посредством электронной передачи данных;</h4>
<h4 style="color:#4682B4">• Рассылку информации о выпущенных новых версиях и новых обновлений со списком доработок;</h4>
<h4 style="color:#4682B4">• Возможность бесплатного получения новых разработок ООО «НЕОЛАНТ Сервис» для опытной эксплуатации с целью оценки их функциональных возможностей на оговоренный период времени;</h4>
<h4 style="color:#4682B4">• Предоставление технической информации по функциональности продуктов;</h4>
<h4 style="color:#4682B4">• Возможность обращения с предложением по изменению программного обеспечения, включая разработку новых функций и/или совершенствованию компонентов;</h4>
<h4 style="color:#4682B4">• Получение консультаций по программным продуктам по темам: базовые функции, инсталляция, настройки, решение проблемных ситуаций, обновление версий.</h4>
<br>
<br>
<h3 style="color:#4682B4">Каналы предоставления услуги Техническая поддержка:</h3>
<h4 style="color:#4682B4">- Web портал http://neosphere.neolant.com - основной канал.</h4>
<h4 style="color:#4682B4">- E-mail neosphere@neolant.com</h4>
<br>
<br>
<h4 style="color:#87CEEB">--</h4>
<h4 style="color:#87CEEB">С уважением,</h4>
<h4 style="color:#87CEEB">Служба технической поддержки портала НЕОСФЕРА</h4>
$Messages
</body>
</html>
"@

$Body = $HTML
$Encoding = [System.Text.Encoding]::UTF8
Send-MailMessage -From $From -to $_.EmailAddress -cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different    
} 


# Удаление старого файла CSV
Remove-item $EXP_CSV

# Выгружаем даные по всем пользователям в файл CSV
Get-ADUser -Filter * -properties SamAccountName, GivenName, AccountExpirationDate, EmailAddress |`
 Select Name, SamAccountName, GivenName, EmailAddress, AccountExpirationDate |`
  Export-csv -path $EXP_CSV -Append -Delimiter ';' -Encoding UTF8


# Парсер CSV и групп AD
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
      }
    

    $Date_Time_Expiration = $_.AccountExpirationDate
    $Alert_Date_Time_Expiration = $_.AccountExpirationDate
    $Alert_login = $_.SamAccountName
    
        
    if ( !$Date_Time_Expiration )
      {
        $Date_Time_Expiration = "01.01.9999 0:00:00"
      }
    $Date_Time_Expiration = Get-Date -Format s $Date_Time_Expiration
    $Date_Time_Now, $Date_Time_Expiration = $Date_Time_Now, $Date_Time_Expiration| ForEach-Object {[DateTime]$_}
    $Days_Expiration = $Date_Time_Expiration - $Date_Time_Now
   
    if ( $_.GivenName )
      {
        $GIVENNAME = $_.GivenName
      }
    else
      {
        $GIVENNAME = "клиент"
      }
    
    if ( $Days_Expiration.days -eq $FIRST_ALERT )
      {
        Write-Host "Срок действия УЗ" $_.SamAccountName "закончится через" $FIRST_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
        $DAYS_ALERT = $FIRST_ALERT
        SendAlert
      }  
    elseif ( $Days_Expiration.days -eq $SECOND_ALERT )
      {
        Write-Host "Срок действия УЗ:" $_.SamAccountName "закончится через:" $SECOND_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
        $DAYS_ALERT = $SECOND_ALERT
        SendAlert
      } 
    else
      {
        Write-Host "Дней до истечения УЗ" $_.SamAccountName : $Days_Expiration.days
      }
 } 
  









   
