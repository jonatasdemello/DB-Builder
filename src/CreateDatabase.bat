@ECHO  OFF
setlocal enabledelayedexpansion

REM *********************************************************************************************
REM Creates a database on the local default instance of SQL server.
REM
REM Usage: CreateDatabase.bat servername databasename [username] [password]
REM
REM Parameters: servername and databasename are both required. If username and password are not provided
REM 			this script uses windows authentication to run .SQL scripts.
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
ECHO Creating database %2 on %1  Please wait...
ECHO "---------------------------------------------------------------------------------------------------"

REM If we're using SQL authentication.
IF "%~3" NEQ "" ( IF "%~4" NEQ "" (
	sqlcmd -S %1 -i "%SCRIPT_PATH%Build\DatabaseSetup.sql" -v databasename=%2 -r0 -m11 -b -V 1 -U %3 -P %4
	IF %ERRORLEVEL% NEQ 0 (
	   GOTO Error
	)
))

REM If we're using trusted authentication.
IF "%~3"=="" ( IF "%~4"=="" (
	sqlcmd -S %1 -i "%SCRIPT_PATH%Build\DatabaseSetup.sql" -v databasename=%2 -r0 -m11 -b -V 1
	IF %ERRORLEVEL% NEQ 0 (
	   GOTO Error
	)
))


REM *** Add Logins ***
REM -----------------------------------------------------------------------------------------------
REM If we're using SQL authentication.
IF "%~3" NEQ "" ( IF "%~4" NEQ "" (
	sqlcmd -S %1 -i "%SCRIPT_PATH%Build\create-login.sql" -v databasename=%2 -r0 -m11 -b -V 1 -U %3 -P %4
	IF %ERRORLEVEL% NEQ 0 (
	   GOTO Error
	)
))
REM If we're using trusted authentication.
IF "%~3"=="" ( IF "%~4"=="" (
	sqlcmd -S %1 -i "%SCRIPT_PATH%Build\create-login.sql" -v databasename=%2 -r0 -m11 -b -V 1
	IF %ERRORLEVEL% NEQ 0 (
	   GOTO Error
	)
))

REM *** Add Linked Server ***
REM -----------------------------------------------------------------------------------------------
REM If we're using SQL authentication.
IF "%~3" NEQ "" ( IF "%~4" NEQ "" (
	sqlcmd -S %1 -i "%SCRIPT_PATH%Build\create-linked-server.sql" -v databasename=%2 -r0 -m11 -b -V 1 -U %3 -P %4
	IF %ERRORLEVEL% NEQ 0 (
	   GOTO Error
	)
))
REM If we're using trusted authentication.
IF "%~3"=="" ( IF "%~4"=="" (
	sqlcmd -S %1 -i "%SCRIPT_PATH%Build\create-linked-server.sql" -v databasename=%2 -r0 -m11 -b -V 1
	IF %ERRORLEVEL% NEQ 0 (
	   GOTO Error
	)
))

REM -----------------------------------------------------------------------------------------------

ECHO ... Creating Assemblies
CALL "%SCRIPT_PATH%Assemblies\CreateAssemblies.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Schemas
CALL "%SCRIPT_PATH%Schemas\CreateSchemas.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Synonyms
CALL "%SCRIPT_PATH%Synonyms\CreateSynonyms.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Sequences
CALL "%SCRIPT_PATH%Sequences\CreateSequences.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Types
CALL "%SCRIPT_PATH%Types\CreateTypes.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Tables
CALL "%SCRIPT_PATH%Tables\CreateTables.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Foreign Keys
CALL "%SCRIPT_PATH%ForeignKeys\CreateFKs.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating UDFs
CALL "%SCRIPT_PATH%Functions\CreateFunctions.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Views
CALL "%SCRIPT_PATH%Views\CreateViews.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Stored Procedures
CALL "%SCRIPT_PATH%StoredProcedures\CreateSprocs.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Creating Users and Logins
CALL "%SCRIPT_PATH%Security\CreateSecurity.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Generating Default Data
CALL "%SCRIPT_PATH%Data\Default\CreateDefaultData.bat" %1 %2 %3 %4
IF %ERRORLEVEL% NEQ 0 (
   GOTO Error
)

ECHO ... Generating Test Data
CALL "%SCRIPT_PATH%Data\TestData\CreateTestData.bat" %1 %2 %3 %4
IF !ERRORLEVEL! NEQ 0 (
    GOTO Error
 )

REM note: not using Unit Tests for now.
REM ECHO ... Running Unit Tests
REM CALL "%SCRIPT_PATH%UnitTests\RunUnitTests.bat" %1 %2 %3 %4
REM IF !ERRORLEVEL! NEQ 0 (
REM    GOTO Error
REM )

ECHO "---------------------------------------------------------------------------------------------------"
ECHO.
ECHO Database %2 was created successfully on %1. Have a nice day.
ECHO.
ECHO "---------------------------------------------------------------------------------------------------"
GOTO Done

:Error

ECHO.
ECHO.
ECHO "---------------------------------------------------------------------------------------------------"
ECHO CRITICAL ERROR: Database %2 was not created!
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
ECHO Database NOT created. Syntax is CreateDatabase.bat servername databasename [username] [password]
ECHO.
ECHO "---------------------------------------------------------------------------------------------------"

:Done
echo Script Stop: %time%
DEL /F /Q /S *tmp.cmd >nul 2>&1
