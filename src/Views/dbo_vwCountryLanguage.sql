EXEC dbo.ProvisionView 'dbo', 'vwCountryLanguage'
GO

ALTER VIEW [dbo].[vwCountryLanguage]
AS

	SELECT
		T.TranslationLanguageId,
		T.LanguageCultureName,
		T.LanguageCode,
		T.LanguageName,
		C.CountryId,
		C.CountryName,
		C.CountryCode,
		T.IsActive
	FROM
		dbo.TranslationLanguage T
		INNER JOIN Country C on C.CountryId = T.CountryId
GO
