# Skill Evolution Signal Log
> Auto-maintained by evolve-skills. Do not edit manually.

## review-doc

### cto-over-indexes-scalability
- status: rejected
- pr: https://github.com/nickgiro/claude-skills/pull/3
- previous-prs: #1 (rejected 2026-03-19), #2 (rejected 2026-03-19)
- rejected-date: 2026-03-27
- occurrences:
  - 2026-03-19 | feedback_test_cto_scalability.md | "CTO reviewer focuses too much on scalability — it dominates the review even for small features where scale isn't a concern"
  - 2026-03-19 | feedback_test_cto_scalability_2.md | "CTO reviewer's scalability concerns dominate the review output even for internal dashboards"
  - 2026-03-19 | feedback_test_cto_scalability_3.md | "CTO reviewer should weigh feasibility over scale — the scalability bullet drives most REVISE items on MVP features"
  - 2026-03-19 | feedback_test_cto_scalability_4.md | "CTO reviewer asked about horizontal scaling strategy for a prototype that will have 10 users"
  - 2026-03-19 | feedback_test_cto_scalability_5.md | "Again got a REVISE from the CTO reviewer purely on scalability for a simple config page"
  - 2026-03-19 | feedback_test_cto_scalability_6.md | "CTO reviewer flagged 'will this hold up at 100x' on an internal admin tool with 5 concurrent users"
  - 2026-03-19 | feedback_test_cto_scalability_7.md | "CTO reviewer gave a REVISE on scalability for a weekend hackathon prototype"
  - 2026-03-19 | feedback_test_cto_scalability_8.md | "The 'will this hold up at 100x' question is not useful when reviewing a feature for a team of 3"
  - 2026-03-19 | feedback_test_cto_scalability_9.md | "Third time this month: CTO reviewer flagged scalability on a low-stakes internal tool"

### clarity-reviewer-write-for-10yo
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/7
- occurrences:
  - 2026-04-28 | feedback_clarity_plain.md | "clarity reviewer should avoid abstracted/industry terms (usability, friction, design system) and use language a 10-year-old would understand"

## [UNMATCHED]

### en-dash-over-em-dash
- status: resolved
- resolution: 2026-04-28 | added to global ~/.claude/CLAUDE.md as "Output formatting" rule (no PR — handled outside this repo)
- occurrences:
  - 2026-03-27 | feedback_en_dash.md | "Use en dash instead of em dash in all text output – general formatting preference"

### definitive-ticket-specs
- status: active
- occurrences:
  - 2026-03-27 | feedback_ticket_writing.md | "Tickets must have clear, actionable specs – no hedging language like 'consider' or 'maybe'"
