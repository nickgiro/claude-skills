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

### Step 7 — Open PRs for threshold themes

For each theme with status `active` and 3+ occurrences:

1. **Check for rejection history**: If the theme was previously `rejected`, count only occurrences dated AFTER the `rejected-date`. Need 3+ post-rejection signals to re-propose.

2. **Check for duplicates**: If a branch `evolve/[skill-name]/[theme-slug]` already has an open PR, skip.

3. **Create branch and propose change**:
   ```bash
   cd $SKILLS_REPO
   git checkout main
   git checkout -b evolve/[skill-name]/[theme-slug]
   ```

4. **Edit the target SKILL.md**: Read the current skill, analyze the feedback pattern, and make a targeted edit that addresses the concern. The edit should be minimal and surgical — change only what the feedback demands.

5. **Commit and push**:
   ```bash
   git add [skill-name]/SKILL.md
   git commit -m "evolve: [skill-name] — [theme description]"
   git push -u origin evolve/[skill-name]/[theme-slug]
   ```

6. **Open PR**:
   ```bash
   gh pr create --repo nickgiro/claude-skills \
     --title "evolve: [skill-name] — [theme description]" \
     --body "$(cat <<'EOF'
   ## Proposed Skill Evolution

   **Skill:** [skill-name]
   **Theme:** [theme-slug]
   **Signal count:** [N]

   ## Evidence

   | Date | Source | Excerpt |
   |------|--------|---------|
   | ... | ... | ... |

   ## Rationale

   [Explain what the feedback pattern indicates and why this change addresses it]

   ## What changed

   [Describe the specific edit made to SKILL.md]

   ---
   Proposed by `evolve-skills` | [N] signals collected
   EOF
   )"
   ```

7. **Request review** (triggers email notification):
   ```bash
   gh pr edit --repo nickgiro/claude-skills --add-reviewer nickgiro
   ```

8. **Update signal log**: Set status to `proposed`, add PR URL.

9. **Return to main**:
   ```bash
   git checkout main
   ```

### Step 8 — Handle unmatched themes

For `[UNMATCHED]` themes with 3+ occurrences:

1. Draft a new SKILL.md based on the feedback pattern. Infer:
   - What the skill should do
   - When it should trigger
   - What behavior to encode
2. Create a new directory for it in the repo
3. Follow the same branch/commit/PR workflow as Step 7
4. PR body should explain what feedback drove the new skill proposal

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
- **One PR per theme per skill** — no batching multiple themes
- **3+ signals to propose** — don't react to one-off feedback
- **Rejected themes need 3 NEW signals** (post-rejection) before re-proposing
- **Never delete signal log entries** — they're an audit trail
- **Deduplicate by source file** — same feedback file never counted twice
- **Check for open PRs before creating** — no duplicates
- **Commit signal log on every run** that produces changes
