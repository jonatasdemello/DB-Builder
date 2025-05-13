IF EXISTS(SELECT * FROM information_schema.routines WHERE routine_type = 'function' AND routine_schema = 'dbo' AND routine_name = 'udf_SentenceCase')
BEGIN
	DROP FUNCTION [dbo].[udf_SentenceCase]
END
GO

CREATE FUNCTION [dbo].[udf_SentenceCase]
(
	@string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
BEGIN
    IF (@string IS NULL)
    BEGIN
        RETURN NULL;
    END

    DECLARE @trimmedString NVARCHAR(MAX) = LTRIM(RTRIM(@string));
    RETURN UPPER(LEFT(@trimmedString, 1)) + LOWER(RIGHT(@trimmedString, LEN(@trimmedString) - 1));
END
GO