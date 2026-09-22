# wg-watchdog (Linux)

Small health check for WireGuard clients. Pings a target through each interface (`ping -I wgN`) and restarts the interface when the target stops responding.

## Install

```bash
sudo ./install.sh
sudo cp /etc/wg-watchdog/config.example.env /etc/wg-watchdog/config.env
sudo nano /etc/wg-watchdog/config.env
sudo systemctl daemon-reload
sudo systemctl enable --now wg-watchdog.timer
```

## Configure

Set one ping target per interface:

```bash
RESTART_MODE="systemd"   # or "wg-quick"
declare -A PING_TARGETS=(
  [wg0]="172.20.0.1"
)
```

The timer runs the check every 30 seconds.

## Uninstall

```bash
sudo ./uninstall.sh
```

Removes the scripts and units. Your `config.env` is kept.

## Requirements

Linux with systemd, Bash 4+ (associative arrays).
