SET NOCOUNT ON;

ALTER TABLE [pubs].[discounts] WITH CHECK ADD FOREIGN KEY([stor_id]) REFERENCES [pubs].[stores] ([stor_id])
GO
ALTER TABLE [pubs].[employee] WITH CHECK ADD FOREIGN KEY([job_id]) REFERENCES [pubs].[jobs] ([job_id])
GO
ALTER TABLE [pubs].[employee] WITH CHECK ADD FOREIGN KEY([pub_id]) REFERENCES [pubs].[publishers] ([pub_id])
GO
ALTER TABLE [pubs].[pub_info] WITH CHECK ADD FOREIGN KEY([pub_id]) REFERENCES [pubs].[publishers] ([pub_id])
GO
ALTER TABLE [pubs].[roysched] WITH CHECK ADD FOREIGN KEY([title_id]) REFERENCES [pubs].[titles] ([title_id])
GO
ALTER TABLE [pubs].[titleauthor] WITH CHECK ADD FOREIGN KEY([au_id]) REFERENCES [pubs].[authors] ([au_id])
GO
ALTER TABLE [pubs].[titleauthor] WITH CHECK ADD FOREIGN KEY([title_id]) REFERENCES [pubs].[titles] ([title_id])
GO
ALTER TABLE [pubs].[titles] WITH CHECK ADD FOREIGN KEY([pub_id]) REFERENCES [pubs].[publishers] ([pub_id])
GO
ALTER TABLE [pubs].[sales] WITH CHECK ADD FOREIGN KEY([stor_id]) REFERENCES [pubs].[stores] ([stor_id])
GO
ALTER TABLE [pubs].[sales] WITH CHECK ADD FOREIGN KEY([title_id]) REFERENCES [pubs].[titles] ([title_id])
GO
