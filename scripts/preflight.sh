#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=../lib/detect.sh
source "${SCRIPT_DIR}/lib/detect.sh"
# shellcheck source=../lib/packages.sh
source "${SCRIPT_DIR}/lib/packages.sh"
# shellcheck source=../lib/report.sh
source "${SCRIPT_DIR}/lib/report.sh"

check_package_mode() {
  local mode="$1"
  local missing=0
  local package
  local spec

  info "Revisando paquetes del modo: ${mode}"

  while IFS= read -r spec; do
    if package="$(resolve_package_spec "${spec}")"; then
      if [[ "${package}" == "${spec}" ]]; then
        printf '[OK] %s\n' "${package}"
      else
        printf '[OK] %s -> %s\n' "${spec}" "${package}"
      fi
    else
      printf '[MISS] %s\n' "${spec}"
      missing=1
    fi
  done < <(package_file_for_mode "${mode}" | read_package_list | sort -u)

  return "${missing}"
}

main() {
  detect_system
  confirm_supported_system
  system_report

  require_command pacman

  local failed=0
  check_package_mode base || failed=1
  check_package_mode full || failed=1

  if [[ "${failed}" -eq 1 ]]; then
    warn "Preflight termino con paquetes faltantes. Revisa repositorios o ajusta packages/*.txt."
    return 1
  fi

  success "Preflight terminado sin paquetes faltantes."
}

main "$@"
