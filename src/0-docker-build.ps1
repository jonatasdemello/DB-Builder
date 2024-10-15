<#
.SYNOPSIS
	Create Database Using Powershell
.DESCRIPTION
	Optional Parameters:
	-run    runs the image after building
	-clean  deletes the image and container after building
.EXAMPLE
	docker-build.ps1 -run -clean
#>
[CmdletBinding()]
param (
	[Parameter()]
	[switch]$run,
	[Parameter()]
	[switch]$clean
)

# build the database only
docker image build --progress=plain -t local_db:1.0.0 -f dockerfile .

if ($run) {
	# run the container and keep runnning
	docker run -p 1433:1433 --name localdb -it local_db:1.0.0
}

if ($clean) {
	# REMOVE CONTAINER & IMAGE
	docker container rm localdb -f
	docker image rm local_db:1.0.0 -f
}
