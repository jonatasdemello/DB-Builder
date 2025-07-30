IF NOT EXISTS(SELECT * FROM sys.table_types WHERE name = 'IdTextList')
BEGIN
	CREATE TYPE [dbo].[IdTextList] AS TABLE
	(
		[Id] INT,
		[Text] NVARCHAR(MAX)
	)
END
GO