SET NOCOUNT ON;
-- Setup synonyms for other Database

-- TranslationLanguage
-- IF NOT EXISTS(SELECT * FROM sys.synonyms WHERE SCHEMA_NAME(schema_id) = 'datamerging' AND [name] = 'TranslationLanguage')
-- BEGIN
	 -- CREATE SYNONYM [datamerging].[TranslationLanguage] FOR [CMS].[dbo].[TranslationLanguage]
-- END
-- GO
