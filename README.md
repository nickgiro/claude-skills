# claude-skills

Claude Code skills that evolve based on feedback.

## What this is

A dedicated repo that holds all Claude Code skills. Symlinked to `~/.claude/skills/` so skills are available across every project.

### Skills

| Skill | What it does |
|-------|-------------|
| `review-doc` | Multi-perspective document review (Product Leader, CPO, CTO, Marketing, Design) |
| `evolve-skills` | Scans feedback memories, detects patterns, and proposes skill updates via PRs |

### How evolve-skills works

When `/evolve-skills` runs, it:
1. Scans all `~/.claude/projects/*/memory/*.md` files for `type: feedback` entries
2. Matches each to a skill (by name, role, or domain)
3. Logs signals in `evolve-skills/signal-log.md`
4. When a theme hits 3+ signals, opens a PR with the proposed SKILL.md edit + evidence
5. A GitHub Action comments `@nickgiro` so you get an email
6. You review the diff in GitHub, merge or close

### How to run

| Method | Command |
|--------|---------|
| Manual (all skills) | `/evolve-skills` |
| Manual (one skill) | `/evolve-skills review-doc` |
| Weekly loop | `/loop 1w /evolve-skills` |

The loop only runs while a Claude Code session is open. There's no background daemon.

### How to stop or modify

| Want to... | Do this |
|---|---|
| Stop a loop | Close the Claude Code session, or Ctrl+C |
| Change frequency | `/loop 2w /evolve-skills` (every 2 weeks), `/loop 3d /evolve-skills` (every 3 days) |
| Run for one skill only | `/evolve-skills review-doc` |
| Change the threshold | Edit `evolve-skills/SKILL.md` — search for "3+" and change the number |
| Reject a proposal permanently | Close the PR — it needs 3 new signals post-rejection to re-propose |
| Accept a proposal | Merge the PR on GitHub, then `git pull` in `~/claude-skills` |
| Add a new skill | Create a `skill-name/SKILL.md` in the repo — evolve-skills will auto-discover it |

### How signals flow

```
Feedback memory files (type: feedback)
        |
        v
  evolve-skills scans + matches to skills
        |
        v
  signal-log.md (audit trail)
        |  3+ signals on same theme
        v
  GitHub PR with proposed SKILL.md edit
        |
        v
  GitHub Action @mentions you (email)
        |
        v
  You merge or close
```

### Setup (already done)

1. Repo created at `github.com/nickgiro/claude-skills`
2. Skills added: `review-doc/`, `evolve-skills/`
3. Symlinked to `~/.claude/skills/`
4. GitHub Action at `.github/workflows/notify-pr.yml` handles email notifications
