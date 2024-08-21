gci *.sql | ren -newname { $_.name -replace 'dbo','pubs'}

gci pubs.*.sql -recurse | ren -newname { $_.name -replace 'pubs.','pubs_'}

gci *.Table.sql -recurse | ren -newname { $_.name -replace '.Table',''}
gci *.View.sql -recurse | ren -newname { $_.name -replace '.View',''}
gci *.StoredProcedure.sql -recurse | ren -newname { $_.name -replace '.StoredProcedure',''}
gci *.UserDefinedDataType.sql -recurse | ren -newname { $_.name -replace '.UserDefinedDataType',''}
