$path_file_1 = "C:\temp\Files\TestModifyDate.txt"
$path_file_2 = "C:\temp\Files\TestModifyDate_2.txt"
if ((Get-Date).AddHours(-1) -lt (Get-ChildItem $path_file_1).LastWriteTime)
 {
    Write-Host "New file 1"
 }
 elseif ((Get-Date).AddHours(-1) -lt (Get-ChildItem $path_file_2).LastWriteTime)
 {
    Write-Host "New file 2"
 }
 
 else
 {
  Write-Host "Old all file"
 }


### https://bezramok-tlt.ru/blog/posts/powershell-otpravka-pochty-s-avtorizaciey-cherez-smtp-server-yandeksa/
#Адрес сервера SMTP для отправки
$serverSmtp = "smtp.yandex.ru"
#Порт сервера
$port = 587
#От кого
$From = "login@yandex.ru"
#Кому
$To = "myMail@mail.ru"
#Тема письма
$subject = "Письмо с вложением"
#Логин и пароль от ящики с которого отправляете login@yandex.ru
$user = "login"
$pass = "12345678"
#Путь до файла
21
$file = "C:\arhive.zip"
#Создаем два экземпляра класса
$att = New-object Net.Mail.Attachment($file)
$mes = New-Object System.Net.Mail.MailMessage
#Формируем данные для отправки
$mes.From = $from
$mes.To.Add($to)
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

