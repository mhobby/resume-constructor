# Workflow: Job Application — CV + Cover Letter / Personal Statement

## Output files
- `deliverables/<ORG>_<ROLE>_CV.pdf`
- `deliverables/<ORG>_<ROLE>_CoverLetter.pdf` (if required)

---

## CV constraints
- Max 2 pages
- Structure: header → summary statement → career history (detailed roles + earlier condensed) → two-column footer (education + additional sections)
- Lead with what matters most for this specific role — reorder sections accordingly
- Quantified impact wherever possible
- Each role block (title, dates, bullets) must never split across pages

## Cover letter / personal statement constraints
- Max 2 pages
- One section per selection criterion, labelled to match the JD exactly
- Close with a short motivation section (1 paragraph)
- If coverage of a criterion is thin, keep it short and honest — do not pad

## HTML requirements
- All CSS inline in `<style>` tags within the `<head>`
- Palette: dark navy header (`#0f172a`), white body, blue accent (`#2563eb`), light blue highlights
- System fonts only: `'Helvetica Neue', Arial, sans-serif`
- Follow all WeasyPrint constraints below — no exceptions

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
| Sections/roles | `page-break-inside: avoid; break-inside: avoid` on cover letter sections and on every CV role block (header + bullets together) — a role must never split across pages |

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
