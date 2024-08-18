CREATE TABLE dbo.Application
(
	ApplicationId INT NOT NULL IDENTITY(1,1),
	ApplicationName VARCHAR(255) NOT NULL,
	CONSTRAINT [PK_ApplicationId] PRIMARY KEY CLUSTERED ([ApplicationId] ASC)
)
GO
