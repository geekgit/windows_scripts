function Show-SMART-Value ($SMARTData,$tag)
{
	$arr=$SMARTData.Split("`r`n")
	foreach($line in $arr)
	{
		if($line.Contains($tag))
		{
		#Write-Host $line
		$separator="`t","`r","`n"," "
		$option = [System.StringSplitOptions]::RemoveEmptyEntries
		$sub_arr=$line.Split($separator,$option)
		<# foreach($sub_line in $sub_arr)
		{
			Write-Host '< ' $sub_line ' >'
		} #>
		$ReturnValueData=$sub_arr[9]
		return $ReturnValueData;
		}
	}
	return 'N\A'
}
$SmartMonToolsPath='C:\Program Files\smartmontools\bin\smartctl.exe'
$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'HDD Fun...'
Try
{
	Write-Host 'Logical Disk:'
	Get-WmiObject Win32_LogicalDisk
	Write-Host 'Physical Disk:' 
	Get-PhysicalDisk
	Write-Host 'MSStorageDriver_FailurePredictStatus'
	Get-WmiObject -Namespace Root\WMI -Class MSStorageDriver_FailurePredictStatus
	Write-Host 'smartctl /dev/sda'
	$output=(& $SmartMonToolsPath -A /dev/sda)
	$AirflowCelsius=Show-SMART-Value $output 'Airflow_Temperature'
	Write-Host 'Airflow Temperature: +' $AirflowCelsius 'C'
	$TemperatureCelsius=Show-SMART-Value $output 'Temperature_Celsius'
	Write-Host 'Temperature: +' $TemperatureCelsius 'C'
	$ReallocatedSectors=Show-SMART-Value $output 'Reallocated_Sector_Ct'
	Write-Host 'Reallocated Sectors:' $ReallocatedSectors
	$PendingSectors=Show-SMART-Value $output 'Current_Pending_Sector'
	Write-Host 'Pending Sectors:' $PendingSectors
	
}
Catch
{
	Write-Host "Error!"
	Write-Host $Error
}
Read-Host -Prompt "Press Enter to exit..."