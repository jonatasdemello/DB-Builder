IF EXISTS(SELECT * FROM sys.databases WHERE [name] = '$(databasename)')
    SELECT "true"
ELSE
    SELECT "false"
