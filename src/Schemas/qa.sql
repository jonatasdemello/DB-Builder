IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = 'qa')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA qa AUTHORIZATION dbo'
END
GO
