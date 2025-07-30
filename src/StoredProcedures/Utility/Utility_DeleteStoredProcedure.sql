EXEC dbo.ProvisionSproc 'Utility', 'DeleteStoredProcedure'
GO

ALTER PROCEDURE [Utility].[DeleteStoredProcedure]
(
	@SchemaName nvarchar(200),
	@RoutineName nvarchar(200)
)
AS
BEGIN
	DECLARE @SQL nvarchar(500)

	IF EXISTS (SELECT * FROM information_schema.routines WHERE routine_type = 'PROCEDURE'
		AND routine_schema = @SchemaName AND routine_name = @RoutineName
	)
	BEGIN
		SELECT @SQL = 'DROP PROCEDURE ['+ @SchemaName +'].['+ @RoutineName +'] ';
		EXEC(@SQL);
	END
END
GO
