IF EXISTS(SELECT * FROM information_schema.routines
	WHERE routine_type = 'PROCEDURE' AND routine_schema = 'dbo' AND routine_name = 'ProvisionView')
BEGIN
	DROP PROCEDURE dbo.ProvisionView
END
GO

/*************************************************************************************
	dbo.ProvisionView

	Use this procedure to create an empty view that
	can subsequently be altered to include the actual logic.
*************************************************************************************/
CREATE PROCEDURE dbo.ProvisionView
(
	@Schema VARCHAR(255),
	@Name VARCHAR(255)
)
AS
BEGIN
	IF NOT EXISTS(SELECT *
		FROM information_schema.views
		WHERE table_schema = @Schema AND table_name = @Name)
	BEGIN
		DECLARE @SQL NVARCHAR(MAX)
		SET @SQL = 'CREATE VIEW [' + @Schema + '].[' + @Name + '] AS SELECT 1 AS TempCol;'
		EXEC sp_executesql @SQL
	END
END
GO
