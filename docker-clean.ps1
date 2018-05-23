function PruneSystem
{
	Try
	{
	Write-Host "docker system prune -f"
	& docker.exe system prune -f
	}
	Catch
	{
		$Message=$_
		Write-Host "Exception: $Message"
	}
}
function PruneVolume
{
	Try
	{
	Write-Host "docker volume prune -f"
	& docker.exe volume prune -f
	}
	Catch
	{
		$Message=$_
		Write-Host "Exception: $Message"
	}
}
function CleanRM
{
	Try
	{
		$ToRM=$(& docker.exe ps -aq)
		
		$ToRM.Split(" ") | ForEach {
			Write-Host "docker rm $_"
			& docker.exe rm $_
		}
	}
	Catch
	{
		$Message=$_
		#Write-Host "Exception: $Message"
	}
}

function CleanRMI
{
	Try
	{
		$ToRMI=$(& docker.exe images --format "{{.ID}}")
	
		$ToRMI.Split(" ") | ForEach {
			Write-Host "docker rmi $_"
			& docker.exe rmi $_
		}
	}
	Catch
	{
		$Message=$_
		#Write-Host "Exception: $Message"
	}
}

$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}

PruneSystem
PruneVolume
CleanRM
CleanRMI

Read-Host -Prompt "Press Enter to exit..."