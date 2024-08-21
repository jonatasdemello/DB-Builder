IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = 'pubs')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA pubs AUTHORIZATION dbo'
END
GO
