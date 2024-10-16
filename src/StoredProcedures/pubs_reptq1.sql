SET NOCOUNT ON;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pubs.reptq1') AND type in (N'P', N'PC'))
    DROP PROCEDURE pubs.reptq1
GO

CREATE PROCEDURE [pubs].[reptq1]
AS
BEGIN
	select
		case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id,
		avg(price) as avg_price
	from titles
	where price is NOT NULL
	group by pub_id with rollup
	order by pub_id
END
GO
