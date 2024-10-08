SET NOCOUNT ON;

CREATE TABLE [pubs].[authors]
(
	[au_id] [pubs].[id] NOT NULL,
	[au_lname] [varchar](40) NOT NULL,
	[au_fname] [varchar](20) NOT NULL,
	[phone] [char](12) NOT NULL,
	[address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	[contract] [bit] NOT NULL,
	CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED ([au_id] ASC)
)
GO
CREATE NONCLUSTERED INDEX [aunmind] ON [pubs].[authors]
(
	[au_lname] ASC,
	[au_fname] ASC
)
GO
ALTER TABLE [pubs].[authors] ADD DEFAULT ('UNKNOWN') FOR [phone]
GO
ALTER TABLE [pubs].[authors] WITH CHECK ADD CHECK (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [pubs].[authors] WITH CHECK ADD CHECK (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
