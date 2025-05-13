IF EXISTS(SELECT * FROM information_schema.routines
	WHERE routine_type = 'PROCEDURE' AND routine_schema = 'dbo' AND routine_name = 'ProvisionTableFunction')
BEGIN
	DROP PROCEDURE dbo.ProvisionTableFunction
END
GO

/*************************************************************************************
	dbo.ProvisionTableFunction

	Use this procedure to create an empty table-valued function that
	can subsequently be altered to include the actual logic.

	A table-valued function is one that returns a TABLE type:

	CREATE FUNCTION func(@arg int) RETURNS @Table TABLE(col INT) AS BEGIN... END

*************************************************************************************/
CREATE PROCEDURE dbo.ProvisionTableFunction
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
		SET @SQL = 'CREATE FUNCTION [' + @Schema + '].[' + @Name + '](@temp INT) RETURNS @TempTable TABLE(TempId INTEGER) AS BEGIN RETURN END;'
		EXEC sp_executesql @SQL
	END
END
GO
