EXEC dbo.ProvisionScalarFunction 'dbo', 'udf_InlineMaxDate'
GO

ALTER FUNCTION dbo.udf_InlineMaxDate(@Val1 datetime2, @Val2 datetime2)
RETURNS datetime2
AS
BEGIN

  IF @Val1 > @Val2
    RETURN @val1

  RETURN isnull(@val2,@val1)

END