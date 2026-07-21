---
description: Review a CV markdown draft for style, substance, quantification, granularity, human-centric language, and punctuation — then rewrite the draft to fix findings. Usage: /resume-constructor:cv_review <path-to-draft> (or review the current application's draft).
---

Follow these steps precisely.

All paths (`profile/`, `applications/`) are relative to the **current project root** (the workspace where the user is working), not inside the plugin install directory (`~/.claude/plugins/...`).

## Step 1 — Resolve the draft

You need the CV markdown draft to review and improve.

**Path sources (in order):**

1. **Slash command argument** — `/resume-constructor:cv_review <path-to-draft>` (relative to project root or absolute).
2. **Same-session handoff** — after `/resume-constructor:construct`, if a draft was just written, use that path.
3. **Chat** — if neither applies, ask for the path to the `.md` draft under `applications/<ORG>_<ROLE>/draft/`.

Verify the file exists. Read it in full. Derive `<ORG>_<ROLE>` from the path when possible.

Also read, when present:

- `profile/professional_profile.md` — source of truth for facts
- `applications/<ORG>_<ROLE>/job_description/` — JD criteria the draft should meet (if any)
- `${CLAUDE_PLUGIN_ROOT}/skills/format/workflows/format_constraints.md` (or project copy) — shared writing constraints

## Step 2 — Establish the user's style baseline

Calibrate against how this user actually writes, not a generic “good CV” template.

1. Read `applications/application_dates.csv` if it exists. Take up to the **10 most recent** applications (exclude the current one).
2. Prefer applications with PDFs under `deliverable/` that are the same document type (CV). Pick up to **three**; if none match closely, use any recent CV deliverables.
3. Read those PDFs with the Read tool. Note **style only**:
   - Voice and register (formal vs conversational, person, British spellings)
   - Bullet construction (length, where impact sits, how metrics are bolded)
   - Summary shape and recurring vocabulary / avoided phrasings
4. If no prior deliverables exist, fall back to voice cues in `profile/professional_profile.md` and say so.

Do not treat prior CVs as a source of facts — only as a style reference. Match patterns, not sentences.

## Step 3 — Review against the checklist

Work through every criterion below. Collect findings before editing. For each finding, note the offending phrase (or bullet), the criterion, severity, and the intended fix.

### 1. Style match

- Does the draft sound like this user’s prior approved CVs (and profile), not like generic AI résumé-speak?
- Flag mismatched register, alien vocabulary, or bullet patterns that diverge sharply from the baseline without a good reason.

### 2. No bullshit statements

- Flag empty claims, buzzwords, and unfalsifiable fluff (e.g. “proven track record”, “passionate about”, “strong communicator”, “results-driven”).
- Flag hedging (“typically”, “might”, “helped with”) where a clear claim is possible.
- Flag anything that oversells relative to the profile or that the profile cannot support.

### 3. Backed by facts and quantified

- Every material claim should be grounded in `profile/professional_profile.md` or facts the user confirmed in this application thread.
- Prefer quantified impact (scale, %, time, money, people, volume) wherever the profile allows it.
- Flag vague verbs without evidence (“improved”, “led”, “delivered”) when a metric or concrete outcome exists in the profile and was left out — or when no evidence exists and the claim should be cut or softened.

### 4. Not too granular — teaser, not life history

Remember: the CV is supposed to be a teaser for an interview. The goal is to make it clear that job description requirements are met concretely, ideally with evidence — but it is not a 'life history'.

- Flag bullets that bury the reader in task lists, internal process minutiae, or every sub-project under a role.
- Prefer fewer, stronger bullets that prove JD-relevant capability over exhaustive chronology.
- For tailored applications: check that JD requirements are covered concretely; do not demand coverage of every career anecdote.

### 5. Human-centric language

Real "human-centric" language is used effectively. For example, do not use the term "function" when you mean "team", "system" or "product".

- Flag corporate abstractions and org-chart jargon that obscure who did what with whom.
- Prefer plain words for people, products, and systems over vague institutional nouns.

### 6. Em-dashes

Em-dashes are not used where a comma would suffice.

- Flag `—` (and habitual `--`) used as a soft pause; prefer a comma, colon, or a restructured sentence.
- Allowed only when a comma truly would not work (rare); when in doubt, fix it.

Also enforce related constraints from `format_constraints.md` (British English unless specified, bold whole achievement clauses not bare numbers, etc.) when they affect findings.

## Step 4 — Improve the draft

Apply must-fix and should-fix findings **directly in the draft markdown file**. Do not wait for the user to ask.

**How to edit:**

1. Rewrite in place in the same file path — overwrite the draft with the improved version.
2. Fix every must-fix and should-fix you can resolve from the profile (or confirmed session facts). Nits: fix them too when the change is cheap and unambiguous (em-dashes, a single wrong word); skip nits that would churn voice for little gain.
3. Preserve structure and naming (`applications/<ORG>_<ROLE>/draft/<ORG>_<ROLE>_CV_draft.md`). Keep role order unless reordering clearly serves JD fit and style baseline.
4. When improving for style: match the user’s patterns (bullet length, bolding, register) — never copy sentences from prior deliverables.
5. When cutting granularity: merge or drop weak bullets; keep the strongest evidence per JD-relevant theme.
6. When a fix needs a fact you do not have (metric missing from profile, unclear scope): **do not invent it**. Soften or cut the claim in the draft, and list a short gap question for the user in the report. If they answer, apply the update and save the new fact to `profile/professional_profile.md` immediately.

After writing the improved draft, re-skim against the checklist. If new must-fixes appear from your own edits, fix them before reporting (one tight pass — do not loop endlessly).

## Step 5 — Report

Present a short report of what you found and what you changed.

```
## CV review — <ORG>_<ROLE>

**Verdict after edits:** Pass | Pass with open questions | Needs user input

### Changes applied
For each substantive edit:
- **[criterion]** before → after (or “cut”)

### Open questions (only if needed)
One targeted question per missing fact that blocked a stronger fix. Wait for answers before further edits.

### What’s working
2–4 short notes on strong material that was kept.

### JD coverage (if a JD exists)
Brief: which requirements are evidenced well / thinly / missing — without inventing facts.
```

Point the user at the updated draft path. **Do not** run format until they approve the improved markdown. If they ask to format or continue after approval, hand off to `skills/format/SKILL.md`.

---

## Hard rules

- Always improve the draft file when findings warrant it — review-and-fix is the default, not review-only
- Never invent metrics or career facts to “fix” a finding — ask, or cut/soften, then update the profile when the user confirms
- Prior deliverables are style reference only, never a fact source — never copy sentences verbatim
- Do not proceed to format from this skill; stop after the improved draft and report
- British English unless the user specifies otherwise
- Do not create or overwrite workflow files without asking
