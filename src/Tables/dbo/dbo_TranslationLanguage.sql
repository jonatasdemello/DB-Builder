CREATE TABLE dbo.TranslationLanguage
(
	TranslationLanguageId INT PRIMARY KEY CLUSTERED NOT NULL,
	LanguageCultureName VARCHAR(255) NOT NULL,
	LanguageCode CHAR(2) NOT NULL,
	LanguageName VARCHAR(255) NOT NULL,
	CountryId INT NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1
)
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_TranslationLanguage_Name ON dbo.TranslationLanguage (LanguageCultureName)
GO
CREATE UNIQUE INDEX IX_TranslationLanguage_CountryId_LanguageName ON dbo.TranslationLanguage(CountryId, LanguageName) INCLUDE (LanguageCultureName)
GO
