# wg-watchdog

Watchdog for WireGuard tunnels. Periodically checks connectivity through each tunnel and restarts it when the target stops responding.

## Use case

The tunnel endpoint is a dynamic DNS name (for example, a Cloudflare DDNS record):

```ini
[Peer]
Endpoint = home.example.com:51820
```

WireGuard resolves that name when the interface comes up and then keeps sending to the address it learned. If the ISP changes the public IP, Cloudflare DDNS updates the record to the new address, but the running tunnel does not notice.

Keepalives and handshakes still go to the old IP but the peer is unreachable, so the tunnel stays up while passing no traffic. `PersistentKeepalive` does not help here: the keepalives go to the same stale address.

`wg-watchdog` detects the dead tunnel (the periodic ping through the interface stops answering), restarts the interface, and the endpoint is resolved again - this time against the updated DNS record so that the tunnel recovers on its own.

## Platforms

- **Linux**: bash + systemd - see [linux/README.md](linux/README.md)
- **Windows**: PowerShell + Task Scheduler - see [windows/README.md](windows/README.md)

## Disclaimer

> [!NOTE]
> This project is a fork of [STARRY-S/wg-healthcheck](https://github.com/STARRY-S/wg-healthcheck). Credit for the original implementation goes to the original author.
