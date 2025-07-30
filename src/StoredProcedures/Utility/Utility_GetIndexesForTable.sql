EXEC dbo.ProvisionSproc 'Utility', 'GetIndexesForTable'
GO

ALTER PROCEDURE [Utility].[GetIndexesForTable]
(
	@SchemaName nvarchar(200),
	@TableName nvarchar(200)
)
AS
BEGIN
	-- Getting a List of all Indexes Key References

	SELECT
		i.name AS [IndexName],
		s.name AS [SchemaName],
		o.name As [TableName]
	FROM sys.indexes i
		INNER JOIN sys.objects o ON (o.[object_id] = i.[object_id])
		INNER JOIN sys.schemas s ON (s.[schema_id] = o.[schema_id])
    WHERE
		s.name = @SchemaName
		AND o.name = @TableName

END
GO
