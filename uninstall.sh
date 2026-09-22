#!/usr/bin/env bash

cd "$(dirname "$0")"
source ./logging.sh

if [[ "$(id -u)" -ne 0 ]]; then
    log_error "Root privileges required, run: sudo $0"
    exit 1
fi

INSTALL_DIR=${INSTALL_DIR:-}
SYSTEMD_DIR=${SYSTEMD_DIR:-"/etc/systemd/system"}

set -exuo pipefail

systemctl disable --now wg-watchdog.timer || true

rm -f "${INSTALL_DIR}/usr/bin/wg-watchdog"
rm -f "${INSTALL_DIR}/usr/bin/logging.sh"
rm -f "${INSTALL_DIR}/etc/wg-watchdog/config.example.env"
rmdir "${INSTALL_DIR}/etc/wg-watchdog" 2>/dev/null || true

rm -f "${INSTALL_DIR}${SYSTEMD_DIR}/wg-watchdog.service"
rm -f "${INSTALL_DIR}${SYSTEMD_DIR}/wg-watchdog.timer"

systemctl daemon-reload
