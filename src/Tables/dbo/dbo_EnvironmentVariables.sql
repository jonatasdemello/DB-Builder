CREATE TABLE dbo.EnvironmentVariables
(
	[Key] VARCHAR(255) NOT NULL,
	[Value] VARCHAR(255) NOT NULL
)
GO
CREATE UNIQUE INDEX IX_EnvironmentVariables_Key ON dbo.EnvironmentVariables([Key])
GO
