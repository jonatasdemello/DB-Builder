SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM dbo.TranslationLanguage)
BEGIN
	INSERT INTO dbo.TranslationLanguage (TranslationLanguageId, LanguageCultureName, LanguageCode, LanguageName, CountryId)
	VALUES
	(1, 'en-CA', 'EN', 'CA English', 1  ),
	(2, 'en-US', 'EN', 'US English', 2  ),
	(3, 'fr-CA', 'FR', 'CA French' , 1  ),
	(5, 'es-US', 'ES', 'US Spanish', 2  ),
	(8, 'en-GB', 'EN', 'UK English', 184)
END
GO
