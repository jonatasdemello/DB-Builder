EXEC dbo.ProvisionSproc 'Utility', 'ExampleProcedureWithoutParameters'
GO

ALTER PROCEDURE [Utility].[ExampleProcedureWithoutParameters]
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @TimestampUTC DATETIME2 = GETUTCDATE()
    DECLARE @RandomInteger INT = CONVERT(INT, RAND() * 100) -- Between 0 and 100

    SELECT CONVERT(NVARCHAR(50), 'Example') AS [Text]
        , @RandomInteger AS [Integer]
        , @TimestampUTC AS [TimestampUTC]
        , CONVERT(DATE, @TimestampUTC) AS [DateUTC]
        , CONVERT(TIME, @TimestampUTC) AS [TimeUTC]
END
GO

