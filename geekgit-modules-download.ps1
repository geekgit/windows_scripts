New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
Set-Location -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
git clone "https://github.com/geekgit/windows_scripts_modules" .
ls