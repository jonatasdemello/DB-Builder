@ECHO OFF

set table=%~1
set SQLServer=%~2
set SQLDBName=%~3
set uid=%~4
set pwd=%~5

rem Import data using format file
bcp.exe %table% IN %table%.bcp -f %table%.fmt -S %SQLServer% -d %SQLDBName% -U %uid% -P %pwd%
