IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'IdList')
BEGIN
	CREATE TYPE IdList AS TABLE (Id INTEGER)
END

GO