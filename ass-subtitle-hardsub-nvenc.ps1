function Escape-FfmpegFilterPath {
    param([string]$Path)

    $p = $Path -replace '\\', '\\\\'
    $p = $p -replace ':', '\:'
    $p = $p -replace '\[', '\['
    $p = $p -replace '\]', '\]'
    $p = $p -replace ';', '\;'
    return $p
}

$root = $PSScriptRoot
$fontsDir = Escape-FfmpegFilterPath (Join-Path $root "fonts")
$assFiles = Get-ChildItem -LiteralPath $root -File | Where-Object Extension -eq ".ass"

Get-ChildItem -LiteralPath $root -File | Where-Object Extension -eq ".mkv" | ForEach-Object {
    $mkv = $_
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($mkv.Name)

    $exactAss = Join-Path $root ($stem + ".ass")

    if (Test-Path -LiteralPath $exactAss) {
        $ass = Get-Item -LiteralPath $exactAss
    } else {
        $ass = $assFiles |
            Where-Object { $_.BaseName.StartsWith($stem, [System.StringComparison]::OrdinalIgnoreCase) } |
            Sort-Object @{ Expression = { $_.BaseName.Length } } |
            Select-Object -First 1
    }

    if (-not $ass) {
        Write-Host "ASS не найден для: $($mkv.Name)"
        return
    }

    $out = Join-Path $root ($stem + ".mp4")
    $assPath = Escape-FfmpegFilterPath $ass.FullName


    ffmpeg -y `
        -i $mkv.FullName `
        -vf "ass='$assPath':fontsdir='$fontsDir'" `
        -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -rc vbr -cq 19 -b:v 0 -preset p5 `
        -c:a aac -b:a 320k `
        -movflags +faststart `
        $out
}

Read-Host "Готово. Нажмите Enter для выхода"