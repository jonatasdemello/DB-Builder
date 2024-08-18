ALTER TABLE dbo.UserAccountUserType
	ADD CONSTRAINT FK_UserAccountUserType_Reference_UserAccount FOREIGN KEY (UserAccountId)
	REFERENCES dbo.UserAccount (UserAccountId)
GO

ALTER TABLE dbo.UserAccountUserType
	ADD CONSTRAINT FK_UserAccountUserType_Reference_UserType FOREIGN KEY (UserTypeId)
	REFERENCES dbo.UserType (UserTypeId)
GO
