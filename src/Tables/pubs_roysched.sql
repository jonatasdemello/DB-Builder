SET NOCOUNT ON;

CREATE TABLE [pubs].[roysched]
(
	[title_id] [pubs].[tid] NOT NULL,
	[lorange] [int] NULL,
	[hirange] [int] NULL,
	[royalty] [int] NULL
)
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [pubs].[roysched] ([title_id] ASC)
GO
-- ALTER TABLE [pubs].[roysched] WITH CHECK ADD FOREIGN KEY([title_id]) REFERENCES [pubs].[titles] ([title_id])
-- GO
