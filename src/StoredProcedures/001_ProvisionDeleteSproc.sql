IF EXISTS(SELECT * FROM information_schema.routines
	WHERE routine_type = 'PROCEDURE' AND routine_schema = 'dbo' AND routine_name = 'ProvisionDeleteSproc')
BEGIN
	DROP PROCEDURE dbo.ProvisionDeleteSproc
END
GO

/*************************************************************************************
	dbo.ProvisionDeleteSproc

	Use this procedure to delete an existing stored procedure

*************************************************************************************/
CREATE PROCEDURE dbo.ProvisionDeleteSproc
(
	@Schema VARCHAR(255),
	@Name VARCHAR(255)
)
AS

IF EXISTS(SELECT * FROM information_schema.routines
	WHERE routine_type = 'PROCEDURE' AND routine_schema = @Schema AND routine_name = @Name)
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	SET @SQL = 'DROP PROCEDURE '+ @Schema +'.'+ @Name + ';'
	EXEC sp_executesql @SQL
END
GO

