---
description: Generate a tailored CV and cover letter from your professional profile. Provide a job description or role details to get started, or ask for a general CV.
---

If Python deps or PDF rendering are not ready (first install, or WeasyPrint errors), use `/resume-constructor:setup` before continuing.

Follow these steps precisely.

## Step 1 — Orient yourself

Read `profile/professional_profile.md` in full before doing anything else.

If it doesn't exist, tell the user: "Your profile hasn't been set up yet. Copy `profile/professional_profile_template.md` to `profile/professional_profile.md` and fill it in, then come back."

## Step 2 — Understand the request

Read `skills/construct/workflows/format_constraints.md` — these constraints apply to all output regardless of request type.

Determine what the user wants:

**A) Tailored application** — they've provided a JD or named a specific role.

**B) General CV** — no specific role. Build from the profile directly, leading with their strongest material. Skip fit-mapping and gap questions.

In both cases follow the process of markdown review → approval → HTML → PDF.

## Step 3 — Fill gaps before drafting

For a tailored application: map the JD against the profile (Strong / Partial / Gap per criterion), then ask one targeted gap question at a time. Wait for an answer before asking the next. Once all questions are answered, reassess each criterion against the updated profile — apply the same honest scoring. If the evidence is still thin after the user's answer, say so; do not upgrade a Gap to Strong on weak grounds.

For a general CV: identify the top 2–3 things missing from the profile that would strengthen it (missing metrics, unclear scope, etc.) and ask about those — one at a time. Reassess after each answer using the same standard.

Save every confirmed fact back to `profile/professional_profile.md` immediately.

## Step 4 — Draft in markdown, get approval

Write the CV (and cover letter if needed) as markdown drafts in `.tmp/`. Present them to the user. **Do not proceed until they approve.** They may edit the files directly.

CV: max 2 pages. Lead with impact. Quantify everything possible.
Cover letter / personal statement: one section per criterion, labelled to match the JD.

When bolding for emphasis, bold the meaningful phrase not just the metric — bold enough context that the emphasis makes sense in isolation. "**33% decrease in learner churn**" not "**33%**".

## Step 5 — Convert to HTML and build PDF

After approval:
1. Write the approved content as an HTML file to `.tmp/<name>.html` — all CSS inline in `<style>` tags
2. Follow the WeasyPrint constraints in `skills/construct/workflows/format_constraints.md` without exception (no flex/grid, no external fonts, use table-based columns)
3. Build the PDF:
   ```
   DYLD_LIBRARY_PATH=/opt/homebrew/lib uv run skills/construct/tools/build_cv.py --input .tmp/<name>.html --output deliverables/<name>.pdf
   ```
4. Verify: text is selectable, no overlap, no orphaned headings, margins correct

## Step 6 — Save to deliverables

Confirm the PDF path to the user. Update `profile/professional_profile.md` with anything new you learned during this session.

---

## Hard rules

- Never generate a PDF without explicit user approval of the content first
- Each role block (title, dates, bullets) must be wrapped so it never splits across a page — if a role is too long to fit, flag it to the user and suggest trimming before generating the PDF
- Never change approved wording when converting markdown to HTML
- Never over-claim fit — if evidence is thin, say so
- Always save new information to the profile immediately, not at the end
- British English unless the user specifies otherwise
- Do not create or overwrite workflow files without asking — they are the instructions and must be preserved and refined, not discarded
- When a tool fails: read the full error, fix the script, retest, then update the workflow with what you learned
- Everything in `.tmp/` is disposable. Everything in `deliverables/` is not — never delete deliverables
