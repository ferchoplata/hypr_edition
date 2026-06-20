#!/usr/bin/env bash
set -euo pipefail

readonly WAYBAR_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/waybar"

next_theme() {
  local current="command-center"

  if [[ -r "${WAYBAR_DIR}/.active-theme" ]]; then
    read -r current < "${WAYBAR_DIR}/.active-theme" || current="command-center"
  fi

  case "${current}" in
    horizon-pro) printf 'aero-glass\n' ;;
    aero-glass) printf 'command-center\n' ;;
    *) printf 'horizon-pro\n' ;;
  esac
}

apply_theme() {
  local theme="$1"
  local source_dir="${WAYBAR_DIR}/themes/${theme}"

  if [[ ! -f "${source_dir}/config.jsonc" || ! -f "${source_dir}/style.css" ]]; then
    printf '[ERROR] Modelo de Waybar no encontrado: %s\n' "${theme}" >&2
    return 1
  fi

  install -m644 "${source_dir}/config.jsonc" "${WAYBAR_DIR}/config.jsonc"
  install -m644 "${source_dir}/style.css" "${WAYBAR_DIR}/style.css"
  printf '%s\n' "${theme}" > "${WAYBAR_DIR}/.active-theme"

  if [[ "${HYPR_EDITION_SKIP_WAYBAR_RESTART:-0}" == "1" ]]; then
    return 0
  fi

  pkill -x waybar >/dev/null 2>&1 || true
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl dispatch exec waybar >/dev/null
  else
    nohup waybar >/tmp/hypr-edition-waybar.log 2>&1 &
  fi
}

main() {
  local theme="${1:-}"

  if [[ -z "${theme}" ]]; then
    theme="$(next_theme)"
  fi

  case "${theme}" in
    horizon-pro|aero-glass|command-center) ;;
    *)
      printf 'Uso: %s [horizon-pro|aero-glass|command-center]\n' "$0" >&2
      exit 2
      ;;
  esac

  apply_theme "${theme}"
}

main "$@"
