#!/usr/bin/env bash

readonly APP_NAME="hypr_edition"

print_header() {
  cat <<'HEADER'
hypr_edition
Instalador post-instalacion para Hyprland en CachyOS y Arch Linux.
HEADER
}

info() {
  printf '[INFO] %s\n' "$*"
}

success() {
  printf '[OK] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

die() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_not_root() {
  if [[ "${EUID}" -eq 0 ]]; then
    die "Ejecuta este instalador con tu usuario normal. Usaremos sudo cuando haga falta."
  fi
}

require_command() {
  command_exists "$1" || die "No se encontro el comando requerido: $1"
}

ask_yes_no() {
  local prompt="$1"
  local answer

  read -r -p "${prompt} [s/N]: " answer
  [[ "${answer}" == "s" || "${answer}" == "S" || "${answer}" == "si" || "${answer}" == "SI" ]]
}
