ALTER TABLE dbo.StateProvText
	ADD CONSTRAINT FK_StateProvText_Reference_StateProvId
	FOREIGN KEY(StateProvId) REFERENCES dbo.StateProv(StateProvId)
GO

ALTER TABLE dbo.StateProvText
	ADD CONSTRAINT FK_StateProvText_Reference_TranslationLanguageId
	FOREIGN KEY(TranslationLanguageId) REFERENCES dbo.TranslationLanguage(TranslationLanguageId)
GO
