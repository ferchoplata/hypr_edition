#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${ROOT_DIR}"

files=(
  install.sh
  scripts/preflight.sh
  scripts/launch-kitty.sh
  scripts/waybar-theme.sh
  lib/backup.sh
  lib/common.sh
  lib/detect.sh
  lib/dotfiles.sh
  lib/packages.sh
  lib/report.sh
  lib/session.sh
)

for file in "${files[@]}"; do
  bash -n "${file}"
done

if command -v python3 >/dev/null 2>&1; then
  while IFS= read -r -d '' file; do
    python3 -m json.tool "${file}" >/dev/null
  done < <(find config -type f \( -name '*.json' -o -name '*.jsonc' \) -print0)
else
  printf '[WARN] python3 no esta instalado; no se validaron los archivos JSON.\n' >&2
fi

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "${files[@]}"
else
  printf '[WARN] shellcheck no esta instalado; solo se valido bash -n.\n' >&2
fi

printf '[OK] Validacion terminada.\n'
