SET NOCOUNT ON;

CREATE TABLE [pubs].[discounts]
(
	[discounttype] [varchar](40) NOT NULL,
	[stor_id] [char](4) NULL,
	[lowqty] [smallint] NULL,
	[highqty] [smallint] NULL,
	[discount] [decimal](4, 2) NOT NULL
)
GO
-- ALTER TABLE [pubs].[discounts] WITH CHECK ADD FOREIGN KEY([stor_id]) REFERENCES [pubs].[stores] ([stor_id])
-- GO
