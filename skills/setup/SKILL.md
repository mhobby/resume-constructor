---
description: Set up the resume-constructor environment — Python deps, WeasyPrint libraries, and profile scaffolding. Run once after installing the plugin or when PDF builds fail due to missing dependencies.
---

Follow these steps precisely.

## Step 1 — Resolve the plugin root

The setup script lives at `scripts/setup.sh` relative to the plugin root. Determine that directory:

- **Git clone**: the repository root (where `skills/`, `scripts/`, and `profile/` sit).
- **Marketplace install**: the installed plugin directory (often under `~/.claude/plugins/`). Use `${CLAUDE_PLUGIN_ROOT}` when the environment provides it.

If unsure, search for `scripts/setup.sh` starting from the current workspace or ask the user where they cloned or installed the plugin.

## Step 2 — Run the setup script

From the plugin root, run:

```bash
bash scripts/setup.sh
```

Or: `./scripts/setup.sh` if the file is executable.

What it does (do not duplicate this logic in chat — let the script run):

- Installs [uv](https://docs.astral.sh/uv/) via the official installer if `uv` is missing (`curl` to astral.sh).
- Runs `uv sync` for Python dependencies (WeasyPrint, etc.).
- **macOS**: requires Homebrew; installs or upgrades the `weasyprint` formula for native libraries.
- **Linux**: uses `sudo apt-get` for Pango/Cairo/GDK-Pixbuf and related packages.

If the script exits non-zero, read the full output. Common issues:

- **No Homebrew (macOS)**: user must install from [brew.sh](https://brew.sh), then re-run.
- **Linux `sudo`**: user must run the script in a context where `sudo` works, or install the listed packages manually.
- **Network**: `curl` or package downloads may fail — retry or fix proxy/VPN.

Do not bypass the script with ad-hoc installs unless the user explicitly prefers that; keep one supported path.

## Step 3 — Profile file (workspace, not the plugin cache)

The user’s editable profile is always **`profile/professional_profile.md` in their current project** (workspace root), never under `~/.claude/plugins/`.

After environment setup succeeds, if that file is missing:

1. `mkdir -p profile` in the project root.
2. Copy the bundled template into the project: from `${CLAUDE_PLUGIN_ROOT}/profile/professional_profile_template.md` into `profile/professional_profile.md` (same approach as the construct skill — use `cp` with the resolved template path, or read/write).
3. Tell the user to fill `profile/professional_profile.md` in this project, then use `/resume-constructor:construct`.

Do not instruct them to copy or edit files only inside the plugin install directory.

## Step 4 — Confirm

Briefly confirm:

- `uv sync` completed without error.
- On macOS, WeasyPrint libs are present (setup used Homebrew as documented).

Tell the user they can run `/resume-constructor:construct` when the profile is ready. If they hit PDF or import errors later, they can invoke this setup skill again for troubleshooting and re-run `scripts/setup.sh`.

---

## Hard rules

- Never claim setup ran successfully without seeing successful script output (or equivalent user confirmation).
- Never store secrets in the profile or in chat; the profile is career content only.
- Do not modify `skills/construct/workflows/format_constraints.md` or other workflow files during setup — setup is environment + profile scaffolding only.
