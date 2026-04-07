#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/docs/repo-refs.txt"

{
  echo "# QMK workspace repo refs"
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  for repo in qmk_firmware qmk_userspace; do
    echo
    echo "[$repo]"
    echo "branch=$(git -C "$ROOT/$repo" branch --show-current)"
    echo "commit=$(git -C "$ROOT/$repo" rev-parse HEAD)"
    echo "origin=$(git -C "$ROOT/$repo" remote get-url origin)"
  done
} >"$OUT"

echo "Wrote $OUT"
