function Test-Reg
{
	$RPath=$args[0]
	$flag=Test-Path "Registry::$RPath"
	if($flag)
	{
	Write-Host "$RPath exists"
	}
	else
	{
	Write-Host "Create $RPath..."
	New-Item "Registry::$RPath"
	}
}
function Get-UserChoice-ProgId
{
	$Ext=$args[0]
	$RPath="Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Ext\UserChoice"
	$ID=(Get-ItemProperty $RPath).'ProgId'
	return $ID
}
function value-work
{
	$RPath=$args[0]
	$RName=$args[1]
	$RValue=$args[2]
	$RType=$args[3]
	$IP=(Get-ItemProperty -Path "Registry::$RPath" -Name $RName -errorAction SilentlyContinue)
	if($IP)
	{
		Write-Host "Registry ""$RPath"", Property ""$RName"" exists, overwriting..."
		Set-ItemProperty -Path "Registry::$RPath" -Name "$RName" -Value "$RValue"
	}
	else
	{
		Write-Host "Registry path ""$RPath"", Property ""$RName"" create..."
		New-ItemProperty -Path "Registry::$RPath" -Name "$RName" -Value "$RValue"
	}
}
function custom-entry
{
	$Ext=$args[0]
	$Cmd=$args[1]
	$Name=$args[2]
	$CodeName=$args[3]
	$Icon=$args[4]
	Write-Host "Ext: $Ext"
	Write-Host "Cmd: $Cmd"
	Write-Host "Name: $Name"
	Write-Host "CodeName: $CodeName"
	Write-Host "Icon: $Icon"
	$CustomCommand=$Cmd
	Write-Host $CustomCommand
	$ID=$(Get-UserChoice-ProgId $Ext)
	Write-Host "$Ext UserChoice ProgId=$ID"
	$reg1="HKEY_CURRENT_USER\Software\Classes\$ID"
	$reg2="HKEY_CURRENT_USER\Software\Classes\$ID\shell"
	$reg3="HKEY_CURRENT_USER\Software\Classes\$ID\shell\$CodeName"
	$reg4="HKEY_CURRENT_USER\Software\Classes\$ID\shell\$CodeName\command"
	Test-Reg $reg1
	Test-Reg $reg2
	Test-Reg $reg3
	Test-Reg $reg4
	value-work $reg3 '(default)' $Name
	value-work $reg3 'Icon' $Icon
	value-work $reg4 '(default)' $CustomCommand
}
$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'VLC 3.0 menu entry'
Try
{
	$Vlc3Ext=".mkv"
	$Vlc3Cmd="""C:\vlc-3.0.0-git\vlc.exe"" ""%1"""
	$Vlc3Name="vlc 3.0 (git)"
	$Vlc3CodeName="vlc3git"
	$Vlc3Icon="C:\vlc-3.0.0-git\vlc.exe,0"
	custom-entry $Vlc3Ext $Vlc3Cmd $Vlc3Name $Vlc3CodeName $Vlc3Icon
	$madVrExt=".mkv"
	$madVrCmd="""C:\MPC-HC-madVR\mpc-hc.exe"" ""%1"""
	$madVrName="MPC-HC + madVR"
	$madVrCodeName="mpchcmadVR"
	$madVrIcon="C:\madVR\madHcCtrl.exe,0"
	custom-entry $madVrExt $madVrCmd $madVrName $madVrCodeName $madVrIcon
	$Vlc2Ext=".mkv"
	$Vlc2Cmd="""C:\vlc-2\vlc.exe"" ""%1"""
	$Vlc2Name="vlc 2.2.1 (stable)"
	$Vlc2CodeName="vlc2stable"
	$Vlc2Icon="C:\vlc-2\vlc.exe,0"
	custom-entry $Vlc2Ext $Vlc2Cmd $Vlc2Name $Vlc2CodeName $Vlc2Icon
}
Catch
{
	$Message=$_.Exception.Message
	Write-Host "Error: $Message"
	$Fail=$_.Exception.ItemName
	Write-Host "Failed: $Fail"
}
Read-Host -Prompt "Press Enter to exit..."
