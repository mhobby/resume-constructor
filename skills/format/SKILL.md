---
description: Convert approved CV or cover letter markdown to HTML and PDF. Usage: /resume-constructor:format <path-to-markdown>
---

If Python deps or PDF rendering are not ready (first install, or WeasyPrint errors), use `/resume-constructor:setup` before continuing.

All paths (`profile/`, `.tmp/`, `deliverables/`) are relative to the **current project root** (the workspace where the user is working), not inside the plugin install directory.

Follow these steps precisely.

## Step 1 — Resolve input

You need **exactly one** approved markdown file per invocation.

**Path sources (in order):**

1. **Slash command argument** — `/resume-constructor:format <path-to-markdown>` (relative to project root or absolute).
2. **Same-session handoff** — after `/resume-constructor:construct`, the user may say to format or continue without re-invoking the slash command; use the approved draft path(s) from that session.
3. **Chat** — if neither applies, ask the user for the path to the approved `.md` file.

Verify the file exists. If the path is missing or wrong, stop and ask for a valid path — do not guess.

Read naming rules in `${CLAUDE_PLUGIN_ROOT}/skills/format/workflows/format_constraints.md` when available, otherwise `skills/format/workflows/format_constraints.md` from the project. Derive output names from the input basename, e.g.:

- `.tmp/<ORG>_<ROLE>_CV_draft.md` → `.tmp/<ORG>_<ROLE>_CV.html` → `deliverables/<ORG>_<ROLE>_CV.pdf`
- `.tmp/<ORG>_<ROLE>_CoverLetter_draft.md` → `.tmp/<ORG>_<ROLE>_CoverLetter.html` → `deliverables/<ORG>_<ROLE>_CoverLetter.pdf`

**One file per invocation.** For both CV and cover letter, run this skill twice with each approved draft path.

**Prerequisites:** content must already be approved (via construct or explicit user confirmation). Do not format unreviewed drafts.

## Step 2 — Convert to HTML

1. Read the approved markdown in full.
2. Write HTML to `.tmp/<name>.html` in the project — all CSS inline in `<style>` tags within `<head>`.
3. Follow the WeasyPrint constraints in `skills/format/workflows/format_constraints.md` without exception (no flex/grid, no external fonts, use table-based columns).
4. Each CV role block (title, dates, bullets) must be wrapped so it never splits across a page — if a role is too long to fit, flag it to the user and suggest trimming before building the PDF.

## Step 3 — Build PDF

Build the PDF from the **plugin’s** Python environment (the user’s project may not contain `pyproject.toml`). Use the project’s absolute paths for input and output so the PDF lands in this project’s `deliverables/`:

```
cd "${CLAUDE_PLUGIN_ROOT}" && DYLD_LIBRARY_PATH=/opt/homebrew/lib uv run skills/format/tools/build_cv.py --input "<PROJECT_ABS>/.tmp/<name>.html" --output "<PROJECT_ABS>/deliverables/<name>.pdf"
```

Replace `<PROJECT_ABS>` with the resolved absolute path to the project root (session working directory). If `CLAUDE_PLUGIN_ROOT` is unset, `cd` to the repository root that contains `skills/format/tools/build_cv.py` instead. On Linux, omit `DYLD_LIBRARY_PATH=...` unless you know it is required.

Verify: text is selectable, no overlap, no orphaned headings, margins correct.

## Step 4 — Confirm deliverables

Confirm the PDF path to the user. If the user added new career facts during HTML review (unusual), update `profile/professional_profile.md` — construct normally saves profile updates during drafting.

---

## Hard rules

- Never generate a PDF without explicit user approval of the markdown content first
- Never change approved wording when converting markdown to HTML
- Each role block (title, dates, bullets) must be wrapped so it never splits across a page — if a role is too long to fit, flag it to the user and suggest trimming before generating the PDF
- Do not create or overwrite workflow files without asking — they are the instructions and must be preserved and refined, not discarded
- When a tool fails: read the full error, fix the script, retest, then update the workflow with what you learned
- Everything in `.tmp/` is disposable. Everything in `deliverables/` is not — never delete deliverables
