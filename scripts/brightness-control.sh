#!/usr/bin/env bash
set -euo pipefail

has_backlight() {
  command -v brightnessctl >/dev/null 2>&1 || return 1
  timeout 2 brightnessctl -l 2>/dev/null | grep -q '.'
}

start_swayosd() {
  if pgrep -x swayosd-server >/dev/null 2>&1; then
    return 0
  fi

  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl dispatch exec hypr-edition-swayosd >/dev/null 2>&1
  else
    nohup hypr-edition-swayosd >/tmp/hypr-edition-swayosd.log 2>&1 &
  fi

  sleep 1
}

run_swayosd() {
  local action="$1"

  case "${action}" in
    up) timeout 2 swayosd-client --brightness +5 ;;
    down) timeout 2 swayosd-client --brightness -5 ;;
    more) timeout 2 swayosd-client --brightness +10 ;;
    less) timeout 2 swayosd-client --brightness -10 ;;
    *) printf 'Uso: %s {up|down|more|less}\n' "$0" >&2; return 2 ;;
  esac
}

fallback_action() {
  local action="$1"

  case "${action}" in
    up) brightnessctl set 5%+ ;;
    down) brightnessctl set 5%- ;;
    more) brightnessctl set 10%+ ;;
    less) brightnessctl set 10%- ;;
    *) return 2 ;;
  esac
}

main() {
  local action="${1:-}"

  if [[ -z "${action}" ]]; then
    printf 'Uso: %s {up|down|more|less}\n' "$0" >&2
    exit 2
  fi

  if ! has_backlight; then
    exit 0
  fi

  if command -v swayosd-client >/dev/null 2>&1; then
    start_swayosd

    if run_swayosd "${action}"; then
      exit 0
    fi

    pkill -x swayosd-server >/dev/null 2>&1 || true
    start_swayosd

    if run_swayosd "${action}"; then
      exit 0
    fi
  fi

  fallback_action "${action}"
}

main "$@"
