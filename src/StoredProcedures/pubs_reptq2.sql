SET NOCOUNT ON;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pubs.reptq2') AND type in (N'P', N'PC'))
    DROP PROCEDURE pubs.reptq2
GO

CREATE PROCEDURE [pubs].[reptq2]
AS
BEGIN
	select
		case when grouping(type) = 1 then 'ALL' else type end as type,
		case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id,
		avg(ytd_sales) as avg_ytd_sales
	from titles
	where pub_id is NOT NULL
	group by pub_id, type with rollup
END
GO
