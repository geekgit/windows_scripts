Try
{
$Layout=New-WinUserLanguageList "ru"
$Layout.Add("en-US")
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
