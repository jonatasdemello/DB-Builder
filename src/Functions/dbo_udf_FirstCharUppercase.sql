IF EXISTS(SELECT * FROM information_schema.routines WHERE routine_type = 'function' AND routine_schema = 'dbo' AND routine_name = 'udf_FirstCharUppercase')
BEGIN
	DROP FUNCTION [dbo].[udf_FirstCharUppercase]
END
GO

CREATE FUNCTION [dbo].[udf_FirstCharUppercase]
(
	@string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
BEGIN
    IF (@string IS NULL)
    BEGIN
        RETURN NULL;
    END

    RETURN UPPER(LEFT(@string, 1)) + STUFF(@string, 1, 1, '');
END
GO
