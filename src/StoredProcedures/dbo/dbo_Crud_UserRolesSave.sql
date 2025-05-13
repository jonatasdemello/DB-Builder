IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Crud_UserRolesSave') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.Crud_UserRolesSave
GO
CREATE PROCEDURE dbo.Crud_UserRolesSave
(
	@UserId INT,
    @Roles GenericListType READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
    -- GenericListType:
    --      GenericId: 1, 0 (true or false for rule)
    --      Description: RoleId
    DECLARE @UserGuid NVARCHAR (450)

    SELECT @UserGuid = Id FROM vwUserGrid WHERE UserId = @UserId

    IF @UserGuid IS NOT NULL
    BEGIN

        DELETE FROM
            dbo.AspNetUserRoles
        WHERE
            UserId = @UserGuid
            AND RoleId IN (
                SELECT [Description] AS RoleId
                FROM @Roles
                WHERE GenericId = 0)

        INSERT INTO
            dbo.AspNetUserRoles (UserId, RoleId)
        SELECT
            @UserGuid, [Description] AS RoleId
        FROM @Roles t1
        WHERE
            t1.GenericId = 1
            AND t1.[Description] NOT IN (SELECT RoleId FROM dbo.AspNetUserRoles WHERE UserId = @UserGuid )
    END
END
GO
