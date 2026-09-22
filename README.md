# wg-watchdog

Watchdog for WireGuard tunnels. Periodically checks connectivity through each tunnel and restarts it when the target stops responding.

## Platforms

- **Linux**: bash + systemd - see [linux/README.md](linux/README.md)
- **Windows**: PowerShell + Task Scheduler - see [windows/README.md](windows/README.md)

## Disclaimer

> [!NOTE]
> This project is a fork of [STARRY-S/wg-healthcheck](https://github.com/STARRY-S/wg-healthcheck). Credit for the original implementation goes to the original author.
