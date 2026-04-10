# QMK Workspace Metadata

This repository is the outer workspace for a split QMK setup built around a
custom Charybdis Nano 36-key board and a separate external userspace.

It does not hold the primary firmware or keymap history itself. Instead, it
tracks the workspace-level material that ties the two code repositories
together:

- shared workspace documentation
- Codex and agent instructions
- canonical mutable workspace facts
- pinned references to the paired firmware and userspace revisions

The code repositories live alongside this repo as sibling directories:

- `./qmk_firmware/`
- `./qmk_userspace/`

## Repository Links

- Workspace metadata repo:
  <https://github.com/fleetsing/qmk_workspace>
- Userspace repo:
  <https://github.com/fleetsing/qmk_userspace>
- Firmware repo:
  <https://github.com/fleetsing/qmk_firmware>

## What To Read First

- `AGENTS.md`
  Workspace policy, repository ownership, and editing expectations.
- `docs/qmk-context.yaml`
  Canonical mutable facts for the current workspace: active targets, paths,
  verification commands, and gotchas.
- `docs/repo-refs.txt`
  Pinned references for the matching firmware/userspace repository pair.

## Current Active Target

- Keyboard: `bastardkb/charybdis/3x5/fleetsing36`
- Keymap: `fleetsing`
- Primary compile command:
  `qmk compile -kb bastardkb/charybdis/3x5/fleetsing36 -km fleetsing`

## Workspace Layout

- `qmk_firmware/`
  Near-upstream QMK fork plus the custom board definition.
- `qmk_userspace/`
  External userspace repo containing the active keymap and shared personal
  logic.
- `.agents/skills/qmk-workflow/`
  Canonical local skill for workspace-specific QMK work.

Taken together, the three repositories describe the full setup:

- `qmk_workspace` explains how the workspace is assembled and how the two code
  repositories relate to each other
- `qmk_userspace` contains the active keymap, shared user logic, and
  keyboard-facing behavior docs
- `qmk_firmware` contains the custom board definition and hardware-oriented QMK
  changes

## Codex Launch Commands

Launch Codex from the repository you expect to edit most, while also granting
the parent workspace so it can read and update shared metadata.

- Userspace-first:
  `codex -C ~/qmk/qmk_userspace --add-dir ~/qmk`
- Firmware-first:
  `codex -C ~/qmk/qmk_firmware --add-dir ~/qmk`

## Workspace Helpers

- `scripts/status-all.sh`
  Show `git status -sb` in the workspace, firmware repo, and userspace repo.
- `scripts/qgit`
  Run the same `git` command across all three repositories.

Examples:

- `scripts/qgit status -sb`
- `scripts/qgit --changed add .`
- `scripts/qgit --changed commit -m "Update docs"`
- `scripts/qgit --changed push`

## Setup

1. Clone this workspace metadata repository to `~/qmk`.
2. Clone the firmware and userspace repositories into `~/qmk/qmk_firmware` and
   `~/qmk/qmk_userspace`.
3. Ensure the canonical QMK workflow skill is available at
   `~/.agents/skills/qmk-workflow`.
4. Configure the QMK external userspace path:
   `qmk config user.overlay_dir="$(realpath qmk_userspace)"`
5. Run the workspace health check:
   `qmk userspace-doctor`

## Notes

- Treat `docs/qmk-context.yaml` as the source of truth for mutable workspace
  facts.
- Historical `.hex` and `.uf2` files may exist in `qmk_userspace/`, but they
  are generated artifacts rather than the source of truth for active targets.
