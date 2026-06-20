#!/usr/bin/env bash

install_kitty_launcher() {
  local launcher_source="${SCRIPT_DIR}/scripts/launch-kitty.sh"
  local desktop_source="${SCRIPT_DIR}/assets/applications/kitty.desktop"

  info "Instalando lanzador automatico de Kitty."
  run_cmd install -Dm755 \
    "${launcher_source}" \
    "${HOME}/.local/bin/hypr-edition-kitty"
  run_cmd install -Dm644 \
    "${desktop_source}" \
    "${HOME}/.local/share/applications/kitty.desktop"
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

  install_kitty_launcher
}
