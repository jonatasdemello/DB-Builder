CREATE TABLE dbo.StateProvText
(
	StateProvTextId INTEGER IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	StateProvId INTEGER NOT NULL,
	TranslationLanguageId INTEGER NOT NULL,
	StateProvName NVARCHAR(255) NOT NULL,
	CountryId INTEGER NOT NULL
)
GO
CREATE UNIQUE INDEX IX_StateProvId_TranslationLanguageId ON dbo.StateProvText(StateProvId,TranslationLanguageId)
GO
