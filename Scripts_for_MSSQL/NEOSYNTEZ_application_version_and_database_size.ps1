# Получить версию приложения НЕОСИНТЕЗ и размер всех БД
Invoke-Sqlcmd -Query "
use
 [master]
 go
 if
 object_id('tempdb.dbo.#database') is not null
      
drop TABLE #database
 go
 create
 TABLE #database(name sysname, version nvarchar(max), logsize nvarchar(64))
 go
 set
 nocount on
  exec
 master..sp_MSForeachdb '
    use [?]
    declare @xsize int
    select top 1 @xsize=sum([size])*8/1024 from .[sys].[database_files]
    if object_id(''GetVersion'', ''FN'') is not null
    begin
        insert into #database(name, version, logsize) values (''?'', dbo.GetVersion(), STR(@xsize)+'' MB'')
    end
'
 select
 *
 from
 #database
 order
 by 1
 
if
 object_id('tempdb.dbo.#database') is not null
      
drop TABLE #database
 go" -ServerInstance "IOSERVER-SQL3"