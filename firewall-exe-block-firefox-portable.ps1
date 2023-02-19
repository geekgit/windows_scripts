$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Block online access...'
Try
{
    $directory="C:\FirefoxPortable"
    $exename="Firefox.exe"
    $exepath=$directory+'\'+$exename
    $appname="Firefox"
	
    Write-Host "App: $appname"
    Write-Host "Exe Path: $exepath"
    
    $out="$appname Block $exename (out)"
    Write-Host "$out..."
	New-NetFirewallRule -DisplayName $out -Direction Outbound -Action Block -Profile Any -Enabled True -Program $exepath
    $in="$appname Block $exename (in)"
    Write-Host "$in..."
	New-NetFirewallRule -DisplayName $in -Direction Inbound -Action Block -Profile Any -Enabled True -Program $exepath
}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."