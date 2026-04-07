# QMK workspace instructions

This workspace contains two QMK repositories plus a parent workspace repository for shared agent metadata.

- `qmk_firmware/` is an almost-stock fork of upstream QMK.
- `qmk_userspace/` is the external userspace repository.
- The parent workspace repo contains shared agent docs, skills, and workspace metadata.
- The QMK repositories are meant to be read together.

Prefer launching Codex from the repository you expect to edit most, and grant the parent workspace as an extra writable directory.

Use:
- userspace-first tasks: `codex -C ~/qmk/qmk_userspace --add-dir ~/qmk`
- firmware-first tasks: `codex -C ~/qmk/qmk_firmware --add-dir ~/qmk`

This keeps the working directory anchored to the active repo while still letting Codex read and edit the parent workspace metadata repo and the sibling QMK repo.

## Skill discovery

The canonical QMK skill lives in `./.agents/skills/qmk-workflow/` so that `$qmk-workflow` is available regardless of which repo the session starts in.

## Canonical Workspace Metadata

Treat `docs/qmk-context.yaml` as the canonical source for mutable workspace facts:

- current paths and file inventories
- active build targets
- verification commands
- current gotchas and known warnings

Use this `AGENTS.md` for policy, repository ownership, and editing expectations. If this file and `docs/qmk-context.yaml` ever disagree on a mutable workspace detail, trust `docs/qmk-context.yaml` and then verify against the checked-out code.

## Workspace Map

- Custom board definition: `qmk_firmware/keyboards/bastardkb/charybdis/3x5/fleetsing36/`
- Active userspace keymap: `qmk_userspace/keyboards/bastardkb/charybdis/3x5/fleetsing36/keymaps/fleetsing/`
- Shared userspace code: `qmk_userspace/users/fleetsing/`
- Userspace build target file: `qmk_userspace/qmk.json`
- Additional workspace context: `docs/qmk-context.yaml`
- Canonical QMK skill: `.agents/skills/qmk-workflow/SKILL.md`

## Source of truth order

Use sources in this order:

1. Local checked-out code in this workspace.
2. Local documentation in `qmk_firmware/docs/` and nearby keyboard/keymap files.
3. Official QMK documentation.
4. Other web sources only when necessary.

Do not rely on memory or random old forum/blog snippets when local code or official docs can answer the question.
For custom board work, inspect inherited parent files such as `qmk_firmware/keyboards/bastardkb/charybdis/3x5/info.json` when behavior or metadata does not line up with the custom `fleetsing36/` directory alone.

## Repository ownership rules

### Changes that belong in `qmk_firmware/`

Use `qmk_firmware/` for hardware- or board-definition work, especially inside:
`qmk_firmware/keyboards/bastardkb/charybdis/3x5/fleetsing36/`

Typical examples:

- `keyboard.json`
- `config.h`
- `rules.mk`
- Matrix, pin, split, transport, and board conversion details
- Hardware-specific definitions that only make sense for this physical board

Assume the rest of `qmk_firmware/` is upstream unless the task clearly requires wider changes.

### Changes that belong in `qmk_userspace/`

Use `qmk_userspace/` for behavior and personal logic.

Typical examples:

- Layer definitions
- Combos, tap dance, repeat/alt-repeat, caps word behavior
- Custom keycodes and shared enums
- OLED, pointing, haptics, and other personal feature logic
- Keymap-level `config.h` and `rules.mk`
- Reusable code in `users/fleetsing/`
- Layout-specific userspace modules in `users/fleetsing/layouts/`

For the exact current file inventory, generated-artifact policy, and workspace gotchas, read `docs/qmk-context.yaml` before editing.

## Build targets and verification

Read `docs/qmk-context.yaml` for the current overlay prerequisite, active targets, verification commands, and known compile warnings.
Use the narrowest proof that matches the change and do not infer active targets from artifact names in the userspace repo root.

## Required editing behavior

Before editing:

1. Identify the target keyboard path, keymap path, shared user files, and verification command.
2. Decide whether the change belongs in firmware, userspace, or both.
3. Read nearby files before making assumptions.

While editing:

- Keep diffs minimal.
- Avoid opportunistic refactors.
- Preserve existing naming and structure unless the task is explicitly a cleanup or migration.
- If there is a choice between several plausible homes for a change, explain why the chosen file is the correct layer.

After editing:

1. Summarize exactly which files changed.
2. Explain why each changed file belongs in firmware or userspace.
3. Report the verification command that should be run, or the one that was run if available.
4. Call out any uncertain or stale targets rather than silently assuming they work.
