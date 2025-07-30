<#
.SYNOPSIS
   Create and Upgrade Local_DB Database Using Powershell - used in the Dockerfile
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
    [switch]$Force
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
