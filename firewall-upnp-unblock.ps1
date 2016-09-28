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
	Write-Host "Unblocking remote TCP port 2869 (outbound)"
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_TCP2869_Outbound_Remote" | Out-Null
	Write-Host "Unblocking remote TCP port 5357 (outbound)"
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_TCP5357_Outbound_Remote" | Out-Null
	Write-Host "Unblocking remote TCP port 5358 (outbound)"
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_TCP5358_Outbound_Remote" | Out-Null
	Write-Host "Unblocking remote UDP port 5355 (outbound)"
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_UDP5355_Outbound_Remote" | Out-Null
	Write-Host "Unblocking remote UDP port 3702 (outbound)"
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_UDP3702_Outbound_Remote" | Out-Null
	Write-Host "Unblocking remote UDP port 1900 (outbound)"
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_UPnP_UDP1900_Outbound_Remote" | Out-Null
	
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."