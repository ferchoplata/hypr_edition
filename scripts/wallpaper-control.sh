#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="${HYPR_EDITION_WALLPAPER_DIR:-${HOME}/Pictures/HyprEdition}"
state_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/hypr-edition"
state_file="${state_dir}/wallpaper-index"
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
  next) selected_index=$(( (current_index + 1) % ${#wallpapers[@]} )) ;;
  previous|prev) selected_index=$(( (current_index - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]} )) ;;
  *)
    printf 'Uso: %s [next|previous]\n' "${0##*/}" >&2
    exit 2
    ;;
esac

selected_wallpaper="${wallpapers[selected_index]}"

if ! hyprctl hyprpaper reload ",${selected_wallpaper}" >/dev/null 2>&1; then
  hyprctl hyprpaper preload "${selected_wallpaper}" >/dev/null
  hyprctl hyprpaper wallpaper ",${selected_wallpaper}" >/dev/null
fi

mkdir -p "${state_dir}" "$(dirname "${hyprpaper_config}")"
printf '%s\n' "${selected_index}" > "${state_file}"
cat > "${hyprpaper_config}" <<EOF
preload = ${selected_wallpaper}
wallpaper = ,${selected_wallpaper}
splash = false
EOF

if command -v notify-send >/dev/null 2>&1; then
  notify-send -a "Hypr Edition" "Fondo cambiado" "$(basename "${selected_wallpaper}")"
fi
