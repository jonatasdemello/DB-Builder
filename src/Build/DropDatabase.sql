SET NOCOUNT ON;
-- IMPORTANT: destructive behaviour below - use with caution!
-- Drop an existing database, if exists 
USE master

IF EXISTS(SELECT [name] FROM sys.databases WHERE [name] = '$(databasename)')
BEGIN
	ALTER DATABASE [$(databasename)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [$(databasename)]
END
GO
