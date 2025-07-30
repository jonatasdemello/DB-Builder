IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'StringList')
BEGIN
	CREATE TYPE StringList AS TABLE(StringValue VARCHAR(500))
END

GO