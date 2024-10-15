<#
.SYNOPSIS
   Create and Upgrade CC3 Database Using Powershell
.DESCRIPTION
   For debug details, run with: -verbose
   Parameters:
      server: 127.0.0.1
      database: Local_DB
      username: <sqlUser>
      password: <sqlpassword>
.EXAMPLE
   DockerBuild.ps1 -server 127.0.0.1 -database Local_DB -username <sqlUser> -password <sqlpassword>
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [Parameter(Mandatory=$true)]
    [string]$Database,
    [string]$Username,
    [string]$Password,
    [System.Boolean]$Force = $False
)

# -----------------------------------------------------------------------------
# import main functions
. .\db-functions.ps1
# -----------------------------------------------------------------------------

# note: since we are using it for docker builds, we need to start SQL Server
StartSQLServer

# create a new database first
NewDatabase -Server $Server -Database $Database -Username $Username -Password $Password -Force $Force

# upgrade it after
UpdateDatabase -Server $Server -Database $Database -Username $Username -Password $Password

exit 0
