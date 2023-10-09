Try
{
$Layout=New-WinUserLanguageList "en-US"
$Layout.Add("ru")
$Layout.Add("ja")
$Layout.Add("zh-Hans-CN")
$Layout.Add("ko")
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
