$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Enable Hyper-V...'
Try
{
	Write-Host "dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All"
	dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All | out-null
}
Catch
{
	Write-Host $_
}
Try
{
	Write-Host "bcdedit /set hypervisorlaunchtype auto"
	bcdedit /set hypervisorlaunchtype auto | out-null
}
Catch
{
	Write-Host $_
}
Read-Host -Prompt "Press Enter to exit..."