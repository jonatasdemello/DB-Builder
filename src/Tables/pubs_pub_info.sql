SET NOCOUNT ON;

CREATE TABLE [pubs].[pub_info]
(
	[pub_id] [char](4) NOT NULL,
	[logo] [image] NULL,
	[pr_info] [text] NULL,
	CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED ([pub_id] ASC)
)
GO
-- ALTER TABLE [pubs].[pub_info] WITH CHECK ADD FOREIGN KEY([pub_id]) REFERENCES [pubs].[publishers] ([pub_id])
-- GO
