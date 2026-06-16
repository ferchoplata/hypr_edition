#!/usr/bin/env bash

configure_hyprland_session() {
  require_command sudo

  if ! command_exists start-hyprland; then
    warn "No se encontro start-hyprland; se omite la sesion hypr_edition para SDDM."
    return 0
  fi

  info "Creando sesion hypr_edition para SDDM con start-hyprland."

  if is_dry_run; then
    run_cmd sudo install -d /usr/share/wayland-sessions
    run_cmd sudo install -m 0644 "${SCRIPT_DIR}/config/sessions/hypr-edition.desktop" /usr/share/wayland-sessions/hypr-edition.desktop
    return 0
  fi

  sudo install -d /usr/share/wayland-sessions
  sudo install -m 0644 "${SCRIPT_DIR}/config/sessions/hypr-edition.desktop" /usr/share/wayland-sessions/hypr-edition.desktop
}
