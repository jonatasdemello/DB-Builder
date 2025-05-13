CREATE TABLE dbo.Country
(
	CountryId INTEGER IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	CountryName VARCHAR(255),
	CountryCode CHAR(2),
	CountryCode3 CHAR(3)
)
CREATE UNIQUE INDEX IX_Country_CountryName ON dbo.Country(CountryName)
CREATE UNIQUE INDEX IX_CountryCode ON dbo.Country(CountryCode)
GO
