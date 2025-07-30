SET NOCOUNT ON;

-- Default password for all users: P@ssw0rd!
-- if you are testing locally
-- use the emails below to log in

SET IDENTITY_INSERT dbo.Users ON;

INSERT INTO dbo.Users
    (UserId, IsActive, Permission, FirstName, LastName, NormalizedEmail)
VALUES
    (1, 1, 0, 'Administrator', '', 'ADMINISTRATOR@GMAIL.COM'),
    (2, 1, 0, 'Freelancer'   , '', 'FREELANCER@GMAIL.COM'),
    (3, 1, 0, 'Restricted'   , '', 'RESTRICTED@GMAIL.COM'),
    (4, 1, 0, 'Content'      , '', 'CONTENT@GMAIL.COM'),
    (5, 1, 0, 'Employee'     , '', 'EMPLOYEE@GMAIL.COM')

SET IDENTITY_INSERT dbo.Users OFF;
GO

-- insert new roles
INSERT INTO dbo.AspNetRoles
    (Id, [Name], NormalizedName, ConcurrencyStamp)
VALUES
    ('c8d1df56-188d-400e-8e5d-d6288f4ab896', 'administrator', 'ADMINISTRATOR', 'ed0535cf-098c-4e7a-a939-94c31a641255'),
    ('2fb4ea78-8701-4392-a6a4-30c618a39472', 'freelancer'   , 'FREELANCER'   , '5dd0d22d-bd45-4297-a55a-c597b9da5a68'),
    ('6c2b93a8-82a3-4544-b73a-34861a0547f2', 'restricted'   , 'RESTRICTED'   , 'eff2cd14-a089-4388-b342-ca8b2a75335a'),
    ('76fb5613-338b-4589-bee0-82c758ad7d35', 'content'      , 'CONTENT'      , '2d49c0cf-d5f5-4729-866e-f5e448c09e3d'),
    ('81499c72-87f3-4cf3-97e7-d00a3c6b7eca', 'employee'     , 'EMPLOYEE'     , '86ec75fc-3851-48d9-93a8-75fd49a3cfd4')
;

GO

-- insert new users
DECLARE @PasswordHash NVARCHAR (MAX) = N'AQAAAAEAACcQAAAAEKyq6ve2AoxH25f3GK2ABW7Z4y/T5zPWf04xNxHkmzIOln47xJvHaTa5K5Bm9hTWpg=='
DECLARE @SecurityStamp NVARCHAR (MAX) = N'2NNKRG3HXHTAWOA2YR4IMKAINL4LMGLS'
DECLARE @ConcurrencyStamp NVARCHAR (MAX) = N'4d58432c-b660-43c1-b54a-b6ac4614cb01'

INSERT INTO dbo.AspNetUsers
    (Id, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnd, LockoutEnabled, AccessFailedCount)
VALUES
    ('5f5f3bab-f44e-4991-99ef-751cd464fa3e', 'administrator@gmail.com', 'ADMINISTRATOR@GMAIL.COM', 'administrator@gmail.com', 'ADMINISTRATOR@GMAIL.COM', 1 , @PasswordHash, @SecurityStamp, @ConcurrencyStamp, NULL, 0, 0, NULL, 0, 0),
    ('e9721bff-db11-4cfb-81e4-f36abca236f0', 'freelancer@gmail.com'   , 'FREELANCER@GMAIL.COM'   , 'freelancer@gmail.com'   , 'FREELANCER@GMAIL.COM'   , 1 , @PasswordHash, @SecurityStamp, @ConcurrencyStamp, NULL, 0, 0, NULL, 0, 0),
    ('1e37718b-3661-407d-a355-3886f5dc01f1', 'restricted@gmail.com'   , 'RESTRICTED@GMAIL.COM'   , 'restricted@gmail.com'   , 'RESTRICTED@GMAIL.COM'   , 1 , @PasswordHash, @SecurityStamp, @ConcurrencyStamp, NULL, 0, 0, NULL, 0, 0),
    ('393dcbf8-d073-434c-8791-8dc478a14899', 'content@gmail.com'      , 'CONTENT@GMAIL.COM'      , 'content@gmail.com'      , 'CONTENT@GMAIL.COM'      , 1 , @PasswordHash, @SecurityStamp, @ConcurrencyStamp, NULL, 0, 0, NULL, 0, 0),
    ('5c4ad5b7-d082-463a-8554-9ba8cf2a2362', 'employee@gmail.com'     , 'EMPLOYEE@GMAIL.COM'     , 'employee@gmail.com'     , 'EMPLOYEE@GMAIL.COM'     , 1 , @PasswordHash, @SecurityStamp, @ConcurrencyStamp, NULL, 0, 0, NULL, 0, 0)
;
GO

-- insert new user-roles
INSERT INTO dbo.AspNetUserRoles (UserId, RoleId)
VALUES
    (N'5f5f3bab-f44e-4991-99ef-751cd464fa3e', N'2fb4ea78-8701-4392-a6a4-30c618a39472'),
    (N'e9721bff-db11-4cfb-81e4-f36abca236f0', N'2fb4ea78-8701-4392-a6a4-30c618a39472'),
    (N'393dcbf8-d073-434c-8791-8dc478a14899', N'76fb5613-338b-4589-bee0-82c758ad7d35'),
    (N'5f5f3bab-f44e-4991-99ef-751cd464fa3e', N'76fb5613-338b-4589-bee0-82c758ad7d35'),
    (N'5c4ad5b7-d082-463a-8554-9ba8cf2a2362', N'81499c72-87f3-4cf3-97e7-d00a3c6b7eca'),
    (N'5f5f3bab-f44e-4991-99ef-751cd464fa3e', N'81499c72-87f3-4cf3-97e7-d00a3c6b7eca'),
    (N'5f5f3bab-f44e-4991-99ef-751cd464fa3e', N'c8d1df56-188d-400e-8e5d-d6288f4ab896')
;
GO
