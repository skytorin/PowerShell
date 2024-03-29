# Запрос текущего значения политики
Get-ExecutionPolicy
или
Get-ExecutionPolicy -List

где
- MachinePolicy – действует для всех пользователей компьютера, настраивается через GPO;
- UserPolicy – действует на пользователей компьютера, также настраивается через GPO;
- Process — настройки ExecutionPolicy действует только для текущего сеанса PowerShell.exe (сбрасываются при закрытии процесса);
- CurrentUser – политика ExecutionPolicy применяется только к текущему пользователю (параметр из ветки реестра HKEY_CURRENT_USER);
- LocalMachine – политика для всех пользователей компьютера (параметр из ветки реестра HKEY_LOCAL_MACHINE);



# Задание необходимого значения политики
Set-ExecutionPolicy RemoteSigned

где
- Restricted – запрещен запуск скриптов PowerShell, можно выполнять только интерактивные команды в консоли;
- AllSigned – разрешено выполнять только подписанные PS скрипты с цифровой подписью от доверенного издателя 
(можно подписать скрипт самоподписанным сертификатом и добавить его в доверенные). При запуске недоверенных будет предупреждение
- RemoteSigned – можно запускать локальные PowerShell скрипты без ограничения. 
Можно запускать удаленные PS файлы с цифровой подписью (нельзя запустить PS1 файлы, скачанные из Интернета, запущенные из сетевой папки по UNC пути и т.д.);
- Unrestricted – разрешен запуск всех PowerShell скриптов;
- Bypass – разрешён запуск любых PS файлов (предупреждения не выводятся) – эта политика обычно используется для автоматического 
запуска PS скриптов без вывода каких-либо уведомлений (например при запуске через GPO, SCCM, планировщик и т.д.) 
и не рекомендуется для постоянного использования;
- Default – сброс настроек выполнения скриптов на стандартную;
- Undefined – не задано. Применяется политика Restricted для десктопных ОС и RemoteSigned для серверных.


