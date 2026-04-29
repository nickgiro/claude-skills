---
name: week-report
description: Write a weekly status report from standup logs and context. Reads previous reports to match tone and format. Use when the user asks to write, draft, or generate a week report.
user-invocable: true
argument-hint: "[paste standup logs or context]"
---

# Week Report

Generate an end-of-week status report for Above Technologies.

## Process

1. **Read previous reports.** Search the workspace for files matching `week-report*.md` and read the most recent 2–3. Match their structure, tone, and level of detail. If no previous reports exist, use the format defined below.

2. **Parse the input.** The user provides standup logs (Y/T format per person per day) and any additional context. Extract:
   - What was completed (Y entries across all days)
   - What's in progress or carrying over (T entries from the final day)
   - Blockers, decisions made, and open questions mentioned in conversation

3. **Synthesize, don't transcribe.** Group related work into themes. A ticket that appears across multiple days is one achievement, not five. Combine bug fixes into a single line when they share a theme. Pull ticket titles from the Linear URLs (the slug after the issue number).

4. **Write the report.**

5. **Generate a Slack message.** After writing the full report, generate a shorter Slack-ready version. This is what Nick posts in Slack alongside a link to the full report. Format below.

6. **Review both outputs.** Invoke `/review-doc` on the full report, then invoke `/review-doc` on the Slack message. Apply feedback from both reviews before presenting the final versions to the user.

## Format

```
### Week Report [start]–[end] [Mon] [Year]

### Executive Summary

[2–4 bullet points: the big wins this week. Lead with what matters most to the business. Bold the key phrase in each bullet.]

[1 sentence of supporting context – what else moved forward.]

### Key Achievements

[Bulleted list. Group by theme, not by person or day. Include ticket numbers (ABO-XXX) inline. Lead each bullet with the outcome, not the task. Commits and infrastructure work go at the bottom.]

### Current Blockers

[Bulleted list. Each blocker states what's stuck and why.]

### Priorities for Next Week

[Bulleted list. Derived from the final day's T entries plus any open threads.]
```

## Slack Message Format

After the full report, output a Slack message under a `## Slack Message` heading. This is what Nick posts in the team Slack channel.

Structure:

```
:clipboard: Wrap up for this week:

:trophy: [N] big wins, [short thematic framing]:

[Win 1 – one sentence, outcome-focused, use – (en dash) not bullets]
[Win 2 – one sentence]
[Win 3 – one sentence]

Also shipped: [comma-separated list of secondary achievements, single paragraph, no line breaks within]

Blockers: [1–2 sentences on what's stuck and why, or "None"]

Next week: [1–2 sentences on priorities, comma-separated where possible]

Have a good weekend y'all
```

Rules for the Slack message:
- No markdown bold/headers/bullet points – Slack uses its own formatting. Use emoji headers (:clipboard:, :trophy:) to structure.
- Big wins get their own lines. Everything else is compressed into inline lists.
- Each big win is a plain sentence – no bold, no bullet characters. Start with the outcome, then context after a dash.
- "Also shipped" is a single dense paragraph – comma-separated items, no line breaks within.
- Tone is casual and direct – this is a team channel, not a board deck.
- Always end with "Have a good weekend y'all".

## Rules

1. **Executive summary is 2–4 bullets max.** These are the things a stakeholder remembers. Everything else goes in Key Achievements.

2. **Write outcomes, not activities.** "Payment database schema and Shopify webhooks shipped" – not "Worked on payment flow".

3. **Attribute by ticket, not by person.** The report covers the team. Don't split sections by individual.

4. **Derive ticket names from URLs.** The slug in a Linear URL (e.g. `fix-voice-fingerprinting`) tells you the ticket title. Use that rather than inventing a name.

5. **Collapse small items.** Group related bug fixes, typo fixes, and infra tweaks into a single bullet with a list of ticket numbers.

6. **No hedging.** Don't say "made progress toward" – say what shipped or what's blocked.

7. **Match prior report tone.** If previous reports are terse, be terse. If they use specific formatting conventions, follow them.

## When invoked with arguments

If `$ARGUMENTS` is provided, treat it as the standup logs / context. Write the report immediately.

## When invoked without arguments

Ask the user to paste this week's standup logs.
