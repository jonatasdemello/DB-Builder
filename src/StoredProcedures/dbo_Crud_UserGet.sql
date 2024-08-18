IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Crud_UserGet') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.Crud_UserGet
GO
CREATE PROCEDURE dbo.Crud_UserGet
(
	@UserId INTEGER
)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
        asp.Id,
        asp.UserName,
        CMS.UserId,
        asp.Email,
        asp.EmailConfirmed,
        CMS.FirstName,
        CMS.LastName,
        CMS.IsActive
    FROM
        dbo.AspNetUsers AS asp
        INNER JOIN dbo.Users AS CMS ON CMS.NormalizedEmail = asp.NormalizedEmail
    WHERE
        CMS.UserId = @UserId

END
GO
