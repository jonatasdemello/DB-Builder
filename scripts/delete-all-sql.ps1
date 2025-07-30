# Goal: delete all the custom .sql files

cd ..\src

# ignore:
# 'Build',
# 'UnitTests',

$folders = @(
'Assemblies',
'Data',
'ForeignKeys',
'Functions',
'Schemas',
'Security',
'Sequences',
'StoredProcedures',
'Synonyms',
'Tables',
'Types',
'UpgradeScripts',
'Views'
)

foreach ( $folder in $folders ) {
	Get-ChildItem *.sql -Path $folder -Recurse | Select FullName
}

