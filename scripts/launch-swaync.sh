#!/usr/bin/env bash
set -euo pipefail

if pgrep -x swaync >/dev/null 2>&1; then
  exit 0
fi

if command -v systemd-detect-virt >/dev/null 2>&1 \
  && systemd-detect-virt --vm --quiet; then
  exec env LIBGL_ALWAYS_SOFTWARE=1 swaync
fi

exec swaync
