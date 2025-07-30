EXEC dbo.ProvisionSproc 'Utility', 'DeleteStudentCypress'
GO

ALTER PROCEDURE [Utility].[DeleteStudentCypress]
(
	@UserName VARCHAR(255),
	@EducatorId INTEGER
)
AS

DECLARE @UserAccountId INTEGER
SET @UserAccountId = (SELECT UserAccountId FROM dbo.UserAccount WHERE UserName = @UserName)

DECLARE @PortfolioId INTEGER
SET @PortfolioId = (SELECT PortfolioId FROM Student.StudentProfile WHERE UserAccountId = @UserAccountId)

DELETE FROM audit.LoginHistory WHERE UserAccountId = @UserAccountId

DELETE FROM Student.StudentProfile WHERE UserAccountId = @UserAccountId

DELETE FROM dbo.UserAccountUserType WHERE UserAccountId = @UserAccountId AND UserTypeId = 1

DELETE FROM dbo.UserAccount WHERE UserAccountId = @UserAccountId

IF @PortfolioId IS NOT NULL
BEGIN
	INSERT INTO audit.StudentChangeLog (PortfolioId, EducatorId, FieldName, OldValue, NewValue)
	VALUES (@PortfolioId, @EducatorId, 'Delete', 0, 1)
END