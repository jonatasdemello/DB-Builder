SET NOCOUNT ON;

USE [master]
GO

-- Only update settings if they are not set yet

IF EXISTS (SELECT [value] FROM sys.configurations WHERE [name] = N'show advanced options' and [value] = 0)
BEGIN
	EXEC sp_configure 'show advanced options', 1;
	RECONFIGURE;
END
GO

-- Note: this is not supported on Microsoft Azure SQL Edge
IF NOT EXISTS (SELECT 1 WHERE @@VERSION like '%edge%')
BEGIN
	IF EXISTS (SELECT [value] FROM sys.configurations WHERE [name] = N'clr enabled' and [value] = 0)
	BEGIN
		EXEC sp_configure 'clr enabled', 1;
		RECONFIGURE;
	END
END

-- CRL requires this setting to be on (Azure/Linux)
IF EXISTS (SELECT [value] FROM sys.configurations WHERE [name] = N'clr strict security' and [value] = 1)
BEGIN
	EXEC sp_configure 'clr strict security', 0;
	RECONFIGURE;
END
GO

-------------------------------------------------------------------------------------------------------------------------------
-- If the database already exists,
-- we need to drop any active user connections
-- and then we can drop the database itself.
IF EXISTS(SELECT [name] FROM sys.databases WHERE [name] = '$(databasename)')
BEGIN
	ALTER DATABASE $(databasename) SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE $(databasename)
END
GO

-- Create database in the default file locations.
IF NOT EXISTS(SELECT [name] FROM sys.databases WHERE [name] = '$(databasename)')
BEGIN
	CREATE DATABASE $(databasename)
END
GO

-- switch to the new database
USE [$(databasename)]
GO

-------------------------------------------------------------------------------------------------------------------------------
-- change some DB specific settings
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	EXEC [dbo].[sp_fulltext_database] @action = 'enable'
END
GO

-- Change DB owner to 'sa'
IF NOT EXISTS (SELECT [name] FROM master.sys.databases
	where [name] = '$(databasename)' and suser_sname( owner_sid ) != 'sa')
BEGIN
	EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false
END
GO

-- list of all SQL Server settings
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-ver16
-- Only the ones below are different from the default database settings (and also work on Azure and Linux):

IF EXISTS (select is_quoted_identifier_on from sys.databases where name = '$(databasename)' AND is_quoted_identifier_on = 0)
BEGIN
	ALTER DATABASE [$(databasename)] SET QUOTED_IDENTIFIER ON
END
GO

IF EXISTS (select snapshot_isolation_state from sys.databases where name = '$(databasename)' AND snapshot_isolation_state = 0)
BEGIN
	ALTER DATABASE [$(databasename)] SET ALLOW_SNAPSHOT_ISOLATION ON
END
GO

IF EXISTS (select is_read_committed_snapshot_on from sys.databases where name = '$(databasename)' AND is_read_committed_snapshot_on = 0)
BEGIN
	ALTER DATABASE [$(databasename)] SET READ_COMMITTED_SNAPSHOT ON
END
GO

-- CRL requires this setting to be on (only on Windows SQL Server)
IF EXISTS (SELECT 'Windows' WHERE @@Version LIKE '%windows%')
BEGIN
	IF EXISTS (select is_trustworthy_on from sys.databases where name = '$(databasename)' AND is_trustworthy_on = 0)
		ALTER DATABASE [$(databasename)] SET TRUSTWORTHY ON
END
GO
