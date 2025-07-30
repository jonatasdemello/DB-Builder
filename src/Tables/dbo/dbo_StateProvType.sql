CREATE TABLE dbo.StateProvType
(
	StateProvTypeId INTEGER IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	StateProvTypeName VARCHAR(255) NOT NULL,
	CountryId INTEGER NULL
)
GO
CREATE UNIQUE INDEX IX_StateProv_StateProvType ON dbo.StateProvType(StateProvTypeId)
GO
