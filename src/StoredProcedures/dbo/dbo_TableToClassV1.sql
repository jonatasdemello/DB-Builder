IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TableToClassV1]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[TableToClassV1]
GO
CREATE PROCEDURE [dbo].[TableToClassV1]
(
	@TName NVARCHAR(500)
)
AS
-- use this for really big tables (too many columns)
BEGIN
	SET NOCOUNT ON;

	-- sysname = nvarchar(128) NOT NULL
	declare @TableName nvarchar(255) = @TName;

	with CTE_columns AS
	(
	select
		replace(col.name, ' ', '_') ColumnName,
		column_id ColumnId,
		typ.name as DBType,
		case typ.name
			when 'bigint' then 'long'
			when 'binary' then 'byte[]'
			when 'bit' then 'bool'
			when 'char' then 'string'
			when 'date' then 'DateTime'
			when 'datetime' then 'DateTime'
			when 'datetime2' then 'DateTime'
			when 'datetimeoffset' then 'DateTimeOffset'
			when 'decimal' then 'decimal'
			when 'float' then 'float'
			when 'image' then 'byte[]'
			when 'int' then 'int'
			when 'money' then 'decimal'
			when 'nchar' then 'string'
			when 'ntext' then 'string'
			when 'numeric' then 'decimal'
			when 'nvarchar' then 'string'
			when 'real' then 'double'
			when 'smalldatetime' then 'DateTime'
			when 'smallint' then 'short'
			when 'smallmoney' then 'decimal'
			when 'text' then 'string'
			when 'time' then 'TimeSpan'
			when 'timestamp' then 'DateTime'
			when 'tinyint' then 'byte'
			when 'uniqueidentifier' then 'Guid'
			when 'varbinary' then 'byte[]'
			when 'varchar' then 'string'
			else 'UNKNOWN_' + typ.name
		end ColumnType,
		col.is_nullable as DBNullable,
		case
			when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier')
			then '?'
			else ''
		end NullableSign
	from
		sys.columns col
		join sys.types typ on col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
	where
		object_id = object_id(@TableName)
	)
	select '	public ' + ColumnType + NullableSign + ' ' + ColumnName + ' { get; set; }' as c1
	into #tmp
		from CTE_columns
		order by ColumnId;

	select 'public class ' + @TableName + '	{' as c1
	UNION ALL
	select c1 from #tmp
	UNION ALL
	select char(10)+Char(13)+'}' as c1

END
GO
