#Requires -RunAsAdministrator

$InstallDir = "$env:ProgramFiles\wg-watchdog"
$DataDir    = "$env:ProgramData\wg-watchdog"

Unregister-ScheduledTask -TaskName 'wg-watchdog' -Confirm:$false -ErrorAction SilentlyContinue

Remove-Item -Path $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$DataDir\config.example.ps1" -Force -ErrorAction SilentlyContinue

if ((Test-Path -LiteralPath $DataDir) -and -not (Get-ChildItem -LiteralPath $DataDir -Force)) {
    Remove-Item -Path $DataDir -Force -ErrorAction SilentlyContinue
}

Write-Host 'Uninstall complete.'
if (Test-Path -LiteralPath "$DataDir\config.ps1") {
    Write-Host "Kept your config: $DataDir\config.ps1"
}
