SET NOCOUNT ON;

CREATE TABLE [pubs].[jobs]
(
	[job_id] [smallint] IDENTITY(1,1) NOT NULL,
	[job_desc] [varchar](50) NOT NULL,
	[min_lvl] [tinyint] NOT NULL,
	[max_lvl] [tinyint] NOT NULL,
	PRIMARY KEY CLUSTERED ([job_id] ASC)
)
GO
ALTER TABLE [pubs].[jobs] ADD DEFAULT ('New Position - title not formalized yet') FOR [job_desc]
GO
ALTER TABLE [pubs].[jobs] WITH CHECK ADD CHECK (([max_lvl]<=(250)))
GO
ALTER TABLE [pubs].[jobs] WITH CHECK ADD CHECK (([min_lvl]>=(10)))
GO
