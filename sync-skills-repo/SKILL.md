---
name: sync-skills-repo
description: Sweep the local machine for Claude Code skills, reconcile against the canonical ~/.claude/skills/ folder, and push any changes to the nickgiro/claude-skills GitHub repo. Use when the user asks to back up, sync, or push their skills to the cloud, or to find skill copies scattered across the filesystem (e.g. OneDrive, project dirs).
---

# sync-skills-repo

Performs a sweep + sync of all Claude Code skills on this machine into the canonical repo at `nickgiro/claude-skills`.

## When to invoke

- User says "sync my skills", "back up my skills", "push skills to the repo".
- User wants to find or consolidate skill copies scattered across the machine.
- After authoring or editing a skill in `~/.claude/skills/` and wanting an immediate push (instead of waiting for the weekly scheduled task).

## What to do

### 1. Sweep for skills

Search for all `SKILL.md` files outside the canonical location, since the canonical location is already tracked:

```bash
find /c/Users/nickg -maxdepth 6 -path "*/.claude/skills/*" -name "SKILL.md" 2>/dev/null \
  | grep -v "/c/Users/nickg/.claude/skills/"
```

Common stray locations to expect:
- `/c/Users/nickg/OneDrive/.claude/skills/` (older synced copies from other machines)
- `<project>/.claude/skills/` (project-scoped skills)

### 2. Reconcile

For each stray skill:

- **Not in canonical**: copy the whole skill folder to `~/.claude/skills/<name>/`.
- **In canonical, identical**: ignore.
- **In canonical, differs**: compare timestamps and contents. Do NOT overwrite silently — show the diff and ask the user which copy to keep.

### 3. Push

Run the sync script, which adds → commits → pushes only if there are changes:

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME/.claude/skills/.scripts/sync.ps1"
tail -n 10 "$HOME/.claude/skills-sync.log"
```

### 4. Report

Tell the user:
- Which skills were already in sync.
- Which skills were copied in (with source path).
- Which conflicts were surfaced for their decision.
- Final commit SHA from the log if a push happened.

## Related automation

A Windows scheduled task `ClaudeSkillsWeeklySync` runs `sync.ps1` every Sunday at 9 AM. This skill is the on-demand version — invoke it for an immediate sweep+sync, especially after editing skills, or to surface skills that live outside the canonical folder (which the weekly task doesn't sweep for).

## Repo layout

```
~/.claude/skills/             ← canonical, == nickgiro/claude-skills repo root
├── .scripts/sync.ps1         ← one-way push: local → remote
├── README.md
├── <skill-name>/SKILL.md     ← one folder per skill
└── ...
```
