#!/usr/bin/env bash

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
}
