IF EXISTS(SELECT * FROM information_schema.routines
	WHERE routine_type = 'PROCEDURE' AND routine_schema = 'dbo' AND routine_name = 'ProvisionSproc')
BEGIN
	DROP PROCEDURE dbo.ProvisionSproc
END
GO

/*************************************************************************************
	dbo.ProvisionSproc

	Use this procedure to provision an empty stored procedure that can subsequently
	have the logic filled in via an ALTER
*************************************************************************************/
CREATE PROCEDURE dbo.ProvisionSproc
(
	@Schema VARCHAR(255),
	@Name VARCHAR(255)
)
AS
BEGIN
	IF NOT EXISTS(SELECT *
		FROM information_schema.routines
		WHERE routine_type = 'PROCEDURE' AND routine_schema = @Schema AND routine_name = @Name)
	BEGIN
		DECLARE @SQL NVARCHAR(MAX)
		SET @SQL = 'CREATE PROCEDURE [' + @Schema + '].[' + @Name + '] AS SELECT 1 AS TempCol;'
		EXEC sp_executesql @SQL
	END
END
GO
