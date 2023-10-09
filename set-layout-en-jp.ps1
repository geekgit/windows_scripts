Try
{
$Layout=New-WinUserLanguageList "en-US"
$Layout.Add("ja")
Set-WinUserLanguageList $Layout -Force
}
Catch
{
	$Message=$_.Exception.Message
	Write-Host "Error: $Message"
	$Fail=$_.Exception.ItemName
	Write-Host "Failed: $Fail"
}
Read-Host -Prompt "Press Enter to exit..."
