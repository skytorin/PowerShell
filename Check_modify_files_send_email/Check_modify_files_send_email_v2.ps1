$path_file_1 = "C:\temp\Files\TestModifyDate.txt"
$path_file_2 = "C:\temp\Files\TestModifyDate_2.txt"
if (((Get-Date).AddHours(-1) -lt (Get-ChildItem $path_file_1).LastWriteTime) -or ((Get-Date).AddHours(-1) -lt (Get-ChildItem $path_file_2).LastWriteTime))
 {
    Write-Host "New file"
    $EmailFrom = "nick555@bk.ru"
    $EmailTo = "skytorin@yandex.ru" 
    $Subject = "New file" 
    $Body = "New file"
    $SMTPServer = "smtp.mail.ru" 
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
    $SMTPClient.Timeout = 1000
    $SMTPClient.EnableSsl = $True
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential('nick555@bk.ru','482850@#poiuytrewq')
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
 }
  else
 {
  Write-Host "Old all file"
 }