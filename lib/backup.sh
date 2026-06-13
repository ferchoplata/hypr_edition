#!/usr/bin/env bash

backup_configs() {
  local timestamp
  local backup_root
  local paths=(
    "${HOME}/.config/hypr"
    "${HOME}/.config/waybar"
    "${HOME}/.config/rofi"
    "${HOME}/.config/kitty"
    "${HOME}/.config/swaync"
    "${HOME}/.config/wlogout"
  )

  timestamp="$(date +%Y%m%d-%H%M%S)"
  backup_root="${HOME}/.local/share/${APP_NAME}/backups/${timestamp}"
  mkdir -p "${backup_root}"

  for path in "${paths[@]}"; do
    if [[ -e "${path}" ]]; then
      info "Respaldando ${path}."
      cp -a "${path}" "${backup_root}/"
    fi
  done

  info "Backup disponible en: ${backup_root}"
}
