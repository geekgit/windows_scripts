Param (
    [string]$Subtitle=""
);
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
        #Write-Host "Subtitle line: $SubtitleLine" -ForegroundColor "yellow"
        if($SubtitleLine.Contains("Style:") -and $SubtitleLine.Contains(","))
        {
            $Elements=$SubtitleLine -split ":"
            if($Elements.Count -ge 2)
            {
                $Style=$Elements[1]
                $Style=$Style.trim()
                Write-Host "Style: $Style" -ForegroundColor "yellow"
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
        Write-Host "* Raw font: $Font" -ForegroundColor "yellow"
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
    
    Write-Host "=== Parsed & sorted unique fonts:" -ForegroundColor "yellow"
    foreach($StyleFont in $StyleFontArrayList)
    {
        Write-Host "* $StyleFont" -ForegroundColor "yellow"
    }
    $StyleFontArrayList.Add("DummyFont0") | Out-Null
    $StyleFontArrayList.Add("DummyFont1") | Out-Null
    return $StyleFontArrayList
}
function print-subtitle-fonts
{
    $Filename=$args[0]
    Write-Host "File: $Filename"
    $Subtitle = [IO.File]::ReadAllLines($Filename)
    $SubtitleStyles=parse-styles $Subtitle
    $SubtitleFonts=parse-fonts $SubtitleStyles
    for($i=0; $i -le $SubtitleFonts.Count-3; ++$i)
    {
        $Font=$SubtitleFonts[$i]
        Write-Host "Font #$i : $Font"
    }
	Write-Host "Check availability:"
    check-availability $SubtitleFonts
}
function check-availability
{
    Write-Host $Type
    $SubFonts=$args[0]
    $AllFonts=get-fonts
    for($i=0; $i -le $SubFonts.Count-3; ++$i)
    {
        $Font=$SubFonts[$i]
        if($AllFonts.Contains($Font))
        {
            Write-Host "$Font : yes" -ForegroundColor "green"
        }
        else
        {
            Write-Host "$Font : no" -ForegroundColor "red"
        }
    }
}
function script-path
{
    $NameList=New-Object System.Collections.ArrayList
    $Name1="$($MyInvocation.MyCommand.Path)"
    $Name2="$($MyInvocation.ScriptName)"
    $NameList.Add("$Name1") | Out-Null
    $NameList.Add("$Name2") | Out-Null
    $max=0
    $Name=""
    foreach($name in $NameList)
    {
        $length=$name.Length
        if($length -gt $max)
        {
            $max=$length
            $Name=$name
        }
    }
    $ReturnResult=""
    if($max -eq 0)
    {
        $ReturnResult="N/A"
    }
    else
    {
        $ReturnResult="$Name"
    }
    return "$ReturnResult"
}
function script-basename
{
    $Path=script-path
    $Basename=split-path $Path -leaf
    return "$Basename"    
}
function script-info
{
	$ScriptPath=script-path
    $ScriptBasename=script-basename
    Write-Host "Script path: '$ScriptPath'" -foregroundcolor "yellow"
    Write-Host "Script base name: '$ScriptBasename'" -foregroundcolor "yellow"
}

function print-help
{
    $ScriptBasename=script-basename
    Write-Host "Usage: .\$ScriptBasename -Subtitle <filename>" -foregroundcolor "magenta"
    Write-Host "Example 1: .\$ScriptBasename -Subtitle op.ass"  -foregroundcolor "magenta"
    Write-Host "Example 2: .\$ScriptBasename -Subtitle ""some sub file.ass"""  -foregroundcolor "magenta"
}


try
{
    script-info
   if ($Subtitle -eq "")
    {
    Write-Host "No arguments!" -foregroundcolor "red"
    print-help
    }
    else
    {
    Write-Host "OK" -foregroundcolor "yellow"
    Write-Host "Subtitle: $Subtitle" -foregroundcolor "yellow"
    $Exist=Test-Path $Subtitle
        if($Exist -eq $false)
        {
        Write-Host "$Subtitle not exist!" -ForegroundColor "red"
        }
        else
        {
        Write-Host "$Subtitle exist." -ForegroundColor "green"
        print-subtitle-fonts "$Subtitle"
        }
    }
}
catch
{
    $Message=$_.Exception.Message
	Write-Host "try-catch exception: $Message" -foregroundcolor "red"
}