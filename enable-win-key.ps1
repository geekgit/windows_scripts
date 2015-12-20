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
	$PathToReg='HKLM:\System\CurrentControlSet\Control\Keyboard Layout'
	Write-Host $PathToReg
	$Var=(Get-ItemProperty $PathToReg).'Scancode Map'
	Write-Host $Var
	Get-Item $PathToReg | Remove-ItemProperty -name 'Scancode Map'
}
Catch
{
}
Read-Host -Prompt "Press Enter to exit..."