#!/usr/bin/env bash
set -euo pipefail

notify_unavailable() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send \
      -a hypr_edition \
      -u normal \
      "Bluetooth no disponible" \
      "No se detecto un adaptador Bluetooth en este equipo."
  fi
}

if ! systemctl is-active --quiet bluetooth.service; then
  notify_unavailable
  exit 0
fi

if ! timeout 2 bluetoothctl list 2>/dev/null | grep -q '^Controller '; then
  notify_unavailable
  exit 0
fi

exec blueman-manager
