IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'NameValueList')
BEGIN
	CREATE TYPE NameValueList AS TABLE(
	Name VARCHAR(500),
	Value VARCHAR(500)
	)
END

GO