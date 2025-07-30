-- Create the root user.
IF NOT EXISTS(SELECT * FROM syslogins WHERE [loginname] = 'root')
BEGIN
	CREATE LOGIN root WITH PASSWORD = 'MyNameIs!bi11', CHECK_POLICY = OFF;
END
GO

IF NOT EXISTS(SELECT * FROM sysusers WHERE [name] = 'root') AND
   NOT EXISTS(SELECT * FROM sys.databases WHERE name = DB_NAME() AND SUSER_SNAME(owner_sid) = 'root')
BEGIN
	CREATE USER root FOR LOGIN root
	-- Make them db_owner
	EXEC sp_addrolemember 'db_owner', 'root';
END
ELSE
BEGIN
	IF EXISTS(SELECT * FROM sysusers WHERE [name] = 'root')
	BEGIN
		ALTER USER root WITH LOGIN = root
		-- Make them db_owner
		EXEC sp_addrolemember 'db_owner', 'root';
	END
END
GO

-- Make sure default database is master (in case the db gets dropped later and orphans this login)
DECLARE @SQL NVARCHAR(255)
SET @SQL = N'ALTER LOGIN root WITH DEFAULT_DATABASE = master'

EXEC sp_executeSQL @SQL;
GO

------------------------------------------------------------------
-- Create the qa user:
IF NOT EXISTS(SELECT * FROM syslogins WHERE [loginname] = 'qa')
BEGIN
	CREATE LOGIN qa WITH PASSWORD = 'Who.sCall1ng?', CHECK_POLICY = OFF;
END
GO

IF NOT EXISTS(SELECT * FROM sysusers WHERE [name] = 'qa')
BEGIN
	CREATE USER qa FOR LOGIN qa
	GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: dbo TO qa
	GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: qa TO qa
END
ELSE
BEGIN
	GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: dbo TO qa
	GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE ON SCHEMA :: qa TO qa
END
GO

-- Make sure default database is master (in case the db gets dropped later and orphans this login)
DECLARE @SQL NVARCHAR(255)
SET @SQL = N'ALTER LOGIN qa WITH DEFAULT_DATABASE = master'

EXEC sp_executeSQL @SQL;
GO
