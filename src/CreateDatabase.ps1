<#
.SYNOPSIS
   Create Local_DB Database Using Powershell
.DESCRIPTION
   For debug details, run with: -verbose
   Parameters:
      server: 127.0.0.1
      database: Local_DB
      username: <sqlUser>
      password: <sqlpassword>
.EXAMPLE
   CreateDatabase.ps1 -server 127.0.0.1 -database Local_DB -username <sqlUser> -password <sqlpassword>
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

NewDatabase -Server $Server -Database $Database -Username $Username -Password $Password -Force $Force

exit 0
