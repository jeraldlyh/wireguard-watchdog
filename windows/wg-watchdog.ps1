# wg-watchdog: ping through each WireGuard tunnel and restart the tunnel service on failure.

$ConfigFile = "$env:ProgramData\wg-watchdog\config.ps1"
$LogFile    = "$env:ProgramData\wg-watchdog\wg-watchdog.log"

function Write-Log {
    param(
        [string]$Level,
        [string]$Message
    )

    $line = "[{0}][{1}] {2}" -f $Level, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    Add-Content -Path $LogFile -Value $line -Encoding UTF8 -ErrorAction SilentlyContinue
    Write-Host $line
    if ($Level -eq 'ERROR') {
        [Console]::Error.WriteLine($line)
    }
}

function Restart-Tunnel {
    param(
        [string]$Service
    )

    if (-not (Get-Service -Name $Service -ErrorAction SilentlyContinue)) {
        Write-Log 'ERROR' "Tunnel service not found: $Service"
        return
    }

    try {
        Restart-Service -Name $Service -ErrorAction Stop
    } catch {
        Write-Log 'ERROR' "Failed to restart ${Service}: $($_.Exception.Message)"
    }
}

if (-not (Test-Path -LiteralPath $ConfigFile -PathType Leaf)) {
    Write-Log 'ERROR' "Config file not found or unreadable: $ConfigFile"
    Write-Log 'ERROR' "Set it up from the example: Copy-Item `"$(Split-Path -Parent $ConfigFile)\config.example.ps1`" `"$ConfigFile`""
    exit 1
}

try {
    . $ConfigFile
} catch {
    Write-Log 'ERROR' "Failed to load config file ${ConfigFile}: $($_.Exception.Message)"
    exit 1
}

if ($null -eq $PingTargets -or $PingTargets.Count -eq 0) {
    Write-Log 'ERROR' "PingTargets is not defined in $ConfigFile"
    exit 1
}

if ($null -eq $PingCount -or [string]::IsNullOrEmpty($PingCount)) { $PingCount = 5 }
if ($null -eq $PingTimeoutMs -or [string]::IsNullOrEmpty($PingTimeoutMs)) { $PingTimeoutMs = 5000 }

foreach ($name in $PingTargets.Keys) {
    $target  = [string]$PingTargets[$name]
    $service = "WireGuardTunnel`$$name"

    $addresses = @(Get-NetIPAddress -InterfaceAlias $name -AddressFamily IPv4 -ErrorAction SilentlyContinue)
    $preferred = @($addresses | Where-Object { $_.AddressState -eq 'Preferred' })
    if ($preferred.Count -gt 0) {
        $source = $preferred[0].IPAddress
    } elseif ($addresses.Count -gt 0) {
        $source = $addresses[0].IPAddress
    } else {
        $source = $null
    }

    if (-not $source) {
        Write-Log 'ERROR' ("{0}: no IPv4 address on tunnel, restarting service (service: {1})" -f $name, $service)
        Restart-Tunnel -Service $service
        continue
    }

    & ping.exe -S $source -n $PingCount -w $PingTimeoutMs $target | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Log 'INFO' ("{0}: {1} is reachable" -f $name, $target)
    } else {
        Write-Log 'ERROR' ("{0}: {1} is unreachable, restarting service (service: {2})" -f $name, $target, $service)
        Restart-Tunnel -Service $service
    }
}

exit 0
