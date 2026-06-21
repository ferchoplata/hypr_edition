#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=lib/detect.sh
source "${SCRIPT_DIR}/lib/detect.sh"
# shellcheck source=lib/packages.sh
source "${SCRIPT_DIR}/lib/packages.sh"
# shellcheck source=lib/backup.sh
source "${SCRIPT_DIR}/lib/backup.sh"
# shellcheck source=lib/dotfiles.sh
source "${SCRIPT_DIR}/lib/dotfiles.sh"
# shellcheck source=lib/report.sh
source "${SCRIPT_DIR}/lib/report.sh"
# shellcheck source=lib/session.sh
source "${SCRIPT_DIR}/lib/session.sh"

usage() {
  cat <<'USAGE'
Uso:
  ./install.sh [--dry-run]

Opciones:
  --dry-run, -n   Muestra que haria el instalador sin aplicar cambios.
  --help, -h      Muestra esta ayuda.
USAGE
}

parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --dry-run|-n)
        DRY_RUN=1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        die "Opcion desconocida: $1"
        ;;
    esac
    shift
  done
}

main_menu() {
  print_header
  detect_system

  while true; do
    cat <<MENU

Selecciona una opcion:
  1) Instalacion completa
  2) Solo paquetes base de Hyprland
  3) Solo copiar configuracion
  4) Crear backup de configuraciones actuales
  5) Ver estado del sistema
  6) Salir

MENU
    read -r -p "Opcion: " choice

    case "${choice}" in
      1)
        confirm_supported_system
        ensure_not_root
        install_packages full
        backup_configs
        install_dotfiles
        configure_hyprland_session
        configure_password_feedback
        enable_recommended_services
        success "Instalacion completa finalizada."
        ;;
      2)
        confirm_supported_system
        ensure_not_root
        install_packages base
        enable_recommended_services
        success "Paquetes base instalados."
        ;;
      3)
        ensure_not_root
        backup_configs
        install_dotfiles
        configure_hyprland_session
        configure_password_feedback
        success "Configuracion copiada."
        ;;
      4)
        ensure_not_root
        backup_configs
        success "Backup creado."
        ;;
      5)
        system_report
        pause
        ;;
      6)
        info "Saliendo."
        exit 0
        ;;
      *)
        warn "Opcion no valida."
        ;;
    esac
  done
}

parse_args "$@"
main_menu
