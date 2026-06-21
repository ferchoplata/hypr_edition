#!/usr/bin/env bash

install_user_launchers() {
  local launcher_source="${SCRIPT_DIR}/scripts/launch-kitty.sh"
  local swaync_source="${SCRIPT_DIR}/scripts/launch-swaync.sh"
  local swayosd_source="${SCRIPT_DIR}/scripts/launch-swayosd.sh"
  local notifications_source="${SCRIPT_DIR}/scripts/notification-center.sh"
  local volume_source="${SCRIPT_DIR}/scripts/volume-control.sh"
  local brightness_source="${SCRIPT_DIR}/scripts/brightness-control.sh"
  local waybar_theme_source="${SCRIPT_DIR}/scripts/waybar-theme.sh"
  local bluetooth_source="${SCRIPT_DIR}/scripts/bluetooth-panel.sh"
  local power_source="${SCRIPT_DIR}/scripts/power-menu.sh"
  local wallpaper_source="${SCRIPT_DIR}/scripts/wallpaper-control.sh"
  local desktop_source="${SCRIPT_DIR}/assets/applications/kitty.desktop"

  info "Instalando lanzadores de hypr_edition."
  run_cmd install -Dm755 \
    "${launcher_source}" \
    "${HOME}/.local/bin/hypr-edition-kitty"
  run_cmd install -Dm755 \
    "${swaync_source}" \
    "${HOME}/.local/bin/hypr-edition-swaync"
  run_cmd install -Dm755 \
    "${swayosd_source}" \
    "${HOME}/.local/bin/hypr-edition-swayosd"
  run_cmd install -Dm755 \
    "${notifications_source}" \
    "${HOME}/.local/bin/hypr-edition-notifications"
  run_cmd install -Dm755 \
    "${volume_source}" \
    "${HOME}/.local/bin/hypr-edition-volume"
  run_cmd install -Dm755 \
    "${brightness_source}" \
    "${HOME}/.local/bin/hypr-edition-brightness"
  run_cmd install -Dm755 \
    "${waybar_theme_source}" \
    "${HOME}/.local/bin/hypr-edition-waybar-theme"
  run_cmd install -Dm755 \
    "${bluetooth_source}" \
    "${HOME}/.local/bin/hypr-edition-bluetooth"
  run_cmd install -Dm755 \
    "${power_source}" \
    "${HOME}/.local/bin/hypr-edition-power-menu"
  run_cmd install -Dm755 \
    "${wallpaper_source}" \
    "${HOME}/.local/bin/hypr-edition-wallpaper"
  run_cmd install -Dm644 \
    "${desktop_source}" \
    "${HOME}/.local/share/applications/kitty.desktop"
}

install_wallpapers() {
  local source_dir="${SCRIPT_DIR}/wallpapers"
  local target_dir="${HOME}/Pictures/HyprEdition"
  local native_dir

  [[ -d "${source_dir}" ]] || return 0

  info "Instalando fondos de escritorio."
  run_cmd mkdir -p "${target_dir}"
  run_cmd rsync -a \
    --include='*/' \
    --include='*.jpg' \
    --include='*.jpeg' \
    --include='*.png' \
    --include='*.webp' \
    --exclude='*' \
    "${source_dir}/" \
    "${target_dir}/"

  for native_dir in \
    "${HOME}/.config/hypr/wallpapers" \
    "${HOME}/Pictures/wallpapers" \
    "${HOME}/Pictures/Wallpapers"; do
    [[ -d "${native_dir}" ]] || continue
    info "Integrando fondos con: ${native_dir}"
    run_cmd mkdir -p "${native_dir}/HyprEdition"
    run_cmd rsync -a \
      --include='*/' \
      --include='*.jpg' \
      --include='*.jpeg' \
      --include='*.png' \
      --include='*.webp' \
      --exclude='*' \
      "${source_dir}/" \
      "${native_dir}/HyprEdition/"
  done
}

install_default_waybar_theme() {
  local theme_dir="${SCRIPT_DIR}/config/waybar/themes/command-center"
  local waybar_dir="${HOME}/.config/waybar"

  info "Activando Command Center como modelo inicial de Waybar."
  run_cmd install -Dm644 "${theme_dir}/config.jsonc" "${waybar_dir}/config.jsonc"
  run_cmd install -Dm644 "${theme_dir}/style.css" "${waybar_dir}/style.css"
}

install_dotfiles() {
  local source_dir="${SCRIPT_DIR}/config"
  local target_dir="${HOME}/.config"

  run_cmd mkdir -p "${target_dir}"

  if [[ ! -d "${source_dir}" ]]; then
    warn "No existe la carpeta de configuracion: ${source_dir}"
    return 0
  fi

  for dir in "${source_dir}"/*; do
    [[ -d "${dir}" ]] || continue
    info "Copiando configuracion: $(basename "${dir}")"
    run_cmd cp -a "${dir}" "${target_dir}/"
  done

  install_default_waybar_theme
  install_wallpapers
  install_user_launchers
}
