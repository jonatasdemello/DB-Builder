EXEC dbo.ProvisionScalarFunction 'dbo', 'udf_InlineMinDate'
GO

ALTER FUNCTION dbo.udf_InlineMinDate(@Val1 datetime2, @Val2 datetime2)
RETURNS datetime2
AS
BEGIN

  IF @Val1 < @Val2
    RETURN @Val1

  RETURN isnull(@Val2,@Val1)

END