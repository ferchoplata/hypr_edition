#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${ROOT_DIR}"

files=(
  install.sh
  scripts/preflight.sh
  lib/backup.sh
  lib/common.sh
  lib/detect.sh
  lib/dotfiles.sh
  lib/packages.sh
  lib/report.sh
)

for file in "${files[@]}"; do
  bash -n "${file}"
done

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "${files[@]}"
else
  printf '[WARN] shellcheck no esta instalado; solo se valido bash -n.\n' >&2
fi

printf '[OK] Validacion terminada.\n'
