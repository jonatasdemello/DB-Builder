IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'GenericIdType')
BEGIN
	CREATE TYPE GenericIdType AS TABLE
	(
		GenericId int NOT NULL
	);
END
GO
