SET NOCOUNT ON;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pubs.byroyalty') AND type in (N'P', N'PC'))
    DROP PROCEDURE pubs.byroyalty
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
