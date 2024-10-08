SET NOCOUNT ON;

CREATE TABLE [pubs].[stores]
(
	[stor_id] [char](4) NOT NULL,
	[stor_name] [varchar](40) NULL,
	[stor_address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED ([stor_id] ASC)
)
GO
