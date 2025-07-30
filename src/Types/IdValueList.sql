IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'IdValueList')
BEGIN
	CREATE TYPE [dbo].[IdValueList] AS TABLE
	(
		[Id] INT,
		[Value] INT
	)
END
GO