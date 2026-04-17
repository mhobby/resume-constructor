# Claude Resume Constructor

A Claude Code skill for generating tailored CVs and cover letters from your professional profile. Built on the WAT framework (Workflows, Agents, Tools) — AI handles the reasoning, deterministic scripts handle the PDF rendering.

## How it works

1. You maintain a single `profile/professional_profile.md` — your career history, skills, achievements, and known gaps
2. When you drop in a job description and type `/resume_construct`, Claude reads your profile, maps it against the JD, asks targeted questions to fill gaps, drafts content for your approval, then generates a polished PDF
3. Any new information you provide is saved back to the profile so it's never asked twice

The output is a clean, A4 PDF with selectable text — no rasterised layouts, no Google Fonts rendering issues.

## Requirements

- [Claude Code](https://claude.ai/code) CLI installed
- [uv](https://docs.astral.sh/uv/) (Python package manager)
- WeasyPrint system libraries (for PDF rendering)

## Setup

### 1. Clone the repo

```bash
git@github.com:<your-username>/resume-constructor.git
cd resume-constructor
```

### 2. Install dependencies

```bash
uv sync
```

### 3. Install WeasyPrint system libraries

**macOS (Homebrew):**
```bash
brew install weasyprint
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt-get install weasyprint
```

### 4. Set up your profile

```bash
cp profile/professional_profile_template.md profile/professional_profile.md
```

Open `profile/professional_profile.md` and fill it in. The more detail you provide, the better the output.

### 5. (Optional) Set up Google Drive

If your source material (old CVs, references) lives in Google Drive, you can fetch files directly.

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project, enable the Drive API
3. Create OAuth 2.0 credentials (Desktop app type)
4. Download the credentials JSON and save to `credentials/google_credentials.json`

On first use, `uv run tools/drive_fetch.py <file_id>` will open a browser to authorise access and save a token.

## Usage

Open the project in Claude Code:

```bash
claude
```

Then use the `/resume_construct` skill:

```
/resume_construct
```

Claude will ask what you need — either paste in a job description, name a role, or ask for a general CV.

### Drop in a job description

Place the JD file in `job_descriptions/<Org>/` before starting, or paste the text directly in the chat.

### Fetch a file from Google Drive

```bash
uv run tools/drive_fetch.py <file_id>
# or list accessible files:
uv run tools/drive_fetch.py --list
```

Files land in `.tmp/`.

## Project structure

```
.claude/
  skills/
    resume_construct.md          # Claude Code skill — the /resume_construct command
profile/
  professional_profile_template.md   # Copy this and fill it in
  professional_profile.md            # Your profile (gitignored — never commit this)
workflows/
  job_application.md   # Step-by-step SOP for generating applications
tools/
  build_cv.py          # Renders HTML → PDF via WeasyPrint
  drive_fetch.py       # Fetches files from Google Drive
.tmp/                  # Intermediate files (gitignored)
deliverables/          # Output PDFs (gitignored)
job_descriptions/      # Input JDs (gitignored)
```

## What stays private

The following are gitignored and never committed:

| Path | Contains |
|---|---|
| `profile/professional_profile.md` | Your personal career data |
| `deliverables/` | Generated PDFs |
| `job_descriptions/` | Job descriptions you've applied for |
| `.tmp/` | Intermediate HTML/markdown drafts |
| `credentials/` | Google OAuth credentials |
| `.env` | API keys |

## PDF rendering notes

PDFs are generated with [WeasyPrint](https://weasyprint.org/). The HTML Claude generates follows specific constraints to ensure text is selectable (not rasterised) in the output:

- No `display: flex` or `display: grid` — use `display: table`/`display: table-cell` for columns
- No external fonts — system fonts only (`'Helvetica Neue', Arial, sans-serif`)
- No float-based clearfix

These constraints are documented in `workflows/job_application.md` and enforced by the skill.

On macOS, prefix the build command with `DYLD_LIBRARY_PATH=/opt/homebrew/lib` to ensure WeasyPrint finds its system libraries.
