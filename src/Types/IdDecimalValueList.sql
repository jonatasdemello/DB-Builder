IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'IdDecimalValueList')
BEGIN
	CREATE TYPE [dbo].[IdDecimalValueList] AS TABLE
	(
		[Id] INT,
		[Value] NUMERIC(17, 5)
	)
END
GO
