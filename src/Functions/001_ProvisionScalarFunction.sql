IF EXISTS(SELECT * FROM information_schema.routines
	WHERE routine_type = 'PROCEDURE' AND routine_schema = 'dbo' AND routine_name = 'ProvisionScalarFunction')
BEGIN
	DROP PROCEDURE dbo.ProvisionScalarFunction
END
GO

/*************************************************************************************
	dbo.ProvisionScalarFunction

	Use this procedure to create an empty scalar function that
	can subsequently be altered to include the actual logic.

	A scalar function is one that returns a single scalar value.

	CREATE FUNCTION func(@arg int) RETURNS INT AS BEGIN... END

*************************************************************************************/
CREATE PROCEDURE dbo.ProvisionScalarFunction
(
	@Schema VARCHAR(255),
	@Name VARCHAR(255)
)
AS
BEGIN
	IF NOT EXISTS(SELECT *
		FROM information_schema.routines
		WHERE routine_schema = @Schema AND routine_name = @Name)
	BEGIN
		DECLARE @SQL NVARCHAR(MAX)
		SET @SQL = 'CREATE FUNCTION [' + @Schema + '].[' + @Name + '](@temp INT) RETURNS INT AS BEGIN RETURN @temp END;'
		EXEC sp_executesql @SQL
	END
END
GO
