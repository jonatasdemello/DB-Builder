IF EXISTS(SELECT * FROM information_schema.routines WHERE routine_type = 'function' AND routine_schema = 'dbo' AND routine_name = 'udf_TitleCase')
BEGIN
	DROP FUNCTION [dbo].[udf_TitleCase]
END
GO

CREATE FUNCTION [dbo].[udf_TitleCase]
(
	@string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	IF (@string IS NULL)
	BEGIN
		RETURN NULL;
	END

    DECLARE @index INT = 1;
	DECLARE @char CHAR(1)
	DECLARE @prevChar Char(1)
	DECLARE @outString NVARCHAR(MAX) = '';
    DECLARE @trimmedString NVARCHAR(MAX) = LTRIM(RTRIM(@string));

    WHILE @index <= LEN(@string)
    BEGIN
		SET @char = SUBSTRING(@string, @index, 1)
		SET @prevChar =
		(
			SELECT
			CASE
				WHEN @index = 1 THEN ''
				ELSE SUBSTRING(@string, @index - 1, 1)
			END
		)

		IF @prevChar = ' ' OR @prevChar = '('
		BEGIN
			SET @outString = @outString + UPPER(@char)
		END
		ELSE
		BEGIN
			SET @outString = @outString + LOWER(@char)
		END

    	SET @index = @index + 1
    END

    RETURN @outString
END
GO