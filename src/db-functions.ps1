# =============================================================================
#    Database Builder Tool
# =============================================================================
# add some space before starting (not essential, nice to have)
write-host "`n`n"

# we need the SqlCmd tools in order to run T-SQL
Set-Variable -Name cmd -Value "sqlcmd" -Scope Global

# set paths to make it easier to work on multiple platforms
$dbPath = (Get-Location).Path
$tmpPath = Join-Path $dbPath -ChildPath "temp"

# create temp folder to store output
New-Item -ItemType Directory -Force -Path $tmpPath | Out-Null

# global number of files executed for debug
Set-Variable -Name totalFiles -Value 0 -Scope Global
Set-Variable -Name subtotalFiles -Value 0 -Scope Global

# debug
Write-Verbose "dbPath: $dbPath"
Write-Verbose "tmpPath: $tmpPath"

# ---------------------------------------------------------------------------------------------------
# Log output wrapper (create our customized format)
function Write-Log {
	param( $category="INFO", $msg="" , $fgColor="White", $bgColor="Black" )

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
	param(
		$exitcode
	)
	# $LastExitCode is the return code of native applications.
	# $? just returns True or False depending on whether the last command (cmdlet or native) exited without error or not.

	Write-Log "ERROR" "`n`n * * * Build failed with exit code: $exitcode * * * `n`n"

	$global:LASTEXITCODE = 15
	exit 15
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

	if (!$found) {
		Write-Log "ERROR" "sqlcmd not found."
		FailBuild
	}
	# later we can improve this to install necessary tools...
}

# Deploy/execute/run sql command(s) inside a file
function DeploySqlFile {
	param(
		[string]$file,
		[string]$database=""
	)

	# debug (if verbose then print the file)
	if ("Continue" -eq $VerbosePreference) {
		Write-Log "INFO" ". file: $file" -fgColor DarkYellow
	}

	# There are 2 options where:
	#  one we have the -d Database parameter and the other we don't
	# (-variable is fine, but -d Database requires the DB to exist first)

	if (!$database) # we don't have the -d Database parameter (-v var=value is fine)
	{
		$params = "-i $file -S $SQLServer $SQLcredential -v databasename=$SQLDBName -I -b -V 1 -m11 -f 65001 "
	}
	else # we have the -d Database parameter
	{
		$params = "-i $file -S $SQLServer $SQLcredential -d $SQLDBName -v databasename=$SQLDBName -I -b -V 1 -m11 -f 65001 "
	}
	# NOTE: these parameters were there before to output errors
	# -r0 -I -m11 -b -V 1
	# -r0 or -r1 doesn't work with sqlcmd-GO version, should be -r 0
	# -f 65001 codepage (Note: not available in the new sqlcmd (go-sqlcmd) yet)

	try {
		if($IsLinux) {
			# Linux is good starting new processes
			$process = Start-Process $cmd -ArgumentList $params -PassThru -Wait -NoNewWindow

			$process.WaitForExit();
			if ($process.ExitCode -ne 0) {
				Write-Log "ERROR" "`n`n * * * Error: $file `n`n"
				FailBuild $process.ExitCode
			}
		}
		else {
			# Windows is really bad starting new processes (too slow)
			$run = $cmd + " " + $params + ';$?'
			# instead, use Invoke-Expression to run commands or expressions on the local computer
			$result = Invoke-Expression -Command $run

			# if it returns an Array, could be an error or just multiple results
			$isArray = $result -is [array] -or ($result.GetType().Name -eq 'Object[]')
			# an array means something went wrong
			if($isArray){
				$text = ( $result -join "`n")
				Write-Log "ERROR" "`n`n* * * Error: $file `n$text `n`n"
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
	param(
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
	param(
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
		if ("Continue" -eq $VerbosePreference) {
			$debug = $True
		}

		if ($debug) {
		# v1: run each sql file one by one (this is slower but makes it easier to find errors)
		Get-Childitem -Path $dest -Recurse | ForEach-Object {
			# debug for Upgrade scrits (most probable failure point)
				# if("UpgradeScripts" -eq $folder){
				# 	Write-Log "INFO" "   . file: $_" -fgColor DarkYellow
				# }
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
	param( [string]$database )

	# check files names with spaces
	$filenameWithSpaces = Get-Childitem "* *.sql" -recurse
	if (0 -ne $filenameWithSpaces.length -or $filenameWithSpaces)
	{
		Write-Log "ERROR" "  File name contain invalid character space ' '" -fgColor red
		# show files with errors
		Write-Host ($filenameWithSpaces -join "`n")
		Write-Host "`n`n`n"
		FailBuild
	}

	# check files names with dots
	$filenameWithDots = Get-Childitem "*.*.sql" -recurse
	if (0 -ne $filenameWithDots.length -or $filenameWithDots)
	{
		Write-Log "ERROR" "  File name contain invalid character dot '.'" -fgColor red
		# show files with errors
		Write-Host ($filenameWithDots -join "`n")
		Write-Host "`n`n`n"
		FailBuild
	}

	# only check files in the DB build folders
	$exclude = @("*.sql","*.bat","*.ps1","*.zip","*.txt","*.md","*.cs",".git",".github",".vscode",".idea","*.json","*.nuspec")
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

# Delete temporary work files
function RemoveFile {
	param( [string]$fileName )

	If (Test-Path $fileName) {
		Remove-Item $fileName -Force | Out-Null
	}
}

# Delete existing Database (to create a new one)
function RemoveDatabase {
	param( [string]$database )

	Write-Log "INFO" "--- DROP database [$database] if exists ---" -fgColor DarkYellow -bgColor Black

	DeploySqlFolderFile -folder "Build" -file "DropDatabase.sql" -database "$database"
}

# Check if a Database Exists
function TestDatabaseExists {
	param( [string]$database )

	Write-Log "INFO" "--- Check if database [$database] exists ---" -fgColor DarkYellow -bgColor Black

	$tmpfile = Join-Path $tmpPath -ChildPath "query_output.txt"

	RemoveFile $tmpfile

	$sql = "SELECT LEFT(name, 50) AS dbName FROM master.sys.databases WHERE name = '" + $database +"'";
	$params = "-I -Q `"$sql`" -S $SQLServer $SQLcredential -r0 -I -m11 -b -V 1 -o $tmpfile"

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

# Create a new database + logins + linked server
# Important: DatabaseSetup.sql DROP DATABASE if already exists
function InitializeDatabase {
	param( [string]$database )
	# Initial Database setup:
	# ------------------------------------------------------------------
	# IMPORTANT: the DB has not been created yet, so we can't use -d database param

	# Create Logins
	Write-Log "INFO" "--- Create Login ---" -fgColor DarkYellow -bgColor Black
	DeploySqlFolderFile -folder "Build" -file "create-login.sql" -database ""

	# Create Linked Server
	# Write-Log "INFO" "--- Create Linked Server ---" -fgColor DarkYellow -bgColor Black
	# DeploySqlFolderFile -folder "Build" -file "create-linked-server.sql" -database ""

	# Create Database now
	Write-Log "INFO" "--- Create Database $SQLDBName ---" -fgColor DarkYellow -bgColor Black
	DeploySqlFolderFile -folder "Build" -file "DatabaseSetup.sql" -database ""
}

# Make sure the dbo.Provision(*) sprocs exist
function InitializeProvisionSproc {
	param( [string]$database )
	# we need to specify the -d database param here

	Write-Log "INFO" "--- Create Provision Procedures ---" -fgColor DarkYellow -bgColor Black

	DeploySqlFolderFile -folder "Build" -file "001_ProvisionScalarFunction.sql" -database $database
	DeploySqlFolderFile -folder "Build" -file "001_ProvisionTableFunction.sql" -database $database
	DeploySqlFolderFile -folder "Build" -file "001_ProvisionSproc.sql" -database $database
	DeploySqlFolderFile -folder "Build" -file "001_ProvisionView.sql" -database $database
}

# Prepare Unit Test Framework
function InitializetSQLt {
	param( [string]$database )
	# we need to specify the -d database param here

	Write-Log "INFO" "--- Create tSQLt unit test framework ---" -fgColor DarkYellow -bgColor Black

	DeploySqlFolderFile -folder "UnitTests" -file "01_PrepareServer.sql" -database $database
	DeploySqlFolderFile -folder "UnitTests" -file "02_tSQLt_class.sql" -database $database
	DeploySqlFolderFile -folder "UnitTests" -file "03_RunTests.sql" -database $database
}

# Set parameters as global variables (since they don't change it, so we can use it everywhere)
function SetVariables {
	param(
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

# Create a new database
function NewDatabase {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Server,
		[Parameter(Mandatory=$true)]
		[string]$Database,
		[string]$Username,
		[string]$Password,
		[System.Boolean]$Force = $False
	)
	# set default global variables so we don't need to send it every time
	SetVariables -Server $Server -Database $Database -User $Username -Pass $Password

	Write-Log "INFO" " "
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" "    [Create Database]   server: $SQLServer   database: $SQLDBName" -fgColor DarkGreen
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" " "

	# check for invalid file names (that could break the build)
	ValidateFileNames

	# make sure we have the tools we need installed:
	FindSqlTools

	# Remove Database if Exists
	if ($Force) {
		RemoveDatabase -database $SQLDBName
	 }

	# Check if Database Exists
	$dbExists = TestDatabaseExists -database "$SQLDBName"
	if ( $dbExists ) {
		Write-Log "ERROR" "  Database [$SQLDBName] already exists! Drop it first." -fgColor Red
		FailBuild
	}

	#benchmark
	$sw = [system.diagnostics.stopwatch]::StartNew()
	$startTime =  Get-Date

	# create logins, linked server and Database (IMPORTANT: don't sent the Database name here!)
	InitializeDatabase -database ""

	# make sure the dbo.Provision(*) sprocs exist
	InitializeProvisionSproc -database "$SQLDBName"

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

	# ---------------------------------------------------------------------------------------------------
	# Build data folders
	Write-Log "INFO" "--- Create Data ---" -fgColor DarkYellow -bgColor Black

	$DataDefault = Join-Path "Data" -ChildPath "Default"
	$DataTestData = Join-Path "Data" -ChildPath "TestData"

	DeploySqlFolder -folder $DataDefault -database "$SQLDBName"
	DeploySqlFolder -folder $DataTestData -database "$SQLDBName"

	# DB Build Process ends here.
	# ---------------------------------------------------------------------------------------------------

	# benchmark
	$sw.Stop(); $total = $sw.Elapsed; $sw.Reset();
	$endTime =  Get-Date

	Write-Log "INFO" " "
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" "    [Database Created]    Server: $SQLServer    Database: $SQLDBName" -fgColor DarkGreen
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" " "
	Write-Log "INFO" " ... Benchmark: " -fgColor DarkCyan
	Write-Log "INFO" " ...   Total Time: $total" -fgColor DarkCyan
	Write-Log "INFO" " ...   Total Files: $totalFiles / $subtotalFiles" -fgColor DarkCyan
	Write-Log "INFO" " ...   Start: $startTime" -fgColor DarkCyan
	Write-Log "INFO" " ...   Stop : $endTime" -fgColor DarkCyan
}

# Upgrade an existing database, (DB must already exists)
function UpdateDatabase {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Server,
		[Parameter(Mandatory=$true)]
		[string]$Database,
		[string]$Username,
		[string]$Password
	)

	# set default global variables so we don't need to send it every time
	SetVariables -Server $Server -Database $Database -User $Username -Pass $Password

	Write-Log "INFO" " "
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" "    [Upgrade Database]    Server: $SQLServer    Database: $SQLDBName" -fgColor DarkGreen
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" " "

	# check for invalid file names (that could break the build)
	ValidateFileNames

	# make sure we have the tools we need installed:
	FindSqlTools

	# Check if Database Exists
	$dbExists = TestDatabaseExists -database "$SQLDBName"
	if (-not $dbExists ) {
		Write-Log "ERRROR" "  Database [$SQLDBName] NOT found. Create the database first."
		FailBuild
	}

	# benchmark
	$sw = [system.diagnostics.stopwatch]::StartNew();
	$startTime =  Get-Date

	# ---------------------------------------------------------------------------------------------------
	# DB Build Process starts here.
	# To update the database we run the scrits in those folders (in order):

	Write-Log "INFO" "--- Deploy Upgrade Folders ---" -fgColor DarkYellow -bgColor Black

	DeploySqlFolder -folder "UpgradeScripts" -database "$SQLDBName"
	DeploySqlFolder -folder "Functions" -database "$SQLDBName"
	DeploySqlFolder -folder "Views" -database "$SQLDBName"
	DeploySqlFolder -folder "StoredProcedures" -database "$SQLDBName"

	# DB Build Process ends here.
	# ---------------------------------------------------------------------------------------------------

	# benchmark
	$sw.Stop(); $total = $sw.Elapsed; $sw.Reset();
	$endTime =  Get-Date

	Write-Log "INFO" " "
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" "    [Database Upgraded]    Server: $SQLServer    Database: $SQLDBName" -fgColor DarkGreen
	Write-Log "INFO" "-----------------------------------------------------------------------"
	Write-Log "INFO" " "
	Write-Log "INFO" " ... Benchmark: " -fgColor DarkCyan
	Write-Log "INFO" " ...   Total Time: $total" -fgColor DarkCyan
	Write-Log "INFO" " ...   Total Files: $totalFiles / $subtotalFiles" -fgColor DarkCyan
	Write-Log "INFO" " ...   Start: $startTime" -fgColor DarkCyan
	Write-Log "INFO" " ...   Stop : $endTime" -fgColor DarkCyan
}

# ---------------------------------------------------------------------------------------------------