-- This table will contain extra user information
-- not available in dbo.AspNetUsers

CREATE TABLE dbo.Users
(
	UserId int IDENTITY(1,1) NOT NULL,
	IsActive bit NOT NULL,
	NormalizedEmail varchar(256) NOT NULL, -- link to dbo.AspNetUsers.NormalizedEmail
	FirstName nvarchar (50) NOT NULL,
	LastName nvarchar (50) NOT NULL,
	Permission INT, -- old permission level, here for compatibility only
	PRIMARY KEY CLUSTERED (UserId ASC)
)
GO
CREATE UNIQUE INDEX IX_UQ_Users_NormalizedEmail_unique ON dbo.Users(NormalizedEmail)
GO
