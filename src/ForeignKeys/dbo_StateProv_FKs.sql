ALTER TABLE dbo.StateProv
	ADD CONSTRAINT [FK_StateProv_Reference_CountryId]
	FOREIGN KEY(CountryId) REFERENCES dbo.Country (CountryId)
GO
