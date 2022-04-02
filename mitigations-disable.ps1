$IsAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator");
Write-Host 'Admin: ' $IsAdmin
if (!$IsAdmin)
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	exit; 
}
Write-Host 'Disable mitigations...'
$MitigationList = [System.Collections.ArrayList]::new()
$MitigationList.Add("AllowStoreSignedBinaries")
$MitigationList.Add("AllowThreadsToOptOut")
$MitigationList.Add("AuditChildProcess")
$MitigationList.Add("AuditDynamicCode")
$MitigationList.Add("AuditEnableExportAddressFilter")
$MitigationList.Add("AuditEnableExportAddressFilterPlus")
$MitigationList.Add("AuditEnableImportAddressFilter")
$MitigationList.Add("AuditEnableRopCallerCheck")
$MitigationList.Add("AuditEnableRopSimExec")
$MitigationList.Add("AuditEnableRopStackPivot")
$MitigationList.Add("AuditFont")
$MitigationList.Add("AuditLowLabelImageLoads")
$MitigationList.Add("AuditMicrosoftSigned")
$MitigationList.Add("AuditPreferSystem32")
$MitigationList.Add("AuditRemoteImageLoads")
$MitigationList.Add("AuditSEHOP")
$MitigationList.Add("AuditStoreSigned")
$MitigationList.Add("AuditSystemCall")
$MitigationList.Add("AuditUserShadowStack")
$MitigationList.Add("BlockDynamicCode")
$MitigationList.Add("BlockLowLabelImageLoads")
$MitigationList.Add("BlockRemoteImageLoads")
$MitigationList.Add("BottomUp")
$MitigationList.Add("CFG")
$MitigationList.Add("DEP")
$MitigationList.Add("DisableExtensionPoints")
$MitigationList.Add("DisableNonSystemFonts")
$MitigationList.Add("DisableWin32kSystemCalls")
$MitigationList.Add("DisallowChildProcessCreation")
$MitigationList.Add("EmulateAtlThunks")
$MitigationList.Add("EnableExportAddressFilter")
$MitigationList.Add("EnableExportAddressFilterPlus")
$MitigationList.Add("EnableImportAddressFilter")
$MitigationList.Add("EnableRopCallerCheck")
$MitigationList.Add("EnableRopSimExec")
$MitigationList.Add("EnableRopStackPivot")
$MitigationList.Add("EnforceModuleDependencySigning")
$MitigationList.Add("ForceRelocateImages")
$MitigationList.Add("HighEntropy")
$MitigationList.Add("MicrosoftSignedOnly")
$MitigationList.Add("PreferSystem32")
$MitigationList.Add("RequireInfo")
$MitigationList.Add("SEHOP")
$MitigationList.Add("SEHOPTelemetry")
$MitigationList.Add("StrictCFG")
$MitigationList.Add("StrictHandle")
$MitigationList.Add("SuppressExports")
$MitigationList.Add("TerminateOnError")
$MitigationList.Add("UserShadowStack")
$MitigationList.Add("UserShadowStackStrictMode")
foreach($mitigation in $MitigationList)
{
	Try
	{
		Write-Host "Mitigation: $mitigation"
		Set-ProcessMitigation -System -Disable $mitigation
	}
	Catch
	{
		$Message=$_
		Write-Host "Exception: $Message"
	}
}
Read-Host -Prompt "Press Enter to exit..."