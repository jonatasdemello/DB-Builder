<#
.SYNOPSIS
   Upgrade Database Using Powershell
.DESCRIPTION
   For debug details, run with: -verbose
   Parameters:
      server: 127.0.0.1
      database: My_Local_DB
      username: <sqlUser>
      password: <sqlpassword>
.EXAMPLE
   Upgrade.ps1 -server 127.0.0.1 -database My_Local_DB -username <sqlUser> -password <sqlpassword>
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [Parameter(Mandatory=$true)]
    [string]$Database,
    [string]$Username,
    [string]$Password
)

# -----------------------------------------------------------------------------
# import main functions
. .\db-functions.ps1
# -----------------------------------------------------------------------------

UpdateDatabase -Server $Server -Database $Database -Username $Username -Password $Password

exit 0
