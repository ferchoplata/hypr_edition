#!/usr/bin/env bash

install_user_launchers() {
  local launcher_source="${SCRIPT_DIR}/scripts/launch-kitty.sh"
  local waybar_theme_source="${SCRIPT_DIR}/scripts/waybar-theme.sh"
  local desktop_source="${SCRIPT_DIR}/assets/applications/kitty.desktop"

  info "Instalando lanzadores de hypr_edition."
  run_cmd install -Dm755 \
    "${launcher_source}" \
    "${HOME}/.local/bin/hypr-edition-kitty"
  run_cmd install -Dm755 \
    "${waybar_theme_source}" \
    "${HOME}/.local/bin/hypr-edition-waybar-theme"
  run_cmd install -Dm644 \
    "${desktop_source}" \
    "${HOME}/.local/share/applications/kitty.desktop"
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
  install_user_launchers
}
