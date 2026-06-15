#!/usr/bin/env bash
set -euo pipefail

SIMPLE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$SIMPLE_DIR/lib/ui.sh"
source "$SIMPLE_DIR/lib/log.sh"
source "$SIMPLE_DIR/lib/system.sh"
source "$SIMPLE_DIR/lib/modules.sh"
source "$SIMPLE_DIR/lib/export.sh"

main_menu() {
  while true; do
    if [[ -t 1 && -n "${TERM:-}" && "${TERM:-}" != "dumb" ]]; then
      clear || true
    fi
    ui_header "Simple Edition"
    ui_info "Base detectada: $(detect_distro)"
    echo
    echo "1. Instalar perfil completo"
    echo "2. Instalar modulos individuales"
    echo "3. Crear backup"
    echo "4. Restaurar backup"
    echo "5. Desinstalar modulos"
    echo "6. Exportar sistema actual"
    echo "7. Ver estado del sistema"
    echo "C. Salir"
    echo
    read -r -p "Elige una opcion: " choice

    case "${choice,,}" in
      1) install_profile ;;
      2) install_modules_menu ;;
      3) backup_modules_menu ;;
      4) ui_warn "Restauracion completa aun no esta implementada."; pause ;;
      5) uninstall_modules_menu ;;
      6) export_system; pause ;;
      7) system_report; pause ;;
      c) ui_success "Saliendo de Simple Edition."; exit 0 ;;
      *) ui_error "Opcion no valida."; pause ;;
    esac
  done
}

require_arch_family
log_init
main_menu
