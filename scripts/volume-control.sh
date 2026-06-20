#!/usr/bin/env bash
set -euo pipefail

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
    up) timeout 2 swayosd-client --output-volume +5 ;;
    down) timeout 2 swayosd-client --output-volume -5 ;;
    mute) timeout 2 swayosd-client --output-volume mute-toggle ;;
    mic-mute) timeout 2 swayosd-client --input-volume mute-toggle ;;
    play-pause) timeout 2 swayosd-client --playerctl play-pause ;;
    next) timeout 2 swayosd-client --playerctl next ;;
    prev) timeout 2 swayosd-client --playerctl previous ;;
    *) printf 'Uso: %s {up|down|mute|mic-mute|play-pause|next|prev}\n' "$0" >&2; return 2 ;;
  esac
}

fallback_action() {
  local action="$1"

  case "${action}" in
    up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    mic-mute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    play-pause) playerctl play-pause ;;
    next) playerctl next ;;
    prev) playerctl previous ;;
    *) return 2 ;;
  esac
}

main() {
  local action="${1:-}"

  if [[ -z "${action}" ]]; then
    printf 'Uso: %s {up|down|mute|mic-mute|play-pause|next|prev}\n' "$0" >&2
    exit 2
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
