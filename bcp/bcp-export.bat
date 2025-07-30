@ECHO OFF

set table=%~1
set SQLServer=%~2
set SQLDBName=%~3
set uid=%~4
set pwd=%~5

rem export data and format file
bcp.exe %table% format nul -f %table%.fmt -c -r 0x0A -S %SQLServer% -d %SQLDBName% -U %uid% -P %pwd%
bcp.exe %table% OUT %table%.bcp -f %table%.fmt -c -r 0x0A -S %SQLServer% -d %SQLDBName% -U %uid% -P %pwd%
