#!/usr/bin/env bash

log_info() { printf '[INFO][%s] %s\n' "$(date '+%F %T')" "$*"; }

log_error() { printf '[ERROR][%s] %s\n' "$(date '+%F %T')" "$*" >&2; }
