# QMK workspace metadata

This repository contains the workspace-level metadata for my QMK environment. It
is intentionally separate from the actual code repositories and only tracks root-level
instructions, Codex context, helper scripts, and similar workspace files.

The firmware and userspace repositories are cloned separately into this workspace
as `./qmk_firmware/` and `./qmk_userspace/`. They are managed as independent Git
repositories with their own remotes and history.

The canonical Codex skill for this workspace is located at `./.agents/skills/qmk-workflow/`.

To set up the workpsace, follow these steps:

1. clone the root metadata repo to ~/qmk
2. clone qmk_firmware and qmk_userspace into the two child directories
3. recreate the ~/.gents/skills/qmk-workflow symlink
4. run qmk config user.overlay_dir=...
5. run qmk userspace-doctor
The outer repo backs up the Codex context; the inner repos back up the code;
and docs/repo-refs.txt can pin the exact combination you were using when needed.
