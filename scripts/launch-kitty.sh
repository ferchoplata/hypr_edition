#!/usr/bin/env bash
set -euo pipefail

if command -v systemd-detect-virt >/dev/null 2>&1 \
  && systemd-detect-virt --vm --quiet; then
  exec env LIBGL_ALWAYS_SOFTWARE=1 kitty "$@"
fi

exec kitty "$@"
