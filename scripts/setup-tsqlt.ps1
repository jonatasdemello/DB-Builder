# Unit Tests

sqlcmd -s . -U sa -P "<password>" -i ..\src\UnitTests\01_PrepareServer.sql -d Test-123

sqlcmd -s . -U sa -P "<password>" -i ..\src\UnitTests\02_tSQLt_class.sql -d Test-123

sqlcmd -s . -U sa -P "<password>" -i ..\src\UnitTests\03_RunTests.sql -d Test-123

