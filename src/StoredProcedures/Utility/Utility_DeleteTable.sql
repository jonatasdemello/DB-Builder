EXEC dbo.ProvisionSproc 'Utility', 'DeleteTable'
GO

ALTER PROCEDURE [Utility].[DeleteTable]
(
	@SchemaName nvarchar(200),
	@TableName nvarchar(200)
)
AS
BEGIN
	DECLARE @SQL nvarchar(500)

	IF EXISTS (SELECT * FROM information_schema.tables
		WHERE table_schema = @SchemaName
		AND table_name = @TableName
	)
	BEGIN
		SELECT @SQL = 'DROP TABLE ['+ @SchemaName +'].['+ @TableName +'] ';
		EXEC(@SQL);
	END
END
GO
