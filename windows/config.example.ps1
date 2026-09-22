# Ping target per tunnel (tunnel name -> target IP)
$PingTargets = @{
    'wg0' = '172.20.0.1'
}

# Ping options
$PingCount     = 5
$PingTimeoutMs = 5000
