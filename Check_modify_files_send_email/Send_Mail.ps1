

====================================================
### https://bezramok-tlt.ru/blog/posts/powershell-otpravka-pochty-s-avtorizaciey-cherez-smtp-server-yandeksa/
#Адрес сервера SMTP для отправки
$serverSmtp = "smtp.mail.ru"
#Порт сервера
$port = 587
#От кого
$From = "nick555@bk.ru"
#Кому
$To = "skytorin@yandex.ru"
#Тема письма
$subject = "Письмо с вложением"
#Логин и пароль от ящики с которого отправляете login@yandex.ru
$user = "nick555@bk.ru"
$pass = "482850@#poiuytrewq"
#Путь до файла
$file = "C:\temp\Files\arhive.zip"
#Создаем два экземпляра класса
$att = New-object Net.Mail.Attachment($file)
$mes = New-Object System.Net.Mail.MailMessage
#Формируем данные для отправки
$mes.From = $From
$mes.To.Add($To)
$mes.Subject = $subject
$mes.IsBodyHTML = $true
$mes.Body = "<h1>Тестовое письмо</h1>"
#Добавляем файл
$mes.Attachments.Add($att)
#Создаем экземпляр класса подключения к SMTP серверу
$smtp = New-Object Net.Mail.SmtpClient($serverSmtp, $port)
#Сервер использует SSL
$smtp.EnableSSL = $true
#Создаем экземпляр класса для авторизации на сервере яндекса
$smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass);
#Отправляем письмо, освобождаем память
$smtp.Send($mes)
$att.Dispose()

====================================================

$EmailFrom = "nick555@bk.ru"
$EmailTo = "skytorin@yandex.ru" 
$Subject = "Test" 
$Body = "Test"
$SMTPServer = "smtp.mail.ru" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.Timeout = 1000
$SMTPClient.EnableSsl = $True
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential('nick555@bk.ru','482850@#poiuytrewq')
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)

=====================================================

$EmailFrom = "skytorin@yandex.ru"
$EmailTo = "nick555@bk.ru" 
$Subject = "Test" 
$Body = "Test"
$SMTPServer = "smtp.yandex.ru" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.Timeout = 1000
$SMTPClient.EnableSsl = $True
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential('skytorin@yandex.ru','rTtrD2B#7vZre')
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)

=====================================================
	