#!/usr/bin/env bash

detect_aur_helper() {
  if command_exists paru; then
    printf 'paru\n'
    return 0
  fi

  if command_exists yay; then
    printf 'yay\n'
    return 0
  fi

  printf 'no detectado\n'
}

detect_display_manager() {
  if ! command_exists systemctl; then
    printf 'no detectado\n'
    return 0
  fi

  if systemctl list-unit-files sddm.service >/dev/null 2>&1; then
    if systemctl is-enabled sddm.service >/dev/null 2>&1; then
      printf 'sddm habilitado\n'
    else
      printf 'sddm instalado, no habilitado\n'
    fi
    return 0
  fi

  if systemctl list-unit-files display-manager.service >/dev/null 2>&1; then
    printf 'display-manager detectado\n'
    return 0
  fi

  printf 'no detectado\n'
}

print_gpu_info() {
  if ! command_exists lspci; then
    printf 'GPU: no se puede revisar porque falta lspci (paquete pciutils)\n'
    return 0
  fi

  local gpu_lines
  gpu_lines="$(lspci | grep -Ei 'vga|3d|display' || true)"

  if [[ -z "${gpu_lines}" ]]; then
    printf 'GPU: no detectada por lspci\n'
    return 0
  fi

  printf 'GPU:\n'
  printf '%s\n' "${gpu_lines}"
}

system_report() {
  cat <<REPORT

Estado del sistema
Sistema: ${DETECTED_NAME:-no detectado}
ID: ${DETECTED_ID:-no detectado}
Base: ${DETECTED_BASE:-no detectada}
Modo dry-run: ${DRY_RUN}
Pacman: $(command_exists pacman && printf 'disponible' || printf 'no detectado')
Systemd: $(command_exists systemctl && printf 'disponible' || printf 'no detectado')
Helper AUR: $(detect_aur_helper)
Display manager: $(detect_display_manager)

REPORT

  print_gpu_info
}
