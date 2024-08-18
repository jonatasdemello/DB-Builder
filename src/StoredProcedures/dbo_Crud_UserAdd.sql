IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Crud_UserAdd') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.Crud_UserAdd
GO
CREATE PROCEDURE dbo.Crud_UserAdd
(
	@Email nvarchar(256),
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
)
AS
BEGIN
	-- cannot insert duplicated username
	IF NOT EXISTS ( SELECT UserId from dbo.Users where NormalizedEmail = @Email )
	BEGIN
		INSERT INTO dbo.Users
			(IsActive, NormalizedEmail , FirstName, LastName, Permission)
		VALUES
			(1, @Email, ISNULL(@FirstName,''), ISNULL(@LastName,''), 0)
	END

    SELECT UserId from dbo.Users where NormalizedEmail = @Email
END
GO
