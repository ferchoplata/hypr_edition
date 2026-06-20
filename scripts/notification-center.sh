#!/usr/bin/env bash
set -euo pipefail

start_swaync() {
  if pgrep -x swaync >/dev/null 2>&1; then
    return 0
  fi

  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl dispatch exec hypr-edition-swaync >/dev/null 2>&1
  else
    nohup hypr-edition-swaync >/tmp/hypr-edition-swaync.log 2>&1 &
  fi

  sleep 1
}

run_client() {
  timeout 2 swaync-client "$@"
}

start_swaync

if run_client "$@"; then
  exit 0
fi

pkill -x swaync >/dev/null 2>&1 || true
start_swaync
run_client "$@"
