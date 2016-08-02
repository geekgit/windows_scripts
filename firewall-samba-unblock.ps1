$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Firewall Samba Unblock...'
Try
{
	Write-Host "Unblocking local TCP ports 137-139, 445..."
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_Samba_TCP_Local" | Out-Null
	Write-Host "Unblocking local UDP ports 137-139, 445..."
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_Samba_UDP_Local" | Out-Null
	Write-Host "Unblocking remote TCP ports 137-139, 445..."
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_Samba_TCP_Remote" | Out-Null
	Write-Host "Unblocking remote UDP ports 137-139, 445..."
	Remove-NetFirewallRule -DisplayName "PowerShell_Block_Samba_UDP_Remote" | Out-Null
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."