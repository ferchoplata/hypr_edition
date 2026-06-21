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
elif [[ -r "${hyprpaper_config}" ]]; then
  current_path="$(sed -n 's/^[[:space:]]*wallpaper[[:space:]]*=[[:space:]]*,//p' "${hyprpaper_config}" | tail -n 1)"
  for index in "${!wallpapers[@]}"; do
    if [[ "${wallpapers[index]}" == "${current_path}" || "$(basename "${wallpapers[index]}")" == "$(basename "${current_path}")" ]]; then
      current_index="${index}"
      break
    fi
  done
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

stop_conflicting_wallpaper_services() {
  command -v swww >/dev/null 2>&1 && swww kill >/dev/null 2>&1 || true
  pkill -x swww-daemon >/dev/null 2>&1 || true
  pkill -x swaybg >/dev/null 2>&1 || true
}

ensure_hyprpaper() {
  if hyprctl hyprpaper listactive >/dev/null 2>&1; then
    return 0
  fi

  pkill -x hyprpaper >/dev/null 2>&1 || true

  command -v hyprpaper >/dev/null 2>&1 || {
    printf 'hyprpaper no esta instalado.\n' >&2
    return 1
  }

  nohup hyprpaper >>"${log_file}" 2>&1 &
  disown || true

  for _ in {1..30}; do
    hyprctl hyprpaper listactive >/dev/null 2>&1 && return 0
    sleep 0.1
  done

  printf 'hyprpaper no pudo iniciar. Revisa %s\n' "${log_file}" >&2
  return 1
}

if [[ "${1:-next}" == "init" ]]; then
  sleep 2
fi

stop_conflicting_wallpaper_services
ensure_hyprpaper

if ! hyprctl hyprpaper reload ",${selected_wallpaper}" >/dev/null 2>&1; then
  hyprctl hyprpaper preload "${selected_wallpaper}" >/dev/null
  hyprctl hyprpaper wallpaper ",${selected_wallpaper}" >/dev/null
fi

mkdir -p "$(dirname "${hyprpaper_config}")"
printf '%s\n' "${selected_index}" > "${state_file}"
cat > "${hyprpaper_config}" <<EOF
preload = ${selected_wallpaper}
wallpaper = ,${selected_wallpaper}
splash = false
EOF

if [[ "${1:-next}" != "init" ]] && command -v notify-send >/dev/null 2>&1; then
  notify-send -a "Hypr Edition" "Fondo cambiado" "$(basename "${selected_wallpaper}")"
fi
