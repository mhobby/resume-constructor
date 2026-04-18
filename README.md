# Claude Resume Constructor

A Claude Code plugin that adds a `/resume-constructor:construct` Skill to your Claude Code environment. This Skill generates tailored CVs and cover letters from your professional profile. The profile provides the facts, AI handles the reasoning and deterministic scripts handle the PDF rendering.

## How it works

1. You maintain a single `profile/professional_profile.md` — your career history, skills, achievements, and known gaps
2. Drop in a job description and run `/resume-constructor:construct` — Claude reads your profile, maps it against the JD, asks targeted questions to fill gaps, drafts content for your approval, then generates a polished PDF
3. Any new information you provide is saved back to the profile so it's never asked twice

The output is a clean, A4 PDF with selectable text — no rasterised layouts, no Google Fonts rendering issues.

## Installation

### 1. Install the plugin

```
/plugin install github:mhobby1979/resume-constructor
```

This runs `scripts/setup.sh` automatically, which installs `uv`, Python dependencies, and WeasyPrint system libraries.

### 2. Set up your profile

```bash
cp profile/professional_profile_template.md profile/professional_profile.md
```

Open `profile/professional_profile.md` and fill it in. The more detail you provide, the better the output.

## Usage

```
/resume-constructor:construct
```

Paste in a job description, name a role, or ask for a general CV. Claude handles the rest.

### Drop in a job description

Place the JD file in `job_descriptions/<Org>/` before starting, or paste the text directly in chat.

## Project structure

```
.claude-plugin/
  plugin.json                            # Plugin manifest
skills/
  construct/
    SKILL.md                             # Main skill
    workflows/
      job_application.md                 # Step-by-step SOP
    tools/
      build_cv.py                        # Renders HTML → PDF via WeasyPrint
scripts/
  setup.sh                               # Dependency installer
profile/
  professional_profile_template.md       # Copy this and fill it in
  professional_profile.md                # Your profile (stays local)
.tmp/                                    # Intermediate working files
deliverables/                            # Output PDFs
job_descriptions/                        # Input JDs
```

## PDF rendering notes

PDFs are generated with [WeasyPrint](https://weasyprint.org/). The HTML Claude generates follows specific constraints to ensure text is selectable:

- No `display: flex` or `display: grid` — use `display: table`/`display: table-cell` for columns
- No external fonts — system fonts only (`'Helvetica Neue', Arial, sans-serif`)
- No float-based clearfix

These constraints are documented in `skills/construct/workflows/job_application.md` and enforced by the Skill.

On macOS, the build command is prefixed with `DYLD_LIBRARY_PATH=/opt/homebrew/lib` — this is handled automatically by the skill.
