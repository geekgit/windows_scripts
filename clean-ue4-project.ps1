# Author: geekgit
# Date: 21.06.2017 0:17 UTC
# Last update: 21.06.2017 0:36 UTC
Try
{
$whiteList=New-Object System.Collections.ArrayList($null);
$whiteList.Add("content");
$whiteList.Add("config");
$whiteList.Add("intermediate");

$dirVar=(Get-ChildItem | ?{ $_.PSIsContainer}).Name;
Write-Host "Dir in project folder: ";

#just print info
ForEach ($currDir in $dirVar)
{
	$currDirLowercase=$currDir.ToLower();
	$flag=$whiteList.contains($currDirLowercase);
	Write-Host "Directory $currDir [$currDirLowercase], whitelist? $flag"
}

#clean
ForEach ($currDir in $dirVar)
{
	$currDirLowercase=$currDir.ToLower();
	$flag=$whiteList.contains($currDirLowercase);
	if(!$flag)
	{
	Write-Host "Delete $currDir..."
	Remove-Item .\$currDir -Force -Recurse
	}
}


}
Catch
{
	$Message=$_
	Write-Host "Exception: $Message"
}
Read-Host -Prompt "Press Enter to exit..."