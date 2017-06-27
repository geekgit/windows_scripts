$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Firewall Samba Block...'
Try
{
	Write-Host "Blocking local TCP ports 1024-1035..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_1024_1035_TCP_Local" -Direction Outbound –LocalPort 1024-1035 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking local UDP ports 1024-1035..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_1024_1035_UDP_Local" -Direction Outbound –LocalPort 1024-1035 -Protocol UDP -Action Block | Out-Null
	Write-Host "Blocking remote TCP ports 1024-1035..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_1024_1035_TCP_Remote" -Direction Outbound –RemotePort 1024-1035 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking remote UDP ports 1024-1035..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_1024_1035_UDP_Remote" -Direction Outbound –RemotePort 1024-1035 -Protocol UDP -Action Block | Out-Null
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."