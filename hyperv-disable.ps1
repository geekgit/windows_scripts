$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Disable Hyper-V...'
Try
{
	Write-Host "dism.exe /Online /Disable-Feature:Microsoft-Hyper-V"
	dism.exe /Online /Disable-Feature:Microsoft-Hyper-V | out-null
}
Catch
{
	Write-Host $_
}
Try
{
	Write-Host "bcdedit /set hypervisorlaunchtype off"
	bcdedit /set hypervisorlaunchtype off | out-null
}
Catch
{
	Write-Host $_
}
Read-Host -Prompt "Press Enter to exit..."