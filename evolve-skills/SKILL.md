---
name: evolve-skills
description: Scans feedback memories across all projects, detects patterns, and proposes skill updates via GitHub PRs. Run manually or on a weekly loop.
user-invocable: true
argument-hint: "[skill-name] (optional — omit to scan all skills)"
---

# Evolve Skills

This skill scans feedback memories, matches them to skills, and opens GitHub PRs when patterns emerge.

**IMPORTANT:** Always use `export PATH="/c/Program Files/GitHub CLI:$PATH"` before any `gh` command.

## Execution Steps

### Step 0 — Resolve paths and target

```
SKILLS_REPO=~/claude-skills
SIGNAL_LOG=$SKILLS_REPO/evolve-skills/signal-log.md
MEMORY_ROOT=~/.claude/projects
TARGET_SKILL=$ARGUMENTS   # empty = all skills
```

If `$TARGET_SKILL` is set, only process that skill. Otherwise process all skill directories in `$SKILLS_REPO`.

### Step 1 — Pull latest

Run `git -C $SKILLS_REPO pull origin main` to pick up any merged PRs before scanning. If this fails (e.g., no commits yet), continue.

### Step 2 — Load state

Read `$SIGNAL_LOG` if it exists. Parse each entry into a structured list:
- skill name
- theme slug
- status (`active`, `proposed`, `resolved`, `rejected`)
- PR URL (if proposed)
- list of occurrences (date, source file, excerpt)

If the file doesn't exist, start with an empty state.

### Step 3 — Discover skills

List all directories in `$SKILLS_REPO` that contain a `SKILL.md` file (excluding `evolve-skills` itself). For each, read the SKILL.md to understand its name, description, and scope. Build a skill index:

```
skill_name -> { directory, description, key_concepts[] }
```

Where `key_concepts` are extracted from the skill's content — role names, feature names, domain terms — anything that feedback might reference.

### Step 4 — Collect feedback signals

Scan all feedback memory files across all projects:
```
~/.claude/projects/*/memory/*.md
```

For each file:
1. Read its frontmatter — only process files with `type: feedback`
2. Check if this file is already logged in the signal log (by source filename). If so, skip.
3. Read the content and match it to a target skill using this priority:
   - **Direct name match** — feedback mentions a skill by name (e.g., "the review-doc skill")
   - **Role/feature match** — feedback references a component defined in a skill (e.g., "the CTO reviewer" -> `review-doc`)
   - **Domain match** — feedback topic overlaps with a skill's described scope
   - If confidence is low, assign to `[UNMATCHED]`
4. Generate a normalized theme slug from the feedback content (e.g., `cto-over-indexes-scalability`, `tone-too-formal`). The slug should capture the specific concern, not just a generic category.
5. If the feedback maps to multiple skills, create a separate signal for each.

### Step 5 — Update signal log

For each new signal collected in Step 4:
1. Find or create the skill section in the signal log
2. Find or create the theme entry under that skill
3. Append the occurrence with: date (today), source filename, short excerpt from the feedback
4. Keep status as `active` unless already `proposed` or `resolved`

Write the updated signal log to `$SIGNAL_LOG` using this format:

```markdown
# Skill Evolution Signal Log
> Auto-maintained by evolve-skills. Do not edit manually.

## [skill-name]

### [theme-slug]
- status: active | proposed | resolved | rejected
- pr: [URL] (only if proposed)
- rejected-date: [date] (only if rejected — used to filter pre-rejection signals)
- occurrences:
  - [date] | [source-file] | "[excerpt]"
  - [date] | [source-file] | "[excerpt]"
```

### Step 6 — Check for existing PRs

Before creating any PRs, check for existing open PRs in the repo:
```bash
gh pr list --repo nickgiro/claude-skills --state open --json number,title,headRefName
```

Build a set of branch names that already have open PRs. Do NOT create duplicate PRs.

### Step 7 — Rank candidates by importance

Build the candidate pool from the signal log:

- Include all themes with status `active` (any number of occurrences — no minimum)
- Include `[UNMATCHED]` themes (these become proposed new skills)
- Exclude themes with status `proposed` (open PR already exists)
- Exclude `rejected` themes UNLESS they have at least 1 occurrence dated AFTER `rejected-date`

Rank each candidate by importance using these criteria (apply judgment, not a strict formula):

- **Severity** — feedback correcting wrong behavior > feedback suggesting polish
- **Specificity** — concrete corrections with clear examples > vague preferences
- **Convergence** — multiple memory files reporting the same theme > single source
- **Recency** — recent occurrences > old ones (older signals may be stale)
- **Skill weight** — feedback about frequently-used skills > rarely-used skills (use signal-log volume per skill as a proxy)

Pick **up to 3** candidates as the week's proposals.

**Defensibility bar:** only include a candidate if you can write a clear, specific rationale for why this change should land. If the next-best candidate is weak, stop — produce fewer than 3 proposals (or zero in a thin week). Do NOT pad to 3 for the sake of it.

### Step 8 — Open draft PRs for selected candidates

For each ranked candidate from Step 7 (up to 3):

1. **Check for duplicates**: If a branch `evolve/[skill-name]/[theme-slug]` already has an open PR, skip.

2. **Create branch**:
   ```bash
   cd $SKILLS_REPO
   git checkout main
   git checkout -b evolve/[skill-name]/[theme-slug]
   ```

3. **Apply the change**:
   - **Matched theme**: read the target `SKILL.md`, make a minimal surgical edit addressing the feedback. Change only what the feedback demands.
   - **`[UNMATCHED]` theme**: draft a brand-new `SKILL.md` for a new skill directory. Infer what the skill should do, when it triggers, and what behavior to encode.

4. **Commit and push**:
   ```bash
   git add [skill-name]/SKILL.md
   git commit -m "evolve: [skill-name] — [theme description]"
   git push -u origin evolve/[skill-name]/[theme-slug]
   ```

5. **Open DRAFT PR** (note `--draft` flag):
   ```bash
   gh pr create --repo nickgiro/claude-skills --draft \
     --title "evolve: [skill-name] — [theme description]" \
     --body "$(cat <<'EOF'
   ## Why this change

   [One paragraph: what feedback pattern led to this proposal and why this specific edit addresses it. Be concrete — name the behavior being corrected and the user-visible improvement.]

   ## What changed

   [Describe the specific edit made to SKILL.md, or for a new skill: what the skill does and when it triggers]

   ## Evidence

   | Date | Source | Excerpt |
   |------|--------|---------|
   | ... | ... | ... |

   ## Importance signals

   - Severity: [low/medium/high — and why]
   - Specificity: [low/medium/high]
   - Convergence: [N sources]
   - Recency: [most recent occurrence date]
   - Rank this week: [1, 2, or 3 of N proposals]

   ---
   Proposed by `evolve-skills` | Draft — promote to "Ready for review" or close to reject
   EOF
   )"
   ```

6. **Update signal log**: Set status to `proposed`, add PR URL. (The notify-pr.yml GitHub Action will assign and @-mention nickgiro automatically.)

7. **Return to main**:
   ```bash
   git checkout main
   ```

### Step 9 — Detect resolved themes

For each theme with status `proposed`:
1. Check if the PR was merged: `gh pr view [URL] --json state`
   - If merged: set status to `resolved`
2. Check if the PR was closed without merging:
   - If closed: set status to `rejected`, record `rejected-date` as today

Write the final signal log state.

### Step 10 — Commit signal log

If the signal log changed:
```bash
cd $SKILLS_REPO
git checkout main
git add evolve-skills/signal-log.md
git commit -m "evolve-skills: update signal log"
git push origin main
```

### Step 11 — Output summary

Print a summary to the terminal:

```
## evolve-skills run complete

- Feedback files scanned: [N]
- New signals collected: [N]
- Themes at threshold: [N]
- PRs opened: [N] [list URLs]
- PRs merged (resolved): [N]
- PRs closed (rejected): [N]
- Unmatched signals: [N]
```

## Key Rules

- **Never push directly to main** except for signal log updates
- **One PR per proposed change** — no batching multiple themes
- **Up to 3 proposals per run** — global ranking by importance, not per-skill
- **Defensibility bar** — produce fewer than 3 (or zero) if remaining candidates are weak; never pad
- **All evolve PRs open as drafts** — user promotes to "Ready" or closes to reject
- **Rejected themes need at least 1 NEW signal** (post-rejection) to re-enter the candidate pool
- **Never delete signal log entries** — they're an audit trail
- **Deduplicate by source file** — same feedback file never counted twice
- **Check for open PRs before creating** — no duplicates
- **Commit signal log on every run** that produces changes
