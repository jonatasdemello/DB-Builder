SET NOCOUNT ON;
GO

EXEC dbo.ProvisionView 'pubs', 'titleview'
GO

ALTER VIEW [pubs].[titleview]
AS

	select
		title, au_ord, au_lname, price, ytd_sales, pub_id
	from
		pubs.authors, pubs.titles, pubs.titleauthor
	where
		pubs.authors.au_id = pubs.titleauthor.au_id
		AND pubs.titles.title_id = pubs.titleauthor.title_id

GO
