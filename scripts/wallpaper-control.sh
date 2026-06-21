#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="${HYPR_EDITION_WALLPAPER_DIR:-${HOME}/Pictures/HyprEdition}"
state_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/hypr-edition"
state_file="${state_dir}/wallpaper-index"
log_file="${state_dir}/wallpaper.log"
hyprpaper_config="${XDG_CONFIG_HOME:-${HOME}/.config}/hypr/hyprpaper.conf"

mapfile -d '' wallpapers < <(
  find "${wallpaper_dir}" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
    -print0 | sort -z
)

if (( ${#wallpapers[@]} == 0 )); then
  printf 'No se encontraron fondos en %s\n' "${wallpaper_dir}" >&2
  exit 1
fi

mkdir -p "${state_dir}"

current_index=0
if [[ -r "${state_file}" ]]; then
  saved_index="$(<"${state_file}")"
  if [[ "${saved_index}" =~ ^[0-9]+$ ]] && (( saved_index < ${#wallpapers[@]} )); then
    current_index="${saved_index}"
  fi
fi

case "${1:-next}" in
  init) selected_index="${current_index}" ;;
  next) selected_index=$(( (current_index + 1) % ${#wallpapers[@]} )) ;;
  previous|prev) selected_index=$(( (current_index - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]} )) ;;
  *)
    printf 'Uso: %s [init|next|previous]\n' "${0##*/}" >&2
    exit 2
    ;;
esac

selected_wallpaper="${wallpapers[selected_index]}"

apply_with_swww() {
  if ! pgrep -x swww-daemon >/dev/null 2>&1; then
    swww-daemon >>"${log_file}" 2>&1 &
    sleep 0.5
  fi
  swww img "${selected_wallpaper}" --transition-type grow --transition-duration 0.7
}

apply_with_awww() {
  if ! pgrep -x awww-daemon >/dev/null 2>&1; then
    awww-daemon >>"${log_file}" 2>&1 &
    sleep 0.5
  fi
  awww img "${selected_wallpaper}" --transition-type grow --transition-duration 0.7
}

apply_with_hyprpaper() {
  if ! hyprctl hyprpaper listactive >/dev/null 2>&1; then
    pkill -x hyprpaper >/dev/null 2>&1 || true
    hyprpaper >>"${log_file}" 2>&1 &
    for _ in {1..30}; do
      hyprctl hyprpaper listactive >/dev/null 2>&1 && break
      sleep 0.1
    done
  fi

  if ! hyprctl hyprpaper reload ",${selected_wallpaper}" >/dev/null 2>&1; then
    hyprctl hyprpaper preload "${selected_wallpaper}" >/dev/null
    hyprctl hyprpaper wallpaper ",${selected_wallpaper}" >/dev/null
  fi
}

apply_with_swaybg() {
  pkill -x swaybg >/dev/null 2>&1 || true
  swaybg -i "${selected_wallpaper}" -m fill >>"${log_file}" 2>&1 &
}

backend=""
if pgrep -x swww-daemon >/dev/null 2>&1 && command -v swww >/dev/null 2>&1 && apply_with_swww; then
  backend="swww"
elif pgrep -x awww-daemon >/dev/null 2>&1 && command -v awww >/dev/null 2>&1 && apply_with_awww; then
  backend="awww"
elif hyprctl hyprpaper listactive >/dev/null 2>&1 && command -v hyprpaper >/dev/null 2>&1 && apply_with_hyprpaper; then
  backend="hyprpaper"
elif pgrep -x swaybg >/dev/null 2>&1 && command -v swaybg >/dev/null 2>&1 && apply_with_swaybg; then
  backend="swaybg"
elif command -v swww >/dev/null 2>&1 && apply_with_swww; then
  backend="swww"
elif command -v awww >/dev/null 2>&1 && apply_with_awww; then
  backend="awww"
elif command -v hyprpaper >/dev/null 2>&1 && apply_with_hyprpaper; then
  backend="hyprpaper"
elif command -v swaybg >/dev/null 2>&1 && apply_with_swaybg; then
  backend="swaybg"
fi

if [[ -z "${backend}" ]]; then
  printf 'No hay un gestor de fondos compatible instalado.\n' >&2
  exit 1
fi

printf '%s\n' "${selected_index}" > "${state_file}"
printf 'backend=%s wallpaper=%s\n' "${backend}" "${selected_wallpaper}" > "${log_file}"

mkdir -p "$(dirname "${hyprpaper_config}")"
cat > "${hyprpaper_config}" <<EOF
preload = ${selected_wallpaper}
wallpaper = ,${selected_wallpaper}
splash = false
EOF

if [[ "${1:-next}" != "init" ]] && command -v notify-send >/dev/null 2>&1; then
  notify-send -a "Hypr Edition" "Fondo cambiado (${backend})" "$(basename "${selected_wallpaper}")"
fi
