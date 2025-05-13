IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Crud_UserRoleAdd') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.Crud_UserRoleAdd
GO
CREATE PROCEDURE dbo.Crud_UserRoleAdd
(
	@UserId nvarchar(256), -- GUID
    @RoleName nvarchar(256)
)
AS
BEGIN
    IF NOT EXISTS (SELECT *
        FROM dbo.AspNetUserRoles ur
        INNER JOIN dbo.AspNetRoles r on r.Id = ur.RoleId
        WHERE r.Name = @RoleName AND ur.UserId = @UserId)
    BEGIN

        INSERT INTO dbo.AspNetUserRoles (UserId, RoleId)

        SELECT
            @UserId AS UserId,
            r.Id as RoleId
        FROM
            dbo.AspNetRoles r
        WHERE
            r.Name = @RoleName
    END
END
GO
