# Claude Resume Constructor

A Claude Code plugin that adds Skills to your Claude Code environment:  
- **`/resume-constructor:setup`**, for first-time environment and profile scaffolding  
- **`/resume-constructor:construct`** for tailoring CV and cover letter from your profile  
- **`/resume-constructor:format <path-to-markdown>`** to convert approved drafts to PDF  

The profile provides the facts, AI handles the reasoning, and deterministic scripts handle the PDF rendering.

## How it works

1. You maintain `profile/professional_profile.md` **in each project** where you use the plugin (your career history, skills, achievements, and known gaps). The construct skill creates this file from the bundled template in your project root when it is missing — you are not expected to copy paths under `~/.claude/plugins/`
2. Drop in a job description and run `/resume-constructor:construct` — Claude reads your profile, maps it against the JD, asks targeted questions to fill gaps, and drafts content for your approval
3. After you approve the markdown, run `/resume-constructor:format .tmp/<name>_draft.md` to produce a polished PDF (or ask Claude to continue in the same session)
4. Any new information you provide is saved back to the profile so it's never asked twice

The output is a clean, A4 PDF with selectable text — no rasterised layouts, no Google Fonts rendering issues.

## Installation

### 1. Install the plugin

```
/plugin marketplace add mhobby/resume-constructor
/plugin install resume-constructor@mhobby-resume-constructor
```

After installing, run **`/resume-constructor:setup`** once so Claude can guide you through `scripts/setup.sh` (or run `./scripts/setup.sh` yourself from a git checkout of this repo, or from your installed copy under `~/.claude/plugins/` if you use the marketplace install alone).

### 2. Set up your profile

Run **`/resume-constructor:construct`** in the folder you treat as the project root; if `profile/professional_profile.md` is missing, Claude will add it there from the plugin’s template. Then open **`profile/professional_profile.md`** in that project and fill it in (more detail → better output).

From a **git clone only**, you can still do `cp profile/professional_profile_template.md profile/professional_profile.md` by hand if you prefer.

## Usage

First-time setup:

```
/resume-constructor:setup
```

Generate a CV or cover letter:

```
/resume-constructor:construct
```

Paste in a job description, name a role, or ask for a general CV. After you approve the markdown draft, format it:

```
/resume-constructor:format .tmp/<ORG>_<ROLE>_CV_draft.md
```

Run format again with the cover letter path if you drafted one. You can also say “format it” in the same session after construct without re-invoking the slash command.

### Drop in a job description

Place the JD file in `job_descriptions/<Org>/` before starting, or paste the text directly in chat.

## Project structure

```
.claude-plugin/
  plugin.json                            # Plugin manifest
  marketplace.json                       # Marketplace catalog
skills/
  setup/
    SKILL.md                             # Environment + profile scaffolding
  construct/
    SKILL.md                             # CV / cover letter drafting
  format/
    SKILL.md                             # Markdown → HTML → PDF
    workflows/
      format_constraints.md              # Constraints and quality guidelines
    tools/
      build_cv.py                        # Renders HTML → PDF via WeasyPrint
scripts/
  setup.sh                               # Dependency installer
profile/                                 # In each project where you work (not in ~/.claude/plugins)
  professional_profile_template.md       # Bundled in the plugin; copied into your project when needed
  professional_profile.md                # Your profile in this project (stays local; gitignored in this repo)
.tmp/                                    # Intermediate working files
deliverables/                            # Output PDFs
job_descriptions/                        # Input JDs
```

## PDF rendering notes

PDFs are generated with [WeasyPrint](https://weasyprint.org/). The HTML Claude generates follows specific constraints to ensure text is selectable:

- No `display: flex` or `display: grid` — use `display: table`/`display: table-cell` for columns
- No external fonts — system fonts only (`'Helvetica Neue', Arial, sans-serif`)
- No float-based clearfix

These constraints are documented in `skills/format/workflows/format_constraints.md` and enforced by the format skill.

On macOS, the build command is prefixed with `DYLD_LIBRARY_PATH=/opt/homebrew/lib` — this is handled automatically by the skill.
