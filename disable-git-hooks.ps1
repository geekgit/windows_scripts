$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Write-Host 'Disable git hooks (User)...'
	git config --global core.hooksPath c:\nul
	Write-Host 'Switch to Admin...'
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Disable git hooks (Admin)...'
Try
{
	git config --global core.hooksPath c:\nul
}
Catch
{
}
Read-Host -Prompt "Press Enter to exit..."