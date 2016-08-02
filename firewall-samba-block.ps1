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
	Write-Host "Blocking local TCP ports 137-139, 445..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_Samba_TCP_Local" -Direction Outbound –LocalPort 137-139,445 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking local UDP ports 137-139, 445..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_Samba_UDP_Local" -Direction Outbound –LocalPort 137-139,445 -Protocol UDP -Action Block | Out-Null
	Write-Host "Blocking remote TCP ports 137-139, 445..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_Samba_TCP_Remote" -Direction Outbound –RemotePort 137-139,445 -Protocol TCP -Action Block | Out-Null
	Write-Host "Blocking remote UDP ports 137-139, 445..."
	New-NetFirewallRule -DisplayName "PowerShell_Block_Samba_UDP_Remote" -Direction Outbound –RemotePort 137-139,445 -Protocol UDP -Action Block | Out-Null
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."