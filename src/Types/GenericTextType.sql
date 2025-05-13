IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'GenericTextType')
BEGIN
	CREATE TYPE GenericTextType AS TABLE
    (
        GenericId INT,
        TranslationLanguageId INT,
        GenericText NVARCHAR(MAX)
    );
END
GO
