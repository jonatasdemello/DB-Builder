EXEC dbo.ProvisionSproc 'Utility', 'ExampleProcedureWithParameters'
GO

ALTER PROCEDURE [Utility].[ExampleProcedureWithParameters]
(
    @Integer INT,
    @Text NVARCHAR(50) = 'Example',
    @TimestampUTC DATETIME2 = NULL
)
AS
BEGIN
    SET NOCOUNT ON

    IF (@TimestampUTC IS NULL)
    BEGIN
        SET @TimestampUTC = GETUTCDATE()
    END

    SELECT CONVERT(NVARCHAR(50), @Text) AS [Text]
        , @Integer AS [Integer]
        , @TimestampUTC AS [TimestampUTC]
        , CONVERT(DATE, @TimestampUTC) AS [DateUTC]
        , CONVERT(TIME, @TimestampUTC) AS [TimeUTC]
END
GO

