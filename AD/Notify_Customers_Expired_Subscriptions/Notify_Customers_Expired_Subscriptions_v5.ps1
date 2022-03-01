$EXP_CSV = "C:\temp\users_expiration_date.csv"
$Global:FIRST_ALERT = 30
$Global:SECOND_ALERT = 5
$Global:From = "email@from"
#$Global:To = "Значение из AD"
$Global:Cc = "email@to_1","email@to_2"
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
			.alert {
				color: red;
				font-weight: bold;
			}
			div { 
				width: 60%; /* Ширина */
				margin-left: 20%;
				padding: 20px; /* Поля */
				-moz-box-sizing: border-box; /* Для Firefox */
				-webkit-box-sizing: border-box; /* Для Safari и Chrome */
				box-sizing: border-box; /* Для IE и Opera */
			}
		</style>
	</head>
	<body style="color:#003366" align="justify">
		<div>
			<p>Уважаемый $GIVENNAME!</p>
			<p>Хотим уведомить Вас, что через <span class="alert">$DAYS_ALERT</span> дней заканчивается срок действия подписки на услуги технической поддержки по следующим продуктам:</p>
			<h3><a href="https://neosphere.neolant.com/display/neoSyn">$po_1</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/POLYNOM">$po_2</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/IN">$po_3</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/InterStorage">$po_4</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/PAKDD">$po_5</a></h3>
			<p>Дата и время окончания действия учетной записи <span class="alert">$Alert_login</span> на портале НЕОСФЕРА: <span class="alert">$Alert_Date_Time_Expiration</span>.</p>
			<p>Техническая поддержка включает в себя:
				<ul>
					<li>Возможность бесплатного получения услуг Перемещение лицензии, Перераспределение лицензий, - неограниченно, при соблюдении требований по данным услугам.</li>
					<li>Обмен на новые версии программного обеспечения – предоставление новых версий ПО посредством электронной передачи данных.</li>
					<li>Обновления программного обеспечения – предоставление патчей, фиксов посредством электронной передачи данных.</li>
					<li>Доступ к информации о выпущенных новых версиях и новых обновлениях со списком доработок.</li>
					<li>Возможность бесплатного получения новых разработок ООО «НЕОЛАНТ Сервис» для опытной эксплуатации с целью оценки их функциональных возможностей на оговоренный период времени.</li>
					<li>Предоставление технической информации по функциональности продуктов.</li>
					<li>Возможность обращения с предложением по изменению программного обеспечения, включая разработку новых функций и/или совершенствованию компонентов.</li>
					<li>Получение консультаций по программным продуктам по темам: базовые функции, инсталляция, настройки, решение проблемных ситуаций, обновление версий.</li>
				</ul>
			</p>
			<p>Каналы предоставления услуги Техническая поддержка:
				<ul>
					<li>
						<b>Основной канал</b> - web портал <a href="https://neosphere.neolant.com">https://neosphere.neolant.com</a>.
					</li>
					<li>
						<b>E-mail</b> - <a href="mailto:neosphere@neolant.com">neosphere@neolant.com</a>.
					</li>
				</ul>
			</p>
			<p>--<br>
			С уважением,<br>
			Служба технической поддержки портала НЕОСФЕРА</p>
		</div>
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
    $Alert_login = $_.EmailAddress
    
        
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
  

