IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'GenericListType')
BEGIN
	CREATE TYPE GenericListType AS TABLE
	(
		GenericId int NOT NULL,
		Description nvarchar(1000) NOT NULL
	);
END
GO
