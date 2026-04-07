#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for repo in "$ROOT" "$ROOT/qmk_firmware" "$ROOT/qmk_userspace"; do
  printf '\n== %s ==\n' "$repo"
  git -C "$repo" status -sb
done
