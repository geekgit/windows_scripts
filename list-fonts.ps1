function get-fonts
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
	$InstalledFontCollection = New-Object System.Drawing.Text.InstalledFontCollection
    $FontFamilies=$InstalledFontCollection.Families
    $FontArrayList=New-Object System.Collections.ArrayList
    $FontFamilies.'Name' | %{$FontArrayList.Add($_)} | Out-Null
    return $FontArrayList
}
function list-fonts
{
    $FontArrayList=get-fonts
    foreach ($FontName in $FontArrayList)
    {
        Write-Host """$FontName"""
    }
}
list-fonts