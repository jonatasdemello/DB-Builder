CREATE TABLE [dbo].[UserAccountUserType](
	[UserAccountUserTypeId] [int] IDENTITY(1,1) NOT NULL,
	[UserAccountId] [int] NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[AgreementDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[ModifiedDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_UserAccountUserType] PRIMARY KEY NONCLUSTERED
(
	[UserAccountUserTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserAccountUserType] ADD  CONSTRAINT [DF_UserAccountUserType_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [dbo].[UserAccountUserType] ADD  CONSTRAINT [DF__UserAccountUserType__CreateDate]  DEFAULT (sysdatetime()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[UserAccountUserType] ADD  CONSTRAINT [DF__UserAccountUserType__Modifieddate]  DEFAULT (sysdatetime()) FOR [ModifiedDate]
GO

CREATE UNIQUE CLUSTERED INDEX IX_UserAccountUserType_UserAccountIdUserTypeId ON dbo.UserAccountUserType(UserAccountId, UserTypeId)

CREATE UNIQUE INDEX IX_UserAccountUserType_UserTypeId ON dbo.UserAccountUserType(UserTypeId, UserAccountId) INCLUDE(Active)

GO
