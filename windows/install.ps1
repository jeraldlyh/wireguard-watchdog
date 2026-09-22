#Requires -RunAsAdministrator

$InstallDir = "$env:ProgramFiles\wg-watchdog"
$DataDir    = "$env:ProgramData\wg-watchdog"

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $DataDir | Out-Null

Copy-Item -Path "$PSScriptRoot\wg-watchdog.ps1" -Destination "$InstallDir\wg-watchdog.ps1" -Force
Copy-Item -Path "$PSScriptRoot\config.example.ps1" -Destination "$DataDir\config.example.ps1" -Force

if (-not (Test-Path -LiteralPath "$DataDir\config.ps1")) {
    Copy-Item -Path "$DataDir\config.example.ps1" -Destination "$DataDir\config.ps1"
}

$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$InstallDir\wg-watchdog.ps1`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew

Register-ScheduledTask -TaskName 'wg-watchdog' -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null

Write-Host 'Install complete.'
Write-Host ''
Write-Host '  Scheduled task: wg-watchdog (every minute, as SYSTEM)'
Write-Host "  Script:         $InstallDir\wg-watchdog.ps1"
Write-Host "  Config:         $DataDir\config.ps1"
Write-Host "  Log:            $DataDir\wg-watchdog.log"
Write-Host ''
Write-Host 'Next step - edit the config, the task picks it up on the next run:'
Write-Host "  notepad $DataDir\config.ps1"
