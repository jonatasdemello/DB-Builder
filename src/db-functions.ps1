# =============================================================================
#    Database Builder Tool
# =============================================================================
# add some space before starting (not essential, nice to have)
write-host "`n`n"

# global variables:
# -----------------------------------------------------------------------------
# set paths to make it easier to work on multiple platforms (linux/windows)
$dbPath = (Get-Location).Path
$tmpPath = Join-Path $dbPath -ChildPath "temp"

# SqlCmd tools path in order to run T-SQL scripts
Set-Variable -Name cmd -Value "sqlcmd" -Scope Global
Set-Variable -Name sqlcmdver -Value "odbc" -Scope Global
Set-Variable -Name IsReady -Value $False -Scope Global
Set-Variable -Name totalFiles -Value 0 -Scope Global
Set-Variable -Name subtotalFiles -Value 0 -Scope Global
$StopWatch = new-object system.diagnostics.stopwatch
$benchmark = @{
	startTime = $null
	endTime = $null
	total = 0
}

# ---------------------------------------------------------------------------------------------------
# Log output wrapper (create our customized format)
function Write-Log {
	param ( $category="INFO", $msg="" , $fgColor="White", $bgColor="Black" )

	$date =  Get-Date -format "yyyy-MM-dd HH:mm:ss.ff"
	Write-Host "$date  [$category] `t $msg" -ForegroundColor $fgColor -BackgroundColor $bgColor
}

# Pre-Requisite: in order to use "Invoke-Sqlcmd" we need to install it first:
function InstallSqlCmdTools {
	# this is going to be used later
	Install-Module -Name SqlServer
	Import-Module SqlServer
	Get-Module -Name SqlServer
}

# Fail build if something is wrong
function FailBuild {
	param (
		$exitcode = 1
	)
	# $LastExitCode is the return code of native applications.
	# $? just returns True or False depending on whether the last command (cmdlet or native) exited without error or not.

	Write-Log "ERROR" " * * * Build failed with exit code: [ $exitcode ] * * * `n`n"

	$global:LASTEXITCODE = 1
	exit 1
}

# Find where/if SQL tools are installed and set path to global variable $global:cmd
function FindSqlTools {
	$found = $false

	# on Windows just use the "sqlcmd.exe" and assume it is already on the {PATH} $env::Path
	if ($IsWindows -or ("Windows_NT" -eq $env:OS )) {
		Set-Variable -Name cmd -Value "sqlcmd.exe" -Scope Global
		$found = $true;
	}

	# on Linux, it may be on different places, depending on the installed toolset
	if ($IsLinux) {
		# ODBC version
		if (Test-Path -Path "/opt/mssql-tools/bin") {
			Set-Variable -Name cmd -Value "/opt/mssql-tools/bin/sqlcmd" -Scope Global
			$found = $true;
		}
		# ODBC version
		if (Test-Path -Path "/opt/mssql-tools18/bin") {
			Set-Variable -Name cmd -Value "/opt/mssql-tools18/bin/sqlcmd" -Scope Global
			$found = $true;
		}
		# GO version
		if (Test-Path -Path "/usr/bin/sqlcmd") {
			Set-Variable -Name cmd -Value "/usr/bin/sqlcmd" -Scope Global
			$found = $true;
		}
	}

	# on Mac, using homebrew
	if ($IsMacOS) {
		# /opt/homebrew/bin/sqlcmd
		if (Test-Path -Path "/opt/homebrew/bin/sqlcmd") {
			Set-Variable -Name cmd -Value "/opt/homebrew/bin/sqlcmd" -Scope Global
			$found = $true;
		}
	}

	# Find out which version is available (ODBC or GO)
	if ($found) {
		# check if we have the ODBC version or the GO version
		$version = & $cmd -? 2>&1 | Select-String -Pattern "SQL Server Command Line Tool" -SimpleMatch
		$versionNumber = & $cmd -? 2>&1 | Select-String -Pattern "Version.+[0-9]"
		if ($version -match "SQL Server Command Line Tool") {
			Write-Log "INFO" "Found sqlcmd ODBC version: $versionNumber" -fgColor DarkCyan
			Set-Variable -Name sqlcmdver -Value "odbc" -Scope Global
		}
		else {
			Write-Log "INFO" "Found sqlcmd GO version: $versionNumber" -fgColor DarkCyan
			Set-Variable -Name sqlcmdver -Value "go" -Scope Global
		}
	}

	if (!$found) {
		Write-Log "ERROR" "sqlcmd not found."
		FailBuild
	}
	# later we can improve this to install necessary tools...
}

# Start SQL Server on Linux
function StartSQLServer {
	# note: for docker builds, we need to start SQL Server
	# Use the Start verb to begin asynchronous operations, such as starting an autonomous process.
	if ($IsLinux) {
		Write-Host "... start SQL Server on Linux"
		Start-Process -NoNewWindow "/opt/mssql/bin/sqlservr"
	}
}

# Test to make sure SQL Server is up and running
function WaitForSqlStart {
	# Note: $cmd must be set (call "FindSqlTools" before)
	$params = "-Q `"SELECT GETDATE()`" -S $SQLServer $SQLcredential -d master -C "

	for ($i = 1; $i -le 10; $i++) {
		Write-Host "... check if SQL Server is running"
		$process = Start-Process $cmd -ArgumentList $params -PassThru -Wait -NoNewWindow
		$process.WaitForExit();
		if ($process.ExitCode -eq 0) {
			break
		}
		Start-Sleep -Seconds 10
	}
}

# Deploy/execute/run sql command(s) inside a file
function DeploySqlFile {
	param (
		[string]$file,
		[string]$database=""
	)

	# debug (if verbose then print the file)
	if ("Continue" -eq $VerbosePreference) {
		Write-Log "INFO" ". file: $file" -fgColor DarkYellow
	}

	# check if file exists
	if (!(Test-Path -Path $file)) {
		Write-Log "ERROR" "  . file: $file does not exist" -fgColor Red
		FailBuild
	}

	# There are 2 options where:
	#  one we have the -d Database parameter and the other we don't
	# (-variable is fine, but -d Database requires the DB to exist first)

	# we don't have the -d Database parameter (-v var=value is fine)
	$params = "-i $file -S $SQLServer $SQLcredential -v databasename=$SQLDBName -C -I -b -V 1 -m11 "

	# if we have the -d Database parameter
	if ($database)
	{
		$params += " -d $SQLDBName "
	}

	if ($sqlcmdver -eq "odbc") {
		$params += " -f 65001 -I -r0 "
	}
	else {
		# GO version (sqlcmd-go)
		$params += " -r 0 "
	}

	# Params:
	# -C,--trust-server-certificate
	# -I,--enable-quoted-identifiers
	# -b,--exit-on-error
	# -V,--error-severity-level
	# -m,--error-level

	# NOTE: these parameters were there before to output errors
	# -r0 -I -m11 -b -V 1
	# -r0 or -r1 doesn't work with sqlcmd-GO version, should be -r 0
	# -f 65001 codepage (Note: not available in the new sqlcmd (go-sqlcmd) yet - UTF-8 is CP65001)

	try {
		if($IsLinux) {
			# Linux is good starting new processes
			$process = Start-Process $cmd -ArgumentList $params -PassThru -Wait -NoNewWindow

			$process.WaitForExit();
			if ($process.ExitCode -ne 0) {
				Write-Log "ERROR" "`n`n * * * Error file: $file `n`n"
				FailBuild $process.ExitCode
			}
		}
		else {
			# Windows is really bad starting new processes (too slow)
			$run = $cmd + " " + $params + ';$?'

			# instead, use Invoke-Expression to run commands or expressions on the local computer
			$result = Invoke-Expression -Command $run
$result
			# if it returns an Array, could be an error or just multiple results
			$isArray = $result -is [array] -or ($result.GetType().Name -eq 'Object[]')

			# if $result is an array, check for "false" or "error"
			if ($isArray) {
				$result = $result | Where-Object { $_ -match "error" -or $_ -match "false" }
			}

			Write-Debug -Message "result: $result"
			Write-Debug -Message "isArray: $isArray"

			# result = true && isArray = false (not error, no output)
			# result = true && isArray = true (not error, just info or warning)
			if($result -eq $true -and $isArray -eq $true) {
				$text = ( $result -join "`n")
				Write-Log "WARN" "`n`n* * * Warning file: $file `n$text `n`n"
			}

			# result = false (means an error)
			if($result -eq $false) {
				$text = ( $result -join "`n")
				Write-Log "ERROR" "`n`n* * * Error file: $file `n$text `n`n"
				FailBuild
			}
		}
	}
	catch {
		Write-Log "ERROR" ">>> Error in File: $file" -fgColor Red
		Write-Log "ERROR" " "
		Write-Log "ERROR" " * Exception type: $($_.Exception.GetType().FullName) `n" -fgColor Red
		Write-Log "ERROR" " * Exception message: `n $($_.Exception.Message) `n" -fgColor Red
		FailBuild $LASTEXITCODE
	}
	$global:totalFiles += 1
}

# Deploy/execute/run just One .sql file inside a folder
function DeploySqlFolderFile {
	param (
		[string]$folder,
		[string]$file,
		[string]$database
	)

	# here we have to build the full path using the -folder parameter
	$fullPath = Join-Path $dbPath -ChildPath $folder | Join-Path -ChildPath $file
	Write-Log "INFO" "... file: $fullPath"

	DeploySqlFile -file "$fullPath" -database "$database"
}

# Deploy/execute/run All .sql files inside a folder (recursive - include sub-folders)
function DeploySqlFolder {
	param (
		[string]$folder,
		[string]$database
	)

	$filesInFolder = 0

	$tmpfile = Join-Path $tmpPath -ChildPath "sqlcommands.sqlcmd"

	RemoveFile $tmpfile

	$folderPath = Join-Path $dbPath -ChildPath $folder

	if (Test-Path -Path $folderPath) {
		Write-Log "INFO" "  . folder: $folderPath"
		$dest = Join-Path $folder -ChildPath "*.sql"

		$debug = $False
		if (("Continue" -eq $VerbosePreference) -or ("UpgradeScripts" -eq $folder)) {
			$debug = $True
		}

		if ($debug) {
			# v1: run each sql file one by one (this is slower but makes it easier to find errors)
			Get-Childitem -Path $dest -Recurse | ForEach-Object {
					if ("UpgradeScripts" -eq $folder){
						Write-Log "INFO" "   . file: $_" -fgColor DarkYellow
					}
				DeploySqlFile -file $_ -database "$database" # send DB name here
				$filesInFolder += 1
			}
		}
		else {
			# v2: use slqcmd command file (run files in batch) (this is faster but makes it harder to find errors)
			$master = ""
			Get-Childitem -Path $dest -Recurse | ForEach-Object {
				$filesInFolder += 1
				$master += ":r $_ `nGO `n"
			}
			# save file with all "sqlcmd commands"
			Set-Content -Path $tmpfile -Value $master
			# execute file with all "sqlcmd commands" at once
			DeploySqlFile -file $tmpfile -database "$database" # send DB name here
		}
	}
	else {
		Write-Log "ERROR" "  . folder: $folderPath does not exist" -fgColor Red
	}
	RemoveFile $tmpfile

	Write-Log "INFO" "  . folder: $folderPath - files: $filesInFolder"

	# add subtotal, since we are grouping multiple sql files in one slqcmd
	$global:subtotalFiles += $filesInFolder
}

# Check for invalid file names with spaces or dots (could cause errors on build)
function ValidateFileNames {
	param ( [string]$database )

	# check files names with spaces
	$filenameWithSpaces = Get-Childitem -Path . -Filter "* *.sql" -recurse
	if (0 -ne $filenameWithSpaces.length -or $filenameWithSpaces)
	{
		Write-Log "ERROR" "  File name contain invalid character space ' '" -fgColor red
		# show files with errors
		Write-Host ($filenameWithSpaces -join "`n")
		Write-Host "`n`n`n"
		FailBuild
	}

	# check files names with dots
	$filenameWithDots = Get-Childitem -Path . -Filter "*.*.sql" -recurse
	if (0 -ne $filenameWithDots.length -or $filenameWithDots)
	{
		Write-Log "ERROR" "  File name contain invalid character dot '.'" -fgColor red
		# show files with errors
		Write-Host ($filenameWithDots -join "`n")
		Write-Host "`n`n`n"
		FailBuild
	}

	# only check files in the DB build folders
	$exclude = @("*.sql","*.bat","*.ps1","*.zip","*.txt","*.md","*.cs",".git",".github",".vscode",".idea","*.json","*.nuspec","*.cmd","*.sqlcmd")
	$buildFolders = @("Assemblies", "Data", "ForeignKeys", "Functions", "Schemas", "Security", "Sequences", "StoredProcedures", "Synonyms", "Tables", "Types", "UnitTests", "UpgradeScripts", "UtilScripts", "Views")
	foreach($folder in $buildFolders) {

		$fileExtInvalid = Get-ChildItem -Path $folder -File -Exclude $exclude -recurse
		if (0 -ne $fileExtInvalid.length)
		{
			Write-Log "ERROR" "  File extension is invalid - only allowed: '.sql'" -fgColor red
			# show files with errors
			Write-Host ($fileExtInvalid -join "`n")
			Write-Host "`n`n`n"
			FailBuild
		}
	}

	Write-Log "INFO" "  . Check files done - all files OK."
}

# Check Upgrade Scripts for missing "SET NOCOUNT ON"
function ValidateUpgradeScripts {
	$matchingFiles = Get-ChildItem -Path .\UpgradeScripts\ -Filter "*.sql" | ForEach-Object {
	    $firstLine = Get-Content $_.FullName -TotalCount 1
	    if ($firstLine -notmatch "SET NOCOUNT ON") {
	        $_.FullName
	    }
	}
	$matchingFilesCount = $matchingFiles.Count

	if (0 -ne $matchingFilesCount)
	{
		Write-Log "ERROR" "  Upgrade Scripts files missing 'SET NOCOUNT ON;' in the first line" -fgColor red
		# show files with errors
		Write-Host ($matchingFiles -join "`n")
		Write-Host "`n`n`n"
		FailBuild
	}
}

# Delete temporary work files
function RemoveFile {
	param ( [string]$fileName )

	If (Test-Path -Path $fileName) {
		Remove-Item $fileName -Force | Out-Null
	}
}

# Delete existing Database (to create a new one)
function RemoveDatabase {
	Write-Log "INFO" "--- DROP database [$SQLDBName] if exists ---" -fgColor DarkYellow -bgColor Black

	$sql = "DROP DATABASE IF EXISTS [$SQLDBName];"
	$params = "-I -Q `"$sql`" -S $SQLServer $SQLcredential -C -m11 -b -V 1 " # -o $tmpfile"

	$process = Start-Process $cmd -ArgumentList $params -PassThru -Wait -NoNewWindow
	$process.WaitForExit();
	if ($process.ExitCode -ne 0) {
		Write-Log "ERROR" " RemoveDatabase exited with status code $($process.ExitCode)"
		FailBuild $process.ExitCode
	}
}

# Check if a Database Exists
function TestDatabaseExists {
	param ( [string]$database )

	Write-Log "INFO" "--- Check if database [$database] exists ---" -fgColor DarkYellow -bgColor Black

	$tmpfile = Join-Path $tmpPath -ChildPath "query_output.txt"
	RemoveFile $tmpfile

	$sql = "SELECT LEFT(name, 50) AS dbName FROM master.sys.databases WHERE name = '" + $database +"'";
	$params = "-I -Q `"$sql`" -S $SQLServer $SQLcredential -C -m11 -b -V 1 -o $tmpfile"

	$process = Start-Process $cmd -ArgumentList $params -PassThru -Wait -NoNewWindow
	$process.WaitForExit();
	if ($process.ExitCode -ne 0) {
		Write-Log "ERROR" " TestDatabaseExists exited with status code $($process.ExitCode)"

		if (Test-Path -Path $tmpfile) {
			Get-Content $tmpfile # show result for debug
		}
		FailBuild $process.ExitCode
	}

	$dbExists = Select-String -Path $tmpfile -Pattern "$database"

	RemoveFile $tmpfile

	if ($null -ne $dbExists) # Contains String
	{
		Write-Log "INFO" "  Database [$SQLDBName] found!"
		return $true
	}
	else # Does Not Contains String
	{
		Write-Log "INFO" "  Database [$SQLDBName] not found!"
		return $false
	}
}

# Initial Database Setup: create a new database + logins + linked server
function InitializeDatabase {
	# IMPORTANT:
	#    - the "DatabaseSetup.sql" script DROPs the database if already exists!
	#    - the database has not been created yet, so we can't use "-d database" param here!

	Write-Log "INFO" "--- Create Login ---" -fgColor DarkYellow -bgColor Black
	DeploySqlFolderFile -folder "Build" -file "create-login.sql" -database ""

	Write-Log "INFO" "--- Create Linked Server ---" -fgColor DarkYellow -bgColor Black
	DeploySqlFolderFile -folder "Build" -file "create-linked-server.sql" -database ""

	Write-Log "INFO" "--- Database Setup $SQLDBName ---" -fgColor DarkYellow -bgColor Black
	DeploySqlFolderFile -folder "Build" -file "DatabaseSetup.sql" -database ""
}

# Make sure the dbo.Provision(*) sprocs exist
function InitializeProvisionSproc {
	Write-Log "INFO" "--- Create Provision Procedures ---" -fgColor DarkYellow -bgColor Black

	# need to specify the -d database param here
	DeploySqlFolderFile -folder "Functions" -file "001_ProvisionScalarFunction.sql" -database "$SQLDBName"
	DeploySqlFolderFile -folder "Functions" -file "001_ProvisionTableFunction.sql" -database "$SQLDBName"
	DeploySqlFolderFile -folder "StoredProcedures" -file "001_ProvisionSproc.sql" -database "$SQLDBName"
	DeploySqlFolderFile -folder "Views" -file "001_ProvisionView.sql" -database "$SQLDBName"
}

# Set parameters as global variables (since they don't change it, so we can use it everywhere)
function SetVariables {
	param (
		[string]$Server,
		[string]$Database,
		[string]$Username,
		[string]$Password
	)

	# try to get user from env variable, if parameter is empty
	if (!$Username -and $Env:SQLCMDUSER) {
		$Username = $Env:SQLCMDUSER
	}
	# try to get pass from env variable, if parameter is empty
	if (!$Password -and $Env:SQLCMDPASSWORD) {
		$Password = $Env:SQLCMDPASSWORD
	}

	# set global variables
	Set-Variable -Name SQLServer -Value $Server -Scope Global
	Set-Variable -Name SQLDBName -Value $Database -Scope Global
	Set-Variable -Name SQLuid -Value $Username -Scope Global
	Set-Variable -Name SQLpwd -Value $Password -Scope Global

	Set-Variable -Name SQLcredential -Value " -U $SQLuid -P $SQLpwd " -Scope Global

	# if there is no user+pass try to use -E trusted connection instead
	if (!$Username -and !$Password) {
		Set-Variable -Name SQLcredential -Value " -E " -Scope Global
	}
}

# Prepare the environment first: Prepares a resource for use, and sets it to a default state.
function InitializeEnvironment {
	param (
		[Parameter(Mandatory=$true)]
		[string]$Server,
		[Parameter(Mandatory=$true)]
		[string]$Database,
		[string]$Username,
		[string]$Password
	)
	Write-Log "INFO" "--- Initializing Environment" -fgColor DarkYellow -bgColor Black

	# only run once
	if ($IsReady) {
		return;
	}
	# create temp folder to store working files
	If ( !(Test-Path -Path $tmpPath)) {
		New-Item -ItemType Directory -Force -Path $tmpPath | Out-Null
	}

	# set default global variables so we don't need to send it every time
	SetVariables -Server $Server -Database $Database -User $Username -Pass $Password

	# make sure we have the tools we need installed:
	FindSqlTools

	# check for invalid file names (that could break the build)
	ValidateFileNames

	# check for invalid upgrade scripts (that could break the build)
	ValidateUpgradeScripts

	# check if SQL Server is running
	WaitForSqlStart

	# set as true, so it doesn't run again
	$global:IsReady = $True
}

# Create Database objects (tables, functions, views, stored procedures)
function DeployBuildFolders {
	# ---------------------------------------------------------------------------------------------------
	# DB Build Process starts here.
	# To create the database we run the scrits in those folders (in order):
	Write-Log "INFO" "--- Create DB Folders ---" -fgColor DarkYellow -bgColor Black

	DeploySqlFolder -folder "Assemblies" -database "$SQLDBName"
	DeploySqlFolder -folder "Schemas" -database "$SQLDBName"
	DeploySqlFolder -folder "Synonyms" -database "$SQLDBName"
	DeploySqlFolder -folder "Sequences" -database "$SQLDBName"
	DeploySqlFolder -folder "Types" -database "$SQLDBName"
	DeploySqlFolder -folder "Tables" -database "$SQLDBName"
	DeploySqlFolder -folder "ForeignKeys" -database "$SQLDBName"
	DeploySqlFolder -folder "Functions" -database "$SQLDBName"
	DeploySqlFolder -folder "Views" -database "$SQLDBName"
	DeploySqlFolder -folder "StoredProcedures" -database "$SQLDBName"
	DeploySqlFolder -folder "Security" -database "$SQLDBName"
}

# Add seed and test data
function DeployDataFolders {
	# ---------------------------------------------------------------------------------------------------
	# Build data folders
	Write-Log "INFO" "--- Create Data ---" -fgColor DarkYellow -bgColor Black

	$DataDefault = Join-Path "Data" -ChildPath "Default"
	$DataTestData = Join-Path "Data" -ChildPath "TestData"

	DeploySqlFolder -folder $DataDefault -database "$SQLDBName"
	DeploySqlFolder -folder $DataTestData -database "$SQLDBName"
}

function DeployUpgradeFolders {
	# ---------------------------------------------------------------------------------------------------
	# DB Build Process starts here.
	# To update the database we run the scrits in those folders (in order):

	Write-Log "INFO" "--- Deploy Upgrade Folders ---" -fgColor DarkYellow -bgColor Black

	DeploySqlFolder -folder "UpgradeScripts" -database "$SQLDBName"
	DeploySqlFolder -folder "Functions" -database "$SQLDBName"
	DeploySqlFolder -folder "Views" -database "$SQLDBName"
	DeploySqlFolder -folder "StoredProcedures" -database "$SQLDBName"
}

function WriteHeader {
	param (
		$action
	)
	Write-Log "INFO" " "
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" "    [$action]   server: $SQLServer   database: $SQLDBName" -fgColor DarkGreen
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" " "
}

function WriteFooter {
	param (
		$action
	)
	Write-Log "INFO" " "
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" "    [$action]   server: $SQLServer   database: $SQLDBName" -fgColor DarkGreen
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" " "
}

function WriteBenchmark {

	$bkstart = $benchmark['startTime']
	$bkstop =  $benchmark['endTime']
	$bktotal = $benchmark['total']

	Write-Log "INFO" " ... Benchmark: " -fgColor DarkCyan
	Write-Log "INFO" " ...   Start Time  : $bkstart" -fgColor DarkCyan
	Write-Log "INFO" " ...   Stop Time   : $bkstop" -fgColor DarkCyan
	Write-Log "INFO" " ...   Total Time  : $bktotal" -fgColor DarkCyan
	Write-Log "INFO" " ...   Total Files : $totalFiles / $subtotalFiles" -fgColor DarkCyan
}

function StartBenchmark {

	$StopWatch.Reset()
	$StopWatch.Start()

	$benchmark['startTime'] = Get-Date
	$benchmark['endTime'] = $null
	$benchmark['total'] = 0
}

function StopBenchmark {

	$StopWatch.Stop();

	$benchmark['endTime'] = Get-Date
	$benchmark['total'] = $StopWatch.Elapsed;
}

# Check if Database Exists
function CheckDatabase {
	param (
		[bool]$MustExist
	)
	$dbExists = TestDatabaseExists -database "$SQLDBName"

	if ( $dbExists -and -not $MustExist) {
		Write-Log "ERROR" "  Database [$SQLDBName] already exists! Drop the database first." -fgColor Red
		FailBuild
	}

	if (-not $dbExists -and $MustExist) {
		Write-Log "ERRROR" "  Database [$SQLDBName] NOT found. Create the database first."
		FailBuild
	}
}

# Create a new database
function NewDatabase {
	param (
		[Parameter(Mandatory=$true)]
		[string]$Server,
		[Parameter(Mandatory=$true)]
		[string]$Database,
		[string]$Username,
		[string]$Password,
		[System.Boolean]$Force = $False
	)

	InitializeEnvironment -Server $Server -Database $Database -User $Username -Pass $Password

	if ($Force) {
		RemoveDatabase
	}

	StartBenchmark

	WriteHeader "Create Database"

	CheckDatabase -MustExist $false

	InitializeDatabase

	InitializeProvisionSproc

	DeployBuildFolders

	DeployDataFolders

	WriteFooter "Database Created"

	StopBenchmark
	WriteBenchmark
}

# Upgrade an existing database, (DB must already exists)
function UpdateDatabase {
	param (
		[Parameter(Mandatory=$true)]
		[string]$Server,
		[Parameter(Mandatory=$true)]
		[string]$Database,
		[string]$Username,
		[string]$Password
	)

	InitializeEnvironment -Server $Server -Database $Database -User $Username -Pass $Password

	StartBenchmark

	WriteHeader "Upgrade Database"

	CheckDatabase -MustExist $true

	DeployUpgradeFolders

	WriteFooter "Database Upgraded"

	StopBenchmark
	WriteBenchmark
}

# ---------------------------------------------------------------------------------------------------
