SET NOCOUNT ON;

CREATE TABLE [pubs].[titles]
(
	[title_id] [pubs].[tid] NOT NULL,
	[title] [varchar](80) NOT NULL,
	[type] [char](12) NOT NULL,
	[pub_id] [char](4) NULL,
	[price] [money] NULL,
	[advance] [money] NULL,
	[royalty] [int] NULL,
	[ytd_sales] [int] NULL,
	[notes] [varchar](200) NULL,
	[pubdate] [datetime] NOT NULL,
	CONSTRAINT [UPKCL_titleidind] PRIMARY KEY CLUSTERED ([title_id] ASC)
)
GO
CREATE NONCLUSTERED INDEX [titleind] ON [pubs].[titles] ([title] ASC)
GO
ALTER TABLE [pubs].[titles] ADD DEFAULT ('UNDECIDED') FOR [type]
GO
ALTER TABLE [pubs].[titles] ADD DEFAULT (getdate()) FOR [pubdate]
GO
-- ALTER TABLE [pubs].[titles] WITH CHECK ADD FOREIGN KEY([pub_id]) REFERENCES [pubs].[publishers] ([pub_id])
-- GO
