CREATE TABLE dbo.StateProv
(
	StateProvId INTEGER IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	StateProvName VARCHAR(255) NOT NULL,
	StateProvCode CHAR(2) NOT NULL,
	CountryId INTEGER NOT NULL,
	StateProvType INTEGER NULL
)

CREATE UNIQUE INDEX IX_StateProv_StateProvName ON dbo.StateProv(StateProvName)
CREATE UNIQUE INDEX IX_StateProv_StateProvCode ON dbo.StateProv(StateProvCode)
GO
