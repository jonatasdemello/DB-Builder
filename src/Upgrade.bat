@ECHO  OFF
setlocal enabledelayedexpansion

REM *********************************************************************************************
REM Upgrades an existing database.
REM *********************************************************************************************

echo Script Start: %time%
DEL /F /Q /S "_tmp.cmd" >nul 2>&1

IF "%~1"=="" (
	GOTO InvalidParameters
)

IF "%~2"=="" (
	GOTO InvalidParameters
)

SET SCRIPT_PATH=%~dp0

ECHO "---------------------------------------------------------------------------------------------------"
ECHO Upgrading database %2 on %1  Please wait...
ECHO "---------------------------------------------------------------------------------------------------"

ECHO ... Running Upgrade Scripts
CALL "%SCRIPT_PATH%UpgradeScripts\RunUpgradeScripts.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Altering UDFs
CALL "%SCRIPT_PATH%Functions\CreateFunctions.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Altering Views
CALL "%SCRIPT_PATH%Views\CreateViews.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Altering Stored Procedures
CALL "%SCRIPT_PATH%StoredProcedures\CreateSprocs.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO "---------------------------------------------------------------------------------------------------"
ECHO.
ECHO Database %2 was upgraded successfully on %1. Have a nice day.
ECHO.
ECHO "---------------------------------------------------------------------------------------------------"
GOTO Done

:Error

ECHO.
ECHO.

ECHO "---------------------------------------------------------------------------------------------------"
ECHO CRITICAL ERROR: Database %2 was not upgraded!
ECHO "---------------------------------------------------------------------------------------------------"
ECHO.
type "%SCRIPT_PATH%Build\error.txt"
ECHO.
ECHO.
DEL /F /Q /S *tmp.cmd >nul 2>&1
EXIT /b 1
GOTO Done

:InvalidParameters
ECHO "---------------------------------------------------------------------------------------------------"
ECHO.
ECHO Database NOT created. Syntax is Upgrade.bat servername databasename [username] [password]
ECHO.
ECHO "---------------------------------------------------------------------------------------------------"

:Done
echo Script Stop: %time%
DEL /F /Q /S *tmp.cmd >nul 2>&1
