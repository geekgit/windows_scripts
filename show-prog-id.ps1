function id-work
{
	$Ext=$args[0]
	$IP=(Get-ItemProperty "Registry::HKEY_CLASSES_ROOT\$Ext")
	$ID=$IP.'(default)'
	Write-Host "$Ext ProgId=$ID"
}
$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'prog id'
Try
{
	id-work .mkv
	id-work .mp4
}
Catch
{
}
Read-Host -Prompt "Press Enter to exit..."
