---
description: Generate a tailored CV and cover letter from your professional profile. Provide a job description or role details to get started, or ask for a general CV.
---

Follow these steps precisely.

## Step 1 — Orient yourself  

All paths in this skill (`profile/`, `.tmp/`, `deliverables/`, `job_descriptions/`) are relative to the **current project root** (the workspace where the user is working), not inside the plugin install directory (`~/.claude/plugins/...`).

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

In both cases follow the process of markdown review → approval → format skill (HTML → PDF).

## Step 3 — Fill gaps before drafting

For a tailored application: map the JD against the profile (Strong / Partial / Gap per criterion), then ask one targeted gap question at a time. Wait for an answer before asking the next. Once all questions are answered, reassess each criterion against the updated profile — apply the same honest scoring. If the evidence is still thin after the user's answer, say so; do not upgrade a Gap to Strong on weak grounds.

For a general CV: identify the top 2–3 things missing from the profile that would strengthen it (missing metrics, unclear scope, etc.) and ask about those — one at a time. Reassess after each answer using the same standard.

Save every confirmed fact back to `profile/professional_profile.md` immediately.

## Step 4 — Calibrate to the user's existing voice

Before drafting, study prior approved work in this project's `deliverables/` so the new output sounds like the user, not like a generic template.

1. List `deliverables/` at the project root. If it does not exist or is empty, skip this step and note in your reply that no prior deliverables were available for style calibration.
2. Pick up to **three** of the most relevant existing PDFs to use as style references, prioritising in this order:
   - Same document type as you are about to write (CV vs cover letter / personal statement).
   - Same or adjacent role family / sector to the current request.
   - Most recent, by file mtime, when the above are tied.
3. Read each chosen PDF with the Read tool (it extracts text from PDFs). Keep notes on **style only**:
   - Voice and register (formal vs conversational, first vs third person, British spellings, etc.).
   - Bullet construction (typical length, where the impact sits, how metrics are introduced and bolded).
   - Summary statement shape (length, opening pattern, how positioning is framed).
   - Cover letter / personal statement rhythm (paragraph length, how criteria are introduced, sign-off pattern).
   - Recurring vocabulary the user actually uses, and phrasings they clearly avoid.
4. Briefly tell the user which prior deliverables you sampled and the 2–4 style cues you'll carry forward (e.g. "matching the bullet pattern from `Acme_SeniorPM_CV.pdf`: outcome-first, metric bolded with surrounding phrase, 18–24 words"). Invite them to override any cue before you draft.

**Strict boundaries on this step:**

- Use prior deliverables for **style only**, never as a source of facts. Every claim in the new draft must still be grounded in `profile/professional_profile.md` or in answers the user gave during gap-filling.
- Do not lift sentences or bullet phrasings verbatim from prior deliverables — match the pattern, not the words.
- Do not infer new biography, metrics, or achievements from a prior CV; if something interesting appears there but is missing from the profile, ask the user and, if confirmed, save it back to the profile per Step 3.
- If prior deliverables conflict with each other or with the profile, trust the profile and ask the user to resolve the conflict.

## Step 5 — Draft in markdown, get approval

Write the CV (and cover letter if needed) as markdown drafts in `.tmp/`. Present them to the user. **Do not proceed until they approve.** They may edit the files directly.

CV: max 2 pages. Lead with impact. Quantify everything possible.
Cover letter / personal statement: one section per criterion, labelled to match the JD.

When bolding for emphasis, bold the meaningful phrase not just the metric — bold enough context that the emphasis makes sense in isolation. "**33% decrease in learner churn**" not "**33%**".

After approval, hand off to formatting:

- **Default:** tell the user to run `/resume-constructor:format .tmp/<ORG>_<ROLE>_CV_draft.md` (and a second invocation with the cover letter path if applicable).
- **Same session:** if the user asks to format or continue, follow `skills/format/SKILL.md` using the approved draft path(s). Do not regenerate or edit draft wording.

Do not convert to HTML or build PDF in this skill.

---

## Hard rules

- Never over-claim fit — if evidence is thin, say so
- Prior deliverables are a style reference, never a source of facts — never copy sentences verbatim or invent claims based on what an old CV said
- Always save new information to the profile immediately, not at the end
- British English unless the user specifies otherwise
- Do not create or overwrite workflow files without asking — they are the instructions and must be preserved and refined, not discarded
- When a tool fails: read the full error, fix the script, retest, then update the workflow with what you learned
- Everything in `.tmp/` is disposable. Everything in `deliverables/` is not — never delete deliverables
