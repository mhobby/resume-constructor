# Workflow: Job Application — CV + Cover Letter / Personal Statement

## Output files
- `applications/<ORG>_<ROLE>/deliverable/<ORG>_<ROLE>_CV.pdf`
- `applications/<ORG>_<ROLE>/deliverable/<ORG>_<ROLE>_CoverLetter.pdf` (if required)

---

## CV constraints
- Max 2 pages
- Structure: header (name + contact only, no tagline) → summary statement → career history (detailed roles + earlier condensed) → Education → Selected Talks and Patents
- **Education and Selected Talks and Patents are always stacked vertically as separate sections — never side-by-side in a two-column layout**
- Summary statement: a single dense paragraph, not several short sentences of abstract framing. Lead with a role-specific identity label, then pack in 2-4 concrete, quantified achievements pulled from different roles. No bold formatting in the summary itself — save bold for the bullets below
- Career history bullets: bold whole achievement clauses, not just the bare number, so the emphasis reads standalone (see Writing Quality Guidelines)
- Earlier career: condense into a table (Role | Detail | Dates) rather than full bullets
- Education: simple bullet list, "Degree — Institution" (no dates column)
- Selected Talks and Patents: simple bullet list, no table
- Lead with what matters most for this specific role — reorder and select bullets/talks accordingly
- Quantified impact wherever possible
- Each role block (title, dates, bullets) must never split across pages

## Cover letter / personal statement constraints
- Max 2 pages
- First-person, flowing narrative of roughly 5 unlabelled paragraphs organised thematically, not one labelled section per JD criterion. A typical shape: opening hook with cross-role quantified proof and a bridge to this specific role → strategy/leadership → technical delivery and engineering standards → team-building → closing motivation tied to the specific company
- Header includes a subtitle line under the name: "Cover Letter — <Role>, <Company>"
- Close with a short, genuine motivation paragraph tied to the specific company, not a generic sign-off
- If a JD criterion is addressed in the letter and the evidence for it is genuinely thin, keep that section honest and don't oversell it. But do not proactively volunteer gaps or weaknesses that aren't required to address a stated criterion (e.g. don't add a line like "I have not worked in X" unless the letter is actively making a claim about X) — the letter's job is to make the case for hire, not to disclose weaknesses unprompted

## HTML requirements
- All CSS inline in `<style>` tags within the `<head>`
- Palette: dark navy header (`#0f172a`), white body, blue accent (`#2563eb`), light blue highlights
- System fonts only: `'Helvetica Neue', Arial, sans-serif`
- Follow all WeasyPrint constraints below — no exceptions
- **Respect line breaks the user adds in the approved markdown.** If a paragraph (most often the summary statement) is split across separate lines with no blank line between them, render each line as its own `<p>` in the HTML rather than collapsing them back into one flowing block. Use a tighter-margin paragraph class (e.g. `margin-bottom: 6px`) between these split lines so they read as one visually grouped statement, not disconnected paragraphs, and keep the standard larger margin only after the last line before the next section

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
applications/<ORG>_<ROLE>/
  job_description/                           # JD input
  draft/<ORG>_<ROLE>_CV_draft.md
  draft/<ORG>_<ROLE>_CoverLetter_draft.md
  draft/<ORG>_<ROLE>_CV.html
  draft/<ORG>_<ROLE>_CoverLetter.html
  deliverable/<ORG>_<ROLE>_CV.pdf
  deliverable/<ORG>_<ROLE>_CoverLetter.pdf
```
