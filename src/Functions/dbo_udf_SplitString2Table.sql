EXEC dbo.ProvisionTableFunction 'dbo', 'udf_SplitString2Table'
GO

ALTER function [dbo].[udf_SplitString2Table]
(
  @slist varchar(MAX)
)
returns
  @tlist table( item varchar(255) )
as
begin
  declare @p int

  set @p = 0

  while( @p <= Len(@slist) )
  begin
    set @slist = substring(@slist, @p, len(@slist) + 1 - @p )
    set @p = CHARINDEX(',', @slist, 0)
    if @p = 0
      begin
        insert into @tlist( item ) select @slist
        break
      end
    else
      insert into @tlist( item ) select left(@slist,@p - 1)
    set @p = @p + 1
  end

  UPDATE @tlist SET item = LTRIM(RTRIM(item))

  return
end