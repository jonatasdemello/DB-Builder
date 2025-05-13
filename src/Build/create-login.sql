SET NOCOUNT ON;

USE [master]
GO

-- add login if not there
IF NOT EXISTS(SELECT * FROM master.sys.sql_logins WHERE [NAME] = 'admin')
BEGIN
	CREATE LOGIN [admin] WITH 
		PASSWORD=N'P@ssw0rd', 
		DEFAULT_DATABASE=[master], 
		DEFAULT_LANGUAGE=[us_english], 
		CHECK_EXPIRATION=OFF, 
		CHECK_POLICY=OFF;

	ALTER LOGIN [admin] ENABLE;
END
GO

-- add permissions because a newly created login 
-- only has permissions granted to the public role.
IF NOT EXISTS (
	SELECT
		roles.principal_id AS RolePrincipalID
		,roles.name AS RolePrincipalName
		,server_role_members.member_principal_id AS MemberPrincipalID
		,members.name AS MemberPrincipalName
	FROM sys.server_role_members AS server_role_members
	INNER JOIN sys.server_principals AS roles ON server_role_members.role_principal_id = roles.principal_id
	INNER JOIN sys.server_principals AS members ON server_role_members.member_principal_id = members.principal_id  
	where members.name = 'admin'
)
BEGIN 
	ALTER SERVER ROLE [sysadmin] ADD MEMBER [admin];
	ALTER SERVER ROLE [securityadmin] ADD MEMBER [admin];
	ALTER SERVER ROLE [serveradmin] ADD MEMBER [admin];
	ALTER SERVER ROLE [setupadmin] ADD MEMBER [admin];
	ALTER SERVER ROLE [processadmin] ADD MEMBER [admin];
	ALTER SERVER ROLE [diskadmin] ADD MEMBER [admin];
	ALTER SERVER ROLE [dbcreator] ADD MEMBER [admin];
END
GO
