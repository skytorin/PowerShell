$EXP_CSV = "C:\temp\users_expiration_date.csv"
$Global:FIRST_ALERT = 30
$Global:SECOND_ALERT = 5
$Global:From = "email@from"
#$Global:To = "Значение из AD"
$Global:Cc = "email@to_1","email@to_2"
#$Global:Bcc = ""
$Global:SMTPServer = "mail.loc" 
$Global:SubjectRU = "Истечение подписки на техническую поддержку продуктов НЕОЛАНТ Сервис"
$Global:SubjectEN = "Expiration of a subscription to technical support for NEOLANT Service products"


# Функция отправки оповещения кастомерам и копии заинтертесованным лицам на RUS
function SendAlertRU {   
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
			<p>Уважаемый(ая) $GIVENNAME!</p>
			<p>Хотим уведомить Вас, что через <span class="alert">$DAYS_ALERT</span> дней заканчивается срок действия подписки на услуги технической поддержки по следующим продуктам:</p>
			<h3><a href="https://neosphere.neolant.com/display/neoSyn">$PO_1</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/POLYNOM">$PO_2</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/IN">$PO_3</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/InterStorage">$PO_4</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/PAKDD">$PO_5</a></h3>
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
#Send-MailMessage -From $From -to $_.EmailAddress -cc $Cc -Subject $SubjectRU -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different    
#Send-MailMessage -From $From -to $To -cc $Cc -Subject $SubjectRU -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different 
Send-MailMessage -From $From -to $To -Subject $SubjectRU -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different 
} 

# Функция отправки оповещения кастомерам и копии заинтертесованным лицам на ENG
function SendAlertEN {   
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
			<p>Dear $GIVENNAME!</p>
			<p>We would like to notify you that in <span class="alert">$DAYS_ALERT</span> days your technical support subscription for the following products will expire:</p>
			<h3><a href="https://neosphere.neolant.com/display/neoSyn">$PO_1</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/POLYNOM">$PO_2</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/IN">$PO_3</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/InterStorage">$PO_4</a></h3>
			<h3><a href="https://neosphere.neolant.com/display/PAKDD">$PO_5</a></h3>
			<p>Account expiration date and time <span class="alert">$Alert_login</span> on the NEOSPHERA portal: <span class="alert">$Alert_Date_Time_Expiration</span>.</p>
			<p>Technical support includes:
				<ul>
					<li>The possibility of receiving free services License Relocation, License Relocation - unlimited, subject to compliance with the requirements for these services.</li>
					<li>Exchange for new versions of the software - providing new versions of the software through electronic data transfer.</li>
					<li>Software updates - providing patches, fixes via electronic data transfer.</li>
					<li>Access to information about new versions released and new updates with a list of enhancements.</li>
					<li>Possibility to get new developments of "NEOLANT Service" LLC free of charge for trial operation in order to evaluate their functionality for an agreed period of time.</li>
					<li>Providing technical information on product functionality.</li>
					<li>The ability to request a proposal for software changes, including the development of new features and/or component enhancements.</li>
					<li>Getting advice on software products on topics: basic functions, installation, settings, solving problems, upgrading versions.</li>
				</ul>
			</p>
			<p>Channels for providing the service Technical Support:
				<ul>
					<li>
						<b>Main channel</b> - web portal <a href="https://neosphere.neolant.com">https://neosphere.neolant.com</a>.
					</li>
					<li>
						<b>E-mail</b> - <a href="mailto:neosphere@neolant.com">neosphere@neolant.com</a>.
					</li>
				</ul>
			</p>
			<p>--<br>
			Regards,<br>
			NEOSPHERA portal technical support service</p>
		</div>
	</body>
</html>
"@

$Body = $HTML
$Encoding = [System.Text.Encoding]::UTF8
#Send-MailMessage -From $From -to $_.EmailAddress -cc $Cc -Subject $SubjectEN -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different  
#Send-MailMessage -From $From -to $To -cc $Cc -Subject $SubjectEN -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different 
Send-MailMessage -From $From -to $To -Subject $SubjectEN -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Encoding $Encoding #-Attachments $data_different   
} 


# Удаление старого файла CSV
Remove-item $EXP_CSV

# Выгружаем даные по всем пользователям в файл CSV
Get-ADUser -Filter * -properties SamAccountName, GivenName, AccountExpirationDate, EmailAddress, Country |`
 Select Name, SamAccountName, GivenName, EmailAddress, AccountExpirationDate, Country |`
  Export-csv -path $EXP_CSV -Append -Delimiter ';' -Encoding UTF8


# Парсер CSV и групп AD
$Date_Time_Now = Get-Date -Format s
Import-Csv $EXP_CSV -Delimiter ';' | foreach {
  

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
   
         
    # Определяем язык для уведомления пользователя. Принимаем значение RUS если у пользователя атрибут Country пустой или значение ENG, если в атрибуте указана любая страна
    if ( $_.Country )
      {
        $SENDALERT = "SendAlertEN"
        $LANG = "[ENG]"
      }
    else
      {
        $SENDALERT = "SendAlertRU"
        $LANG = "[RUS]"
      }

    # Проверка вхождение пользователя в группы продуктов НЕОЛАНТ 
    $PO_1=""
    $PO_2=""
    $PO_3=""
    $PO_4=""
    $PO_5=""
    
    $USER_CN=Get-ADUser $_.SamAccountName -properties DistinguishedName | select DistinguishedName -expandproperty DistinguishedName
    $UG_1=Get-ADUser -Filter {MemberOf -RecursiveMatch "CN=prod-neosyntez,CN=Users,DC=neo,DC=users"} -SearchBase $USER_CN | select SamAccountName -expandproperty SamAccountName
    $UG_2=Get-ADUser -Filter {MemberOf -RecursiveMatch "CN=prod-polynom,CN=Users,DC=neo,DC=users"} -SearchBase $USER_CN | select SamAccountName -expandproperty SamAccountName
    $UG_3=Get-ADUser -Filter {MemberOf -RecursiveMatch "CN=prod-interbridge,CN=Users,DC=neo,DC=users"} -SearchBase $USER_CN | select SamAccountName -expandproperty SamAccountName
    $UG_4=Get-ADUser -Filter {MemberOf -RecursiveMatch "CN=prod-interstorage,CN=Users,DC=neo,DC=users"} -SearchBase $USER_CN | select SamAccountName -expandproperty SamAccountName
    $UG_5=Get-ADUser -Filter {MemberOf -RecursiveMatch "CN=prod-digital-decommissioning,CN=Users,DC=neo,DC=users"} -SearchBase $USER_CN | select SamAccountName -expandproperty SamAccountName

    if ( $LANG -eq "[RUS]" )
      {
        if ( $UG_1 ) {$PO_1 = 'СУИД НЕОСИНТЕЗ'}
        if ( $UG_2 ) {$PO_2 = 'САПР ПОЛИНОМ'}
        if ( $UG_3 ) {$PO_3 = 'Конвертер инженерных моделей InterBridge / Средство просмотра инженерных моделей InterView'}
        if ( $UG_4 ) {$PO_4 = 'Интеграционное решение InterStorage for SPF'}
        if ( $UG_5 ) {$PO_5 = 'Платформа Digital Decommissioning'}
        # Определяем ИО пользователя. Используем значение атрибута Имя, если атрибут пустой, то подставляем константу
        if ( $_.GivenName )
          {
            $GIVENNAME = $_.GivenName
          }
        else
          {
            $GIVENNAME = "клиент"
          }
      }
    else
      {
        if ( $UG_1 ) {$PO_1 = 'Engineering data management system SUID NEOSYNTES'}
        if ( $UG_2 ) {$PO_2 = 'CAD design system CAD POLYNOM'}
        if ( $UG_3 ) {$PO_3 = 'Engineering model viewer InterView / Engineering model converter InterBridge'}
        if ( $UG_4 ) {$PO_4 = 'Integration solution InterStorage for SPF'}
        if ( $UG_5 ) {$PO_5 = 'Platforms Digital Decommissioning'}
        # Определяем ИО пользователя. Используем значение атрибута Имя, если атрибут пустой, то подставляем константу
        if ( $_.GivenName )
          {
            $GIVENNAME = $_.GivenName
          }
        else
          {
            $GIVENNAME = "client"
          }
      }


    # Обрабатываем оставшиеся дни до истечения, отправляем уведомление на соответствующем языке
    if ( $Days_Expiration.days -eq $FIRST_ALERT )
      {
        Write-Host $LANG "Срок действия УЗ" $_.SamAccountName "закончится через" $FIRST_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
        $DAYS_ALERT = $FIRST_ALERT
        switch( $SENDALERT )
          {    
            'SendAlertEN'
              {
                SendAlertEN
              }
            'SendAlertRU'
              {
                SendAlertRU
              }
          }
      }  
    elseif ( $Days_Expiration.days -eq $SECOND_ALERT )
      {
        Write-Host $LANG "Срок действия УЗ:" $_.SamAccountName "закончится через:" $SECOND_ALERT "дней. Необходимо уведомить пользователя по адресу:" $_.EmailAddress
        $DAYS_ALERT = $SECOND_ALERT
        switch( $SENDALERT )
          {    
            'SendAlertEN'
              {
                SendAlertEN
              }
            'SendAlertRU'
              {
                SendAlertRU
              }
          }
      } 
    else
      {
        Write-Host $LANG "Дней до истечения УЗ" $_.SamAccountName : $Days_Expiration.days
      }
 } 
  









   

