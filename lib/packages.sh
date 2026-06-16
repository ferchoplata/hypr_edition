#!/usr/bin/env bash

package_file_for_mode() {
  local mode="$1"
  local files=("${SCRIPT_DIR}/packages/common.txt")

  if [[ "${mode}" == "full" ]]; then
    files+=("${SCRIPT_DIR}/packages/desktop.txt")
  fi

  if is_arch && ! is_cachyos; then
    files+=("${SCRIPT_DIR}/packages/arch.txt")
  fi

  if is_cachyos; then
    files+=("${SCRIPT_DIR}/packages/cachyos.txt")
  fi

  printf '%s\n' "${files[@]}"
}

read_package_list() {
  local file

  while IFS= read -r file; do
    [[ -f "${file}" ]] || continue
    sed -E 's/#.*$//' "${file}" | awk 'NF {print $1}'
  done
}

resolve_package_spec() {
  local spec="$1"
  local candidate
  local -a candidates

  IFS='|' read -r -a candidates <<< "${spec}"

  for candidate in "${candidates[@]}"; do
    if pacman -Si "${candidate}" >/dev/null 2>&1; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done

  return 1
}

filter_available_packages() {
  local spec
  local package

  for spec in "$@"; do
    if package="$(resolve_package_spec "${spec}")"; then
      if [[ "${package}" != "${spec}" ]]; then
        printf '[INFO] Usando alternativa para %s: %s\n' "${spec}" "${package}" >&2
      fi
      printf '%s\n' "${package}"
    else
      warn "Paquete no encontrado en repositorios activos, se omitira: ${spec}"
    fi
  done
}

install_packages() {
  local mode="$1"
  local -a requested_packages
  local -a available_packages

  require_command pacman
  require_command sudo

  info "Actualizando base de paquetes."
  run_cmd sudo pacman -Syu

  mapfile -t requested_packages < <(package_file_for_mode "${mode}" | read_package_list | sort -u)
  mapfile -t available_packages < <(filter_available_packages "${requested_packages[@]}" | sort -u)

  if [[ "${#available_packages[@]}" -eq 0 ]]; then
    warn "No hay paquetes para instalar."
    return 0
  fi

  info "Instalando ${#available_packages[@]} paquetes."
  run_cmd sudo pacman -S --needed "${available_packages[@]}"
}

enable_recommended_services() {
  require_command systemctl
  require_command sudo

  local services=(
    NetworkManager.service
    bluetooth.service
    sddm.service
  )

  for service in "${services[@]}"; do
    if systemctl list-unit-files "${service}" >/dev/null 2>&1; then
      info "Habilitando ${service}."
      run_cmd sudo systemctl enable "${service}"
    fi
  done

  if is_dry_run; then
    run_cmd systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service
  else
    systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service >/dev/null 2>&1 || true
  fi
}
