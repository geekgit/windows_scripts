$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'HDD Fun...'
Try
{
	Write-Host 'Logical Disk:'
	Get-WmiObject Win32_LogicalDisk
	Write-Host 'Physical Disk:' 
	Get-PhysicalDisk
	Write-Host 'MSStorageDriver_FailurePredictStatus'
	Get-WmiObject -Namespace Root\WMI -Class MSStorageDriver_FailurePredictStatus
}
Catch
{
	Write-Host "Error!"
}
Read-Host -Prompt "Press Enter to exit..."