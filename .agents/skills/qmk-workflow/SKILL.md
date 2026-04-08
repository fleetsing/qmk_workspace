---
name: qmk-workflow
description: Use for analyzing, debugging, or modifying this QMK workspace for the fleetsing Charybdis 3x5 setup. Trigger for tasks about keymaps, userspace features, custom keyboard definitions, build targets, compile failures, feature placement, or deciding whether a change belongs in qmk_firmware or qmk_userspace.
---

1. Identify the workspace layout before doing anything else.
    - If the parent directory contains `AGENTS.md`, `docs/qmk-context.yaml`, `qmk_firmware/`, and `qmk_userspace/`, treat that parent as the workspace root.
    - Otherwise, work with the current repository as the available scope.
2. Read the current repository's local `AGENTS.md` if present.
3. If a workspace root was found in step 1, also read `<workspace-root>/AGENTS.md` and `<workspace-root>/docs/qmk-context.yaml`.
4. If the session was started in `qmk_firmware/` or `qmk_userspace/`, inspect the sibling repository when the task may cross the firmware/userspace boundary.
5. Prefer local checked-out code and local QMK docs inside `qmk_firmware/docs/`. Use official QMK docs only when the local workspace does not settle the question.
6. If the task needs userspace commands or builds, confirm the overlay setup from `docs/qmk-context.yaml` first instead of assuming `user.overlay_dir` is already configured.
7. Inventory the files actually involved before proposing a change. Search for hook functions, feature flags, custom keycodes, and inherited parent keyboard metadata instead of assuming everything relevant lives in the custom `fleetsing36/` directory.
8.   Respect these workspace-specific gotchas:
    - Generic userspace hook dispatch lives in `users/fleetsing/fleetsing.c`, with pointing/layer-state handling in `users/fleetsing/pointing.c`
    - Charybdis 3x5 layout-specific positional aliases, combos, and Auto Shift behavior live under `users/fleetsing/layouts/charybdis_3x5/`
    - Combo definitions are included into `keymap.c` from `users/fleetsing/layouts/charybdis_3x5/combos.def` so QMK keymap introspection can still see `key_combos`
    - `QK_REP` and `QK_AREP` rely on QMK core repeat-key handling directly; there is no userspace repeat module in the current snapshot
    - Scroll-side selection in `users/fleetsing/pointing.c` only chooses which sensor motion becomes scroll input; Charybdis firmware remains the source of truth for live DPI and sniping DPI
    - `users/fleetsing/config.h` exists and is currently a placeholder
    - the inherited parent `keyboards/bastardkb/charybdis/3x5/info.json` metadata has been aligned with the 36-key `fleetsing36/keyboard.json` layout; if a layout-count warning reappears, verify both files before assuming the userspace keymap is wrong
    - Prefer keeping firmware changes inside `keyboards/bastardkb/charybdis/3x5/fleetsing36/`; treat parent `keyboards/bastardkb/charybdis/` files as upstream-like and only change them for small fixes that cannot be cleanly contained in the custom board or userspace
    - The current intentional parent-file diffs are limited to the 36-key layout metadata fix in `keyboards/bastardkb/charybdis/3x5/info.json` and the CPI reapply after config sync in `keyboards/bastardkb/charybdis/charybdis.c`
    - Generated `.hex` and `.uf2` files in the userspace repo root are build outputs, not source files
9. Make the smallest change that cleanly solves the task.
10.  Verification policy:
    - For userspace/overlay problems, start with `qmk userspace-doctor`
    - For normal keymap or board work, prefer `qmk compile -kb bastardkb/charybdis/3x5/fleetsing36 -km fleetsing`
    - For shared or broad userspace changes, use `qmk userspace-compile -c -p` when practical
    - Run `qmk format-c` on changed C files when appropriate
11. In the final response, always include:
    - what changed
    - why the chosen files were the correct layer
    - what verification command was used or should be used
    - any stale or ambiguous workspace details discovered during the task
