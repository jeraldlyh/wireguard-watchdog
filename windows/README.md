# wg-watchdog (Windows)

Small health check for WireGuard tunnels on Windows. Pings a target through each tunnel and restarts its service when the target stops responding.

## Requirements

- Windows 10/11
- WireGuard for Windows with at least one tunnel installed
- Administrator rights

## Install

Run in an elevated PowerShell (admin):

```powershell
.\install.ps1
```

The installer copies the script to `%ProgramFiles%\wg-watchdog`, creates `%ProgramData%\wg-watchdog`, and registers the scheduled task `wg-watchdog`, which runs every 30 seconds as SYSTEM.

Edit the config:

```powershell
notepad C:\ProgramData\wg-watchdog\config.ps1
```

Set one ping target per tunnel:

```powershell
$PingTargets = @{
    'wg0' = '172.20.0.1'
}
```

## Uninstall

Run in an elevated PowerShell (admin):

```powershell
.\uninstall.ps1
```

Removes the scheduled task and installed script. Your `config.ps1` is kept.

## Notes

- On a failed ping, the tunnel is restarted with `Restart-Service "WireGuardTunnel$<name>"`.
- Log file: `C:\ProgramData\wg-watchdog\wg-watchdog.log`
