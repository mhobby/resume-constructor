# Workflow: Job Application — CV + Cover Letter / Personal Statement

## Objective
Produce a tailored application (CV and optionally a cover letter or personal statement) for a target role, grounded in the canonical profile and approved by the user before PDF generation.

## Inputs Required
- Job description (PDF or text) placed in `job_descriptions/<org>/`
- Target role name and organisation
- User's approval at the content review stage (mandatory before PDF generation)

## Output
- `deliverables/<ORG>_<ROLE>_CV.pdf`
- `deliverables/<ORG>_<ROLE>_CoverLetter.pdf` (if required)

---

## Steps

### 1. Read the canonical profile
Always start here. Read `profile/professional_profile.md` in full before touching the JD.

### 2. Ingest and parse the JD
Read the JD and extract:
- The selection criteria (named or implied)
- Any implicit requirements (scale of org, sector experience, seniority signals)
- Hard requirements vs nice-to-haves

### 3. Map fit against the profile
For each criterion, score coverage: **Strong / Partial / Gap**. Note which specific profile entries address each criterion. Be honest — do not claim fit that isn't there.

### 4. Ask targeted gap questions
For any **Partial** or **Gap** criteria, ask the user one targeted question at a time. Wait for an answer before asking the next question.

Evaluate each answer:
- If strong → draft a statement that improves fit
- If thin → note the gap honestly; do not over-claim

### 5. Save new information to the profile
Any confirmed fact the user provides (metric, context, outcome) must be written back to `profile/professional_profile.md` immediately. This is the living source of truth.

### 6. Draft markdown content
Produce markdown drafts:
- **CV draft** → `.tmp/<ORG>_<ROLE>_CV_draft.md`
- **Cover letter / personal statement draft** → `.tmp/<ORG>_<ROLE>_CoverLetter_draft.md` (if required)

Present to the user and pause. Do not proceed until they have reviewed and approved the content. They may edit the markdown files directly.

**CV constraints:**
- Max 2 pages
- Structure: header → summary statement → career history (detailed roles + earlier condensed) → two-column footer (education + additional sections)
- Lead with what matters most for this specific role — reorder sections accordingly
- Quantified impact wherever possible

**Cover letter / personal statement constraints:**
- Max 2 pages
- One section per selection criterion, labelled to match the JD exactly
- Close with a short motivation section (1 paragraph)
- No criterion should be padded — if coverage is thin, keep it short and honest

### 7. Generate HTML
Once the user has approved the content, write the HTML for each document.

**HTML requirements:**
- All CSS inline in `<style>` tags within the `<head>`
- Follow all WeasyPrint constraints listed below — no exceptions
- Palette: dark navy header (`#0f172a`), white body, blue accent (`#2563eb`), light blue highlights
- System fonts only: `'Helvetica Neue', Arial, sans-serif`
- Save to `.tmp/<ORG>_<ROLE>_CV.html` (and `.tmp/<ORG>_<ROLE>_CoverLetter.html` if applicable)

Do not change any approved wording when converting from markdown to HTML.

### 8. Build PDFs
```bash
DYLD_LIBRARY_PATH=/opt/homebrew/lib uv run tools/build_cv.py \
  --input .tmp/<ORG>_<ROLE>_CV.html \
  --output deliverables/<ORG>_<ROLE>_CV.pdf
```

Repeat for the cover letter if applicable. Outputs go to `deliverables/`.

### 9. Verify the PDFs
Check each PDF for:
- Text is selectable and copyable (critical — see WeasyPrint constraints below)
- No text overlap
- No orphaned section headings
- No sections split across pages unnecessarily
- Page 2 top margin present
- No content truncated at page boundaries

---

## WeasyPrint CSS Constraints (Critical)

These rules must be followed in every HTML document. Violating them causes silent rendering failures.

| Rule | Why |
|---|---|
| No `display: flex` or `display: grid` | WeasyPrint rasterises these as images — text becomes non-selectable |
| Use `display: table` / `display: table-cell` for columns | Reliable multi-column layout; text remains selectable |
| No float-based clearfix (`overflow: hidden`) | Floats don't clear correctly in WeasyPrint; causes text overlap |
| No Google Fonts (`@import url(...)`) | WeasyPrint cannot fetch external URLs at render time; text renders as outlines |
| System fonts only | `'Helvetica Neue', Arial, sans-serif` |
| Page margins | `@page { size: A4; margin: 28px 0 0 0; }` with `@page :first { margin-top: 0; }` — applied by `build_cv.py` |
| Section headings | `page-break-after: avoid; break-after: avoid` on all headings |
| Sections/roles | `page-break-inside: avoid; break-inside: avoid` on cover letter sections; avoid on CV role headers |

---

## Writing Quality Guidelines

- No em dashes (`—`) — use a comma, colon, or restructure the sentence
- No hedging: "typically", "might", "may" — take clear positions
- No filler phrases: "proven track record", "strong communication skills", "passionate about"
- Vary sentence openings — avoid starting consecutive bullets the same way
- Lead every bullet with the impact or outcome, not the activity
- Keep the voice consistent throughout — match the register of the profile

---

## File Naming Convention
```
job_descriptions/<Org>/                      # JD input
.tmp/<ORG>_<ROLE>_CV_draft.md
.tmp/<ORG>_<ROLE>_CoverLetter_draft.md
.tmp/<ORG>_<ROLE>_CV.html
.tmp/<ORG>_<ROLE>_CoverLetter.html
deliverables/<ORG>_<ROLE>_CV.pdf
deliverables/<ORG>_<ROLE>_CoverLetter.pdf
```
