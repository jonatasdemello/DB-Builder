IF NOT EXISTS(SELECT * FROM sys.schemas WHERE [name] = 'Utility')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA Utility AUTHORIZATION dbo'
END
GO
