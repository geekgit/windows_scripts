$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Firewall UPnP Block...'
Try
{
	Write-Host "Blocking remote TCP port 2869 (outbound)"
	New-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_TCP2869_Outbound_Remote" -Direction Outbound –RemotePort 2869 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking remote TCP port 5357 (outbound)"
	New-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_TCP5357_Outbound_Remote" -Direction Outbound –RemotePort 5357 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking remote TCP port 5358 (outbound)"
	New-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_TCP5358_Outbound_Remote" -Direction Outbound –RemotePort 5358 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking remote UDP port 5355 (outbound)"
	New-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_UDP5355_Outbound_Remote" -Direction Outbound –RemotePort 5355 -Protocol UDP -Action Block | Out-Null
	Write-Host "Blocking remote UDP port 3702 (outbound)"
	New-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_UDP3702_Outbound_Remote" -Direction Outbound –RemotePort 3702 -Protocol UDP -Action Block | Out-Null
	Write-Host "Blocking remote UDP port 1900 (outbound)"
	New-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_UDP1900_Outbound_Remote" -Direction Outbound –RemotePort 1900 -Protocol UDP -Action Block | Out-Null
	
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."