$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host "Start DNSCrypt service..."
Try
{
	Get-Service dnscrypt-proxy | Start-Service | out-null
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."