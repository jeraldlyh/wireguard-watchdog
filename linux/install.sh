#!/usr/bin/env bash

cd "$(dirname "$0")"
source ./logging.sh

if [[ "$(id -u)" -ne 0 ]]; then
    log_error "Root privileges required, run: sudo $0"
    exit 1
fi

INSTALL_DIR=${INSTALL_DIR:-}
SYSTEMD_DIR=${SYSTEMD_DIR:-"/etc/systemd/system"}

set -euxo pipefail

install -Dm0755 wg-watchdog "${INSTALL_DIR}/usr/bin/wg-watchdog"
install -Dm0644 logging.sh "${INSTALL_DIR}/usr/bin/logging.sh"
install -Dm0600 config.example.env "${INSTALL_DIR}/etc/wg-watchdog/config.example.env"
install -Dm0644 wg-watchdog.service "${INSTALL_DIR}${SYSTEMD_DIR}/wg-watchdog.service"
install -Dm0644 wg-watchdog.timer "${INSTALL_DIR}${SYSTEMD_DIR}/wg-watchdog.timer"
