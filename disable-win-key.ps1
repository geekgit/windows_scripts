$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Disable Windows Key...'
Try
{
	Get-ChildItem -Path 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout'
	# 00000000000000000300000000005BE000005CE000000000
	New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout' -Name 'Scancode Map' -PropertyType Binary -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x5B,0xE0,0x00,0x00,0x5C,0xE0,0x00,0x00,0x00,0x00))
}
Catch
{
}
Read-Host -Prompt "Press Enter to exit..."