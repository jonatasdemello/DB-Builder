CREATE TABLE dbo.UserType
(
	UserTypeId int IDENTITY(1,1) NOT NULL,
	UserTypeName varchar(20) NOT NULL,
	[Description] varchar(1000) NULL,
	CONSTRAINT PK_UserType PRIMARY KEY CLUSTERED (UserTypeId ASC )
)
GO
