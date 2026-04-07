# QMK workspace instructions

This workspace is a two-repository QMK setup.

- `qmk_firmware/` is an almost-stock fork of upstream QMK.
- `qmk_userspace/` is the external userspace repository.
- These two repositories are meant to be read together.

Prefer launching Codex from the repository you expect to edit most, and grant the parent workspace as an extra writable directory.

Use:
- userspace-first tasks: `codex -C ~/qmk/qmk_userspace --add-dir ~/qmk`
- firmware-first tasks: `codex -C ~/qmk/qmk_firmware --add-dir ~/qmk`

This keeps the working directory anchored to the active repo while still letting Codex read and edit the parent workspace metadata and the sibling repo.

## Skill discovery

The canonical QMK skill lives in `./.agents/skills/qmk-workflow/` so that `$qmk-workflow` is available regardless of which repo the session starts in.

## Workspace map

- Custom board definition: `qmk_firmware/keyboards/bastardkb/charybdis/3x5/fleetsing36/`
- Active userspace keymap: `qmk_userspace/keyboards/bastardkb/charybdis/3x5/fleetsing36/keymaps/fleetsing/`
- Shared userspace code: `qmk_userspace/users/fleetsing/`
- Userspace build target file: `qmk_userspace/qmk.json`
- Additional workspace context: `docs/qmk-context.yaml`

## Source of truth order

Use sources in this order:

1. Local checked-out code in this workspace.
2. Local documentation in `qmk_firmware/docs/` and nearby keyboard/keymap files.
3. Official QMK documentation.
4. Other web sources only when necessary.

Do not rely on memory or random old forum/blog snippets when local code or official docs can answer the question.

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

## Current layout details

The active custom keymap lives here:
`qmk_userspace/keyboards/bastardkb/charybdis/3x5/fleetsing36/keymaps/fleetsing/`

The shared user folder lives here:
`qmk_userspace/users/fleetsing/`

Shared enums and custom keycodes currently live in:
`qmk_userspace/users/fleetsing/fleetsing.h`

Generated firmware artifacts exist in the userspace repository root as `.hex` and `.uf2` files. Treat them as build outputs and do not edit, rename, or delete them unless the task explicitly asks for that.

## Important gotchas for this workspace

- `qmk_userspace/users/fleetsing/rules.mk` currently includes `fleetsing.c`, `pointing.c`, `display.c`, and `haptics.c`.
- `qmk_userspace/users/fleetsing/fi_autoshift.c` exists, but it is not currently compiled by `users/fleetsing/rules.mk`.
- Auto Shift logic is currently implemented inside the active `keymap.c`, not in the uncompiled `fi_autoshift.c`.
- Do not assume that editing `fi_autoshift.c` changes behavior unless you also intentionally migrate wiring and verification.
- The custom board target is `bastardkb/charybdis/3x5/fleetsing36`.
- In `keyboard.json`, `development_board: elite_c` and `pin_compatible: elite_c` describe the board's Elite-C-compatible pinout metadata. They do not imply that a separate `elitec/...` keyboard path is active in this workspace.
- Actual build behavior for the custom board is controlled by `qmk_firmware/keyboards/bastardkb/charybdis/3x5/fleetsing36/rules.mk`, which sets `CONVERT_TO = rp2040_ce`.
- Treat `development_board` and `pin_compatible` as hardware metadata, not as instructions to switch keyboard targets. Do not infer alternate keyboard paths unless they exist in the checked-out tree and are confirmed by the QMK CLI.
- Preserve the current split between `keyboard.json`, `config.h`, and `rules.mk` unless the task specifically requires moving settings.

## Build targets and verification

Start by reading `qmk_userspace/qmk.json`.

Known build targets currently listed there:

- `bastardkb/charybdis/3x5/fleetsing36:fleetsing`

Use the narrowest proof that matches the change:

- Overlay/userspace wiring checks: `qmk userspace-doctor`
- Primary custom-board compile: `qmk compile -kb bastardkb/charybdis/3x5/fleetsing36 -km fleetsing`
- Shared userspace or broad changes: `qmk userspace-compile -c -p`
- Format changed C files when appropriate: `qmk format-c <changed-files>`

If a requested change affects shared userspace logic, prefer at least the primary compile plus `qmk userspace-compile -c -p` when practical.

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
