#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec codex -C "$ROOT/qmk_firmware" --add-dir "$ROOT" "$@"
