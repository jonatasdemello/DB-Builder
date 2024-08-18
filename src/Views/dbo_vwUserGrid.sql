EXEC dbo.ProvisionView 'dbo', 'vwUserGrid'
GO

ALTER VIEW dbo.vwUserGrid
AS

	SELECT
		asp.Id,
		asp.UserName,
		asp.Email,
		asp.EmailConfirmed,
		CMS.UserId,
		CMS.FirstName,
		CMS.LastName,
		CMS.IsActive
	FROM
		dbo.AspNetUsers AS asp
		INNER JOIN dbo.Users AS CMS ON CMS.NormalizedEmail = asp.NormalizedEmail

GO
