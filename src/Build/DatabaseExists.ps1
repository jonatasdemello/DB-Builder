param(
    [string] $server,
    [string] $db,
    [string] $user,
    [string] $pass
)
sqlcmd -S $server -i ".\DatabaseExists.sql" -v databasename=$db -r0 -m11 -b -V 1 -U $user -P $pass
