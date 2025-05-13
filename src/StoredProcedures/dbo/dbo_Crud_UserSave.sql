IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Crud_UserSave') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.Crud_UserSave
GO
CREATE PROCEDURE dbo.Crud_UserSave
(
	@UserId INT,
	@IsActive INT,
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE
		dbo.Users
	SET
		IsActive = @IsActive,
		FirstName = ISNULL(@FirstName,''),
		LastName = ISNULL(@LastName,'')
	 WHERE
        UserId = @UserId;
END
GO
