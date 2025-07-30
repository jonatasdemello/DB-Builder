EXEC dbo.ProvisionView 'dbo', 'vwStateProv'
GO

ALTER VIEW [dbo].[vwStateProv]
AS

	SELECT
		sp.StateProvId,
		sp.CountryId,
		spt.TranslationLanguageId,
		spt.StateProvName,
		sp.StateProvCode,
		sp.StateProvType
	FROM
		[dbo].[StateProv] sp
		JOIN [dbo].[StateProvText] spt on spt.StateProvId = sp.StateProvId

GO
