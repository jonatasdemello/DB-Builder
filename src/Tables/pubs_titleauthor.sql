SET NOCOUNT ON;

CREATE TABLE [pubs].[titleauthor]
(
	[au_id] [pubs].[id] NOT NULL,
	[title_id] [pubs].[tid] NOT NULL,
	[au_ord] [tinyint] NULL,
	[royaltyper] [int] NULL,
	CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED
(
	[au_id] ASC,
	[title_id] ASC
)
)
GO
CREATE NONCLUSTERED INDEX [auidind] ON [pubs].[titleauthor] ([au_id] ASC)
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [pubs].[titleauthor] ([title_id] ASC)
GO
-- ALTER TABLE [pubs].[titleauthor] WITH CHECK ADD FOREIGN KEY([au_id]) REFERENCES [pubs].[authors] ([au_id])
-- GO
-- ALTER TABLE [pubs].[titleauthor] WITH CHECK ADD FOREIGN KEY([title_id]) REFERENCES [pubs].[titles] ([title_id])
-- GO
