SET NOCOUNT ON;

-- reference:
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addlinkedserver-transact-sql?view=sql-server-ver16

USE [master]
GO
/*
-------------------------------------------------------------------------------------------------------------------------------
-- add linked server
IF NOT EXISTS (SELECT * FROM sys.servers WHERE name = '127.0.0.1')
BEGIN
	-- Create Windows SQL Server linked server
	EXEC master.dbo.sp_addlinkedserver @server = N'127.0.0.1', @srvproduct = N'SQL Server';

	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'127.0.0.1',@useself = N'False',@locallogin = NULL,@rmtuser = N'cms_linked_server_user',@rmtpassword = 'N3bOPJbGjaG1isBn5q9W'

	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'collation compatible', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'data access', @optvalue = N'true'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'dist', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'pub', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'rpc', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'rpc out', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'sub', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'connect timeout', @optvalue = N'0'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'collation name', @optvalue = null
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'lazy schema validation', @optvalue = N'false'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'query timeout', @optvalue = N'0'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'use remote collation', @optvalue = N'true'
	EXEC master.dbo.sp_serveroption @server = N'127.0.0.1', @optname = N'remote proc transaction promotion', @optvalue = N'true'
END
GO

-- test linked server
EXEC sp_testlinkedserver [127.0.0.1];
GO

*/
GO

