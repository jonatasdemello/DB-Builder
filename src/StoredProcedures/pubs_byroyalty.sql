SET NOCOUNT ON;
GO

CREATE PROCEDURE [pubs].[byroyalty] (
	@percentage int
)
AS
BEGIN
	select au_id from titleauthor
	where titleauthor.royaltyper = @percentage
END
GO
