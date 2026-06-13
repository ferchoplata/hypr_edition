#!/usr/bin/env bash

DETECTED_ID=""
DETECTED_NAME=""
DETECTED_BASE=""

detect_system() {
  require_command uname

  if [[ "$(uname -s)" != "Linux" ]]; then
    die "Este instalador esta pensado para Linux."
  fi

  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    DETECTED_ID="${ID:-unknown}"
    DETECTED_NAME="${PRETTY_NAME:-${NAME:-unknown}}"
    DETECTED_BASE="${ID_LIKE:-}"
  else
    die "No se pudo leer /etc/os-release."
  fi

  info "Sistema detectado: ${DETECTED_NAME}"
}

is_cachyos() {
  [[ "${DETECTED_ID}" == "cachyos" ]]
}

is_arch() {
  [[ "${DETECTED_ID}" == "arch" || " ${DETECTED_BASE} " == *" arch "* ]]
}

confirm_supported_system() {
  if is_cachyos; then
    info "Modo CachyOS: se usaran paquetes comunes y ajustes compatibles con CachyOS."
    return 0
  fi

  if is_arch; then
    info "Modo Arch: se instalaran dependencias extra que una base minima puede no traer."
    return 0
  fi

  die "Sistema no soportado todavia. Por ahora soportamos CachyOS y Arch/Arch-based."
}
