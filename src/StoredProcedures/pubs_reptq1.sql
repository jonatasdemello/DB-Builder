SET NOCOUNT ON;
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
