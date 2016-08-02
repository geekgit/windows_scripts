$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host "Stop and disable NetBIOS service..."
Try
{
	Get-Service lmhosts | Stop-Service -PassThru | Set-Service -StartupType disabled | out-null
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."