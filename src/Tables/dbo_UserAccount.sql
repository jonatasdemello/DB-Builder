CREATE TABLE dbo.UserAccount
(
	UserAccountId int IDENTITY(1,1) NOT NULL,
	UserName varchar(255) NOT NULL,
	Password NVARCHAR(1000) NOT NULL,
	PendingUserName varchar(255) NULL,
	LastLoginDateUTC DATETIME2 NULL,
	MustResetPassword BIT NOT NULL DEFAULT 0,
	PasswordSetDateUTC DATETIME2 NULL,
	CreateTempPasswordDateUTC DATETIME2 NULL,
	CreatedDate DATETIME2 NOT NULL CONSTRAINT DF_UserAccount_CreatedDate DEFAULT (SYSDATETIME()),
	ModifiedDate DATETIME2 NOT NULL CONSTRAINT DF_UserAccount_ModifiedDate DEFAULT (SYSDATETIME()),
	SecurityStamp UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID()
	CONSTRAINT PK_UserAccount PRIMARY KEY CLUSTERED (UserAccountId ASC)
)
GO
CREATE UNIQUE INDEX IX_UserAccount_UserName ON dbo.UserAccount(UserName);
CREATE INDEX IX_UserAccount_PendingUserName ON dbo.UserAccount(PendingUserName);
GO
