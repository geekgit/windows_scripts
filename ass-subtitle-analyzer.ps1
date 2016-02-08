function get-fonts
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
	$InstalledFontCollection = New-Object System.Drawing.Text.InstalledFontCollection
    $FontFamilies=$InstalledFontCollection.Families
    $FontArrayList=New-Object System.Collections.ArrayList
    $FontFamilies.'Name' | %{$FontArrayList.Add($_)} | Out-Null
    $FontArrayList.Sort()
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
function parse-styles
{
    $SubtitleText=$args[0]
    $StyleArrayList=New-Object System.Collections.ArrayList
    foreach($SubtitleLine in $SubtitleText)
    {
        if($SubtitleLine.Contains("Style:") -and $SubtitleLine.Contains(","))
        {
            $Elements=$SubtitleLine -split ":"
            if($Elements.Count -ge 2)
            {
                $Style=$Elements[1]
                $Style=$Style.trim()
                $StyleArrayList.Add($Style) | Out-Null
            }
        }
    }
    return $StyleArrayList
}
function parse-fonts
{
    $Styles=$args[0]
    $StyleFontArrayList=New-Object System.Collections.ArrayList
    foreach($Style in $Styles)
    {
        $Elements=$Style -split ","
        if($Elements.Count -ge 2)
        {
        $Font=$Elements[1]
        $Font=$Font.trim()
            if($StyleFontArrayList.Contains($Font))
            {
            ;
            }
            else
            {
            $StyleFontArrayList.Add($Font) | Out-Null
            }
        }
    }
    $StyleFontArrayList.Sort()
    return $StyleFontArrayList
}
function print-subtitle-fonts
{
    $Filename=$args[0]
    Write-Host "File: $Filename"
    $Subtitle = [IO.File]::ReadAllLines($Filename)
    $SubtitleStyles=parse-styles $Subtitle
    $SubtitleFonts=parse-fonts $SubtitleStyles
    for($i=0; $i -le $SubtitleFonts.Count-1; ++$i)
    {
        $Font=$SubtitleFonts[$i]
        Write-Host "Font #$($i): ""$($Font)"""
    }
	Write-Host "Check availability:"
    check-availability $SubtitleFonts
}
function check-availability
{
    $SubFonts=$args[0]
    $AllFonts=get-fonts
    for($i=0; $i -le $SubFonts.Count-1; ++$i)
    {
        $Font=$SubFonts[$i]
        if($AllFonts.Contains($Font))
        {
            Write-Host "$($Font): yes"  -foregroundcolor "green"
        }
        else
        {
            Write-Host "$($Font): no" -foregroundcolor "red"
        }
    }
}
$File=$args[0]
print-subtitle-fonts $File