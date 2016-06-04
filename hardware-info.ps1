$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Try
{
	Write-Host 'Hardware Info'
    $SystemName=Get-CimInstance CIM_ComputerSystem | Select -ExpandProperty 'Name'
    $SystemVendor=Get-CimInstance CIM_ComputerSystem | Select -ExpandProperty 'Manufacturer'
    $SystemModel=Get-CimInstance CIM_ComputerSystem | Select -ExpandProperty 'Model'
    $CPU=Get-CimInstance CIM_Processor | Select -ExpandProperty 'Name'
    $RAM=[long](Get-CimInstance CIM_ComputerSystem | Select -ExpandProperty 'TotalPhysicalMemory')/1048576L
    $RAM=[math]::Round($RAM)
    $GPUArray=Get-CimInstance CIM_VideoController
    $GPUCount=Get-CimInstance CIM_VideoController | measure | Select -ExpandProperty 'Count'
    Write-Host "System name: $SystemName"
    Write-Host "System vendor: $SystemVendor"
    Write-Host "System model: $SystemModel"
    Write-Host "CPU: $CPU"
    Write-Host "RAM: ~$RAM MB"
    for($i=0;$i -lt $GPUCount;++$i)
    {
        $CurrentGPU=$GPUArray[$i]
        $GPUName=$CurrentGPU | Select -ExpandProperty 'Name'
        $DriverDate=$CurrentGPU | Select -ExpandProperty 'DriverDate'
        $DriverVersion=$CurrentGPU | Select -ExpandProperty 'DriverVersion'
        $VRAM=[long]($CurrentGPU | Select -ExpandProperty 'AdapterRAM') / 1048576L
        Write-Host "GPU #${i}: $GPUName"
        Write-Host "Driver: $DriverVersion ($DriverDate)"
        Write-Host "VRAM: ~${VRAM} MB"
    }
}
Catch
{
	Write-Host "Error!"
	Write-Host $Error
}
Read-Host -Prompt "Press Enter to exit..."