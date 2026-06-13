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
  5) Salir

MENU
    read -r -p "Opcion: " choice

    case "${choice}" in
      1)
        confirm_supported_system
        ensure_not_root
        install_packages full
        backup_configs
        install_dotfiles
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
        success "Configuracion copiada."
        ;;
      4)
        ensure_not_root
        backup_configs
        success "Backup creado."
        ;;
      5)
        info "Saliendo."
        exit 0
        ;;
      *)
        warn "Opcion no valida."
        ;;
    esac
  done
}

main_menu "$@"
