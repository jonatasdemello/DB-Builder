IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Crud_UserRolesGet') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.Crud_UserRolesGet
GO
CREATE PROCEDURE dbo.Crud_UserRolesGet
(
	@UserId INTEGER
)
AS
BEGIN
	SET NOCOUNT ON;

    WITH CTE_SOURCE AS
    (
    SELECT
        u.UserId,
        nu.NormalizedEmail,
        nr.Id as RoleId,
        nr.Name as RoleName
    FROM
        dbo.Users u
        LEFT JOIN dbo.AspNetUsers nu on u.NormalizedEmail = nu.NormalizedEmail
        LEFT JOIN dbo.AspNetUserRoles nur on nur.UserId = nu.Id
        LEFT JOIN dbo.AspNetRoles nr on nur.RoleId = nr.Id
    WHERE
        U.UserId = @UserId
    )
    SELECT
        nr.Id as RoleId,
        nr.Name as RoleName,
        c.UserId as Selected
    FROM
        dbo.AspNetRoles nr
        LEFT JOIN CTE_SOURCE c on nr.Id = c.RoleId

END
GO
