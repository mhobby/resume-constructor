# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

# Agent Instructions

You're working inside the **WAT framework** (Workflows, Agents, Tools). This architecture separates concerns so that probabilistic AI handles reasoning while deterministic code handles execution. That separation is what makes this system reliable.

## The WAT Architecture

**Layer 1: Workflows (The Instructions)**
- Markdown SOPs stored in `workflows/`
- Each workflow defines the objective, required inputs, which tools to use, expected outputs, and how to handle edge cases
- Written in plain language, the same way you'd brief someone on your team

**Layer 2: Agents (The Decision-Maker)**
- This is your role. You're responsible for intelligent coordination.
- Read the relevant workflow, run tools in the correct sequence, handle failures gracefully, and ask clarifying questions when needed
- You connect intent to execution without trying to do everything yourself
- Example: If you need to pull data from a website, don't attempt it directly. Read `workflows/scrape_website.md`, figure out the required inputs, then execute `tools/scrape_single_site.py`

**Layer 3: Tools (The Execution)**
- Python scripts in `tools/` that do the actual work
- API calls, data transformations, file operations, database queries
- Credentials and API keys are stored in `.env`
- These scripts are consistent, testable, and fast

**Why this matters:** When AI tries to handle every step directly, accuracy drops fast. If each step is 90% accurate, you're down to 59% success after just five steps. By offloading execution to deterministic scripts, you stay focused on orchestration and decision-making where you excel.

## How to Operate

**1. Look for existing tools first**
Before building anything new, check `tools/` based on what your workflow requires. Only create new scripts when nothing exists for that task.

**2. Learn and adapt when things fail**
When you hit an error:
- Read the full error message and trace
- Fix the script and retest (if it uses paid API calls or credits, check with the user before running again)
- Document what you learned in the workflow (rate limits, timing quirks, unexpected behaviour)

**3. Keep workflows current**
Workflows should evolve as you learn. When you find better methods, discover constraints, or encounter recurring issues, update the workflow. Don't create or overwrite workflows without asking unless explicitly told to — these are the instructions and need to be preserved and refined, not tossed after one use.

## The Self-Improvement Loop

Every failure is a chance to make the system stronger:
1. Identify what broke
2. Fix the tool
3. Verify the fix works
4. Update the workflow with the new approach
5. Move on with a more robust system

## File Structure

**What goes where:**
- **Deliverables**: Final outputs saved locally in `deliverables/` (e.g. PDFs). Not disposable — preserve these.
- **Intermediates**: Temporary processing files in `.tmp/` that can be regenerated

**Directory layout:**
```
.tmp/           # Temporary files (intermediate HTML exports). Regenerated as needed.
deliverables/   # Final outputs (resume PDFs). Not disposable — preserve these.
profile/        # Canonical professional profile (fill in professional_profile.md)
tools/          # Python scripts for deterministic execution
workflows/      # Markdown SOPs defining what to do and how
.env            # API keys and environment variables (NEVER store secrets anywhere else)
credentials/    # Google OAuth files (gitignored)
```

**Core principle:** Everything in `.tmp/` is disposable and can be regenerated. Everything in `deliverables/` is kept.

## Bottom Line

You sit between what the user wants (workflows) and what actually gets done (tools). Your job is to read instructions, make smart decisions, call the right tools, recover from errors, and keep improving the system as you go.

Stay pragmatic. Stay reliable. Keep learning.

---

## Resume Project Context

### Subject
The subject of this resume system is defined in `profile/professional_profile.md`. **Always read this before drafting any content.** If it doesn't exist yet, ask the user to copy `profile/professional_profile_template.md` and fill it in.

### Google Drive (optional)
If the subject's source material is stored in Google Drive, fetch files with:
```
uv run tools/drive_fetch.py <file_id>
```
Requires one-time OAuth setup — see README for instructions.

### Canonical profile
`profile/professional_profile.md` is the living source of truth. Update it immediately whenever the user confirms new information — metrics, context, outcomes. This prevents the same questions being asked twice.

### Resume generation process

**Standard process:**
1. Read `profile/professional_profile.md` in full
2. Fill gaps by asking the user — prioritise **quantified impact** (metrics, scale, outcomes). Save any new information back to the profile immediately.
3. Synthesise content into a markdown draft and present it for review — do not proceed until approved
4. After approval, write the content as HTML (following WeasyPrint constraints in `workflows/job_application.md`) to `.tmp/<name>.html`
5. Convert to PDF: `DYLD_LIBRARY_PATH=/opt/homebrew/lib uv run tools/build_cv.py --input .tmp/<name>.html --output deliverables/<name>.pdf`
6. Design: minimal, classic palette (navy/charcoal + white + single accent), generous white space, max 2 pages
7. Save output PDF to `deliverables/`

**When a job description or role details are provided:**
1. Map the JD requirements against `profile/professional_profile.md`
2. Assess fit: identify which requirements are well-covered, partially covered, or missing entirely
3. For gaps, ask targeted questions one at a time — not a long list
4. Evaluate answers honestly: if strong → draft a statement that improves fit; if thin → note the gap, don't over-claim
5. Save any new information back to `profile/professional_profile.md`
6. Reorder and reweight content to lead with what matters most for this role
7. Then follow the standard process from step 3 (markdown review → approval → HTML → PDF)
