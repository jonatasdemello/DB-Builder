SET NOCOUNT ON;

CREATE TABLE [pubs].[sales]
(
	[stor_id] [char](4) NOT NULL,
	[ord_num] [varchar](20) NOT NULL,
	[ord_date] [datetime] NOT NULL,
	[qty] [smallint] NOT NULL,
	[payterms] [varchar](12) NOT NULL,
	[title_id] [pubs].[tid] NOT NULL,
	CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED
(
	[stor_id] ASC,
	[ord_num] ASC,
	[title_id] ASC
)
)
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [pubs].[sales] ([title_id] ASC)
GO
-- ALTER TABLE [pubs].[sales] WITH CHECK ADD FOREIGN KEY([stor_id]) REFERENCES [pubs].[stores] ([stor_id])
-- GO
-- ALTER TABLE [pubs].[sales] WITH CHECK ADD FOREIGN KEY([title_id]) REFERENCES [pubs].[titles] ([title_id])
-- GO
