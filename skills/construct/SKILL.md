---
description: Generate a tailored CV and cover letter from your professional profile. Provide a job description or role details to get started, or ask for a general CV.
---

Follow these steps precisely.

## Step 1 — Orient yourself  

All paths in this skill (`profile/`, `applications/`) are relative to the **current project root** (the workspace where the user is working), not inside the plugin install directory (`~/.claude/plugins/...`).

**Profile location:** `profile/professional_profile.md` in the project.

**If that file does not exist yet:**

1. Ensure the directory exists: `profile/` under the project root.
2. **Create the file from the bundled template** (do this for the user — do not only paste a `cp` command that points into `~/.claude/plugins/...`):
   - Preferred source: `${CLAUDE_PLUGIN_ROOT}/profile/professional_profile_template.md` (set when the plugin is active).
   - If that path is unavailable and `profile/professional_profile_template.md` exists in the project (e.g. git clone of this repo), use that instead.
3. Read the template, write the same contents to `profile/professional_profile.md` in the project (or run a single shell `mkdir -p profile && cp "<template-path>" profile/professional_profile.md` with the template path resolved as above).
4. Tell the user briefly: the stub is at **`profile/professional_profile.md` in this project**; they should fill in their real career details, then continue or re-run this skill. Do not tell them to edit files under `~/.claude/plugins/`.

Then read `profile/professional_profile.md` in full before continuing.

## Step 2 — Understand the request

Read the format constraints from the plugin: `${CLAUDE_PLUGIN_ROOT}/skills/format/workflows/format_constraints.md` when available, otherwise `skills/format/workflows/format_constraints.md` from the project if present. These constraints apply to all output regardless of request type.

Determine what the user wants:

**A) Tailored application** — they've provided a JD or named a specific role.

**B) General CV** — no specific role. Build from the profile directly, leading with their strongest material. Skip fit-mapping and gap questions.

In both cases follow the process of draft → cv_review (improve in place) → approval → format skill (HTML → PDF).

## Step 3 — Open (or create) the application folder

Every application lives under `applications/<ORG>_<ROLE>/` with three fixed subfolders:

```
applications/
  <ORG>_<ROLE>/
    job_description/   # JD input
    draft/             # markdown drafts + HTML intermediates (disposable)
    deliverable/       # approved PDFs (keep)
```

1. Choose a folder name `<ORG>_<ROLE>` from the company and role (e.g. `Acme_SeniorPM`). For a general CV with no specific role, use `General_CV`.
2. Ensure the tree exists: `mkdir -p "applications/<ORG>_<ROLE>/job_description" "applications/<ORG>_<ROLE>/draft" "applications/<ORG>_<ROLE>/deliverable"`.
3. For a tailored application: save or copy the job description into `applications/<ORG>_<ROLE>/job_description/` (create the file if the user pasted the JD in chat). If a JD already exists there, use it.
4. Tell the user the application path you are using.

## Step 4 — Fill gaps before drafting

For a tailored application: map the JD against the profile (Strong / Partial / Gap per criterion), then ask one targeted gap question at a time. Wait for an answer before asking the next. Once all questions are answered, reassess each criterion against the updated profile — apply the same honest scoring. If the evidence is still thin after the user's answer, say so; do not upgrade a Gap to Strong on weak grounds.

For a general CV: identify the top 2–3 things missing from the profile that would strengthen it (missing metrics, unclear scope, etc.) and ask about those — one at a time. Reassess after each answer using the same standard.

Save every confirmed fact back to `profile/professional_profile.md` immediately.

## Step 5 — Calibrate to the user's existing voice

Before drafting a tailored application, find prior applications whose **job descriptions** are most like the current role, then study those applications' approved deliverables so the new output sounds like the user — not a generic template. For a general CV (no specific role), skip JD similarity and fall back to the three most recent applications that have deliverables.

1. Read `applications/application_dates.csv` at the project root (columns: `application,date`). If the file is missing or has no data rows, skip this step and note that no prior applications were available for style calibration.
2. Take the **10 most recent** applications by `date` (YYYY-MM-DD, newest first). If fewer than 10 exist, use all of them. Exclude the current `<ORG>_<ROLE>` if it already appears in the CSV.
3. For each of those applications, read the job description under `applications/<application>/job_description/` (any file in that folder). If a folder has no JD, skip that application for similarity ranking.
4. Compare each prior JD to the **current** role/JD. Rank by similarity of:
   - Role family and seniority (e.g. product leadership vs IC engineering)
   - Sector / domain and organisation type
   - Core responsibilities and required competencies
5. Pick up to **three** of the closest matches that also have PDFs under `applications/<application>/deliverable/`. Prefer the same document type you are about to write (CV vs cover letter / personal statement). If none of the similar applications have deliverables, widen to any of the 10 recent applications that do; if still none, skip and tell the user.
6. Read each chosen PDF with the Read tool (it extracts text from PDFs). Keep notes on **style only**:
   - Voice and register (formal vs conversational, first vs third person, British spellings, etc.).
   - Bullet construction (typical length, where the impact sits, how metrics are introduced and bolded).
   - Summary statement shape (length, opening pattern, how positioning is framed).
   - Cover letter / personal statement rhythm (paragraph length, how criteria are introduced, sign-off pattern).
   - Recurring vocabulary the user actually uses, and phrasings they clearly avoid.
7. Briefly tell the user which prior applications you ranked as similar (and why), which deliverables you sampled, and the 2–4 style cues you'll carry forward (e.g. "matching the bullet pattern from `applications/Acme_SeniorPM/deliverable/Acme_SeniorPM_CV.pdf`: outcome-first, metric bolded with surrounding phrase, 18–24 words"). Invite them to override any cue before you draft.

**Strict boundaries on this step:**

- Use prior JDs only to **select** which applications are style-relevant; use prior deliverables for **style only**, never as a source of facts. Every claim in the new draft must still be grounded in `profile/professional_profile.md` or in answers the user gave during gap-filling.
- Do not lift sentences or bullet phrasings verbatim from prior deliverables — match the pattern, not the words.
- Do not infer new biography, metrics, or achievements from a prior CV; if something interesting appears there but is missing from the profile, ask the user and, if confirmed, save it back to the profile per Step 4.
- If prior deliverables conflict with each other or with the profile, trust the profile and ask the user to resolve the conflict.

## Step 6 — Draft in markdown

Write the CV (and cover letter if needed) as markdown drafts in `applications/<ORG>_<ROLE>/draft/`.

CV: max 2 pages. Lead with impact. Quantify everything possible.
Cover letter / personal statement: one section per criterion, labelled to match the JD.

When bolding for emphasis, bold the meaningful phrase not just the metric — bold enough context that the emphasis makes sense in isolation. "**33% decrease in learner churn**" not "**33%**".

Do not ask for approval yet — go straight to Step 7.

## Step 7 — Review and improve the CV draft

**Always** run the cv_review skill on the CV draft before presenting for approval. Do not skip this step and do not wait for the user to ask.

1. Follow `${CLAUDE_PLUGIN_ROOT}/skills/cv_review/SKILL.md` when available, otherwise `skills/cv_review/SKILL.md` from the project.
2. Use the CV draft path just written: `applications/<ORG>_<ROLE>/draft/<ORG>_<ROLE>_CV_draft.md`.
3. Complete the full cv_review flow (checklist → rewrite in place → report). If cv_review raises open questions that need facts, ask them (one at a time), save answers to the profile, and finish any remaining draft fixes before continuing.
4. Cover letters are out of scope for cv_review unless the user asks; leave the cover letter draft as written in Step 6.

## Step 8 — Get approval, then format

Present the **reviewed** CV draft (and cover letter if any) to the user, including the cv_review report of what changed. **Do not proceed until they approve.** They may edit the files directly.

After approval, hand off to formatting:

- **Default:** tell the user to run `/resume-constructor:format applications/<ORG>_<ROLE>/draft/<ORG>_<ROLE>_CV_draft.md` (and a second invocation with the cover letter path if applicable).
- **Same session:** if the user asks to format or continue, follow `skills/format/SKILL.md` using the approved draft path(s). Do not regenerate or edit draft wording.

Do not convert to HTML or build PDF in this skill.

---

## Hard rules

- Never over-claim fit — if evidence is thin, say so
- Prior deliverables are a style reference, never a source of facts — never copy sentences verbatim or invent claims based on what an old CV said
- Always run cv_review on the CV draft before asking for approval — do not treat it as optional
- Always save new information to the profile immediately, not at the end
- British English unless the user specifies otherwise
- Do not create or overwrite workflow files without asking — they are the instructions and must be preserved and refined, not discarded
- When a tool fails: read the full error, fix the script, retest, then update the workflow with what you learned
- Everything in `draft/` is disposable. Everything in `deliverable/` is not — never delete deliverables