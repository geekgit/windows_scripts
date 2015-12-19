$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Enable Windows Key...'
Try
{
	Get-ChildItem -Path 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout\Scancode Map'
	Remove-Item -Path 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout\Scancode Map'
}
Catch
{
}
Read-Host -Prompt "Press Enter to exit..."