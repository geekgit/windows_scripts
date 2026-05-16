$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host '(24H2) Samba Fix...'
Try
{
	Write-Host "[Client] Enable Insecure Guest Logons: true"
	Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force
	Write-Host "[Client] Require Security Signature: false"
	Set-SmbClientConfiguration -RequireSecuritySignature $false -Force
	Write-Host "[Server] Require SecurityS ignature: false"
	Set-SmbServerConfiguration -RequireSecuritySignature $false -Force
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."