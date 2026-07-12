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
- status: resolved
- pr: https://github.com/nickgiro/claude-skills/pull/7
- resolution: 2026-04-29 | merged via PR #7
- occurrences:
  - 2026-04-28 | feedback_clarity_plain.md | "clarity reviewer should avoid abstracted/industry terms (usability, friction, design system) and use language a 10-year-old would understand"

### output-review-as-separate-file
- status: rejected
- pr: https://github.com/nickgiro/claude-skills/pull/8
- rejected-date: 2026-05-04
- occurrences:
  - 2026-05-03 | feedback_strategy_review_output.md | "Don't directly amend documents during review – output feedback as a separate file that Nick can review and apply himself. Directly editing removes the learning opportunity."

### confirm-audience-before-review
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/13
- occurrences:
  - 2026-06-22 | feedback_confirm_doc_audience.md | "When asked to review a document, establish or confirm the intended audience before shaping the critique. Do not assume it. The same document gets a different review for a compliance team vs. a builder vs. an exec."

## review-strategy

### scope-guard-product-planning-docs
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/9
- occurrences:
  - 2026-05-17 | feedback_constraints_to_product_work.md | "When Nick shares a doc that lists user constraints/conditions for value, do NOT apply the review-strategy skill or critique it as a strategy doc. Treat it as product-planning input."

### conditions-vs-hypotheses-distinction
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/10
- occurrences:
  - 2026-05-17 | feedback_conditions_vs_hypotheses.md | "When reviewing docs, distinguish conditions of success from falsifiable hypotheses. Don't critique conditions for being 'unfalsifiable' – that's a category error."

### push-for-product-side-mirror
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/12
- occurrences:
  - 2026-05-17 | feedback_user_side_vs_product_side_conditions.md | "When a doc lists user-side conditions ('users derive value when they X'), push for the product-side mirror ('product makes X likely by Y') – that's where the team's design work and load-bearing risk lives."

### zero-to-one-judge-intuition-not-data
- status: active
- note: HELD this run — review-strategy already has 3 open, unactioned PRs (#9, #10, #12) from 2026-05-17. Adding a 4th closely-related PR (this mirrors conditions-vs-hypotheses) onto an unreviewed queue is low-value noise. Propose once the existing review-strategy queue clears or a 2nd converging source lands.
- occurrences:
  - 2026-06-22 | feedback_zero_to_one_intuition_not_data.md | "On 0-1 product work, don't demand data/evidence for problem statements — judge whether the intuition is explicit, ownable, and falsifiable-after-launch. Drop critiques that demand frequency/prevalence/evidence."

## week-report

### outcome-focused-not-output-focused
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/14
- occurrences:
  - 2026-07-12 | outcome-focused-resume-writing.md | "Nick pushed back on output-framed bullets ('shipped X') and asked for outcome framing – open each bullet with the state change, then the mechanism; never promote targets to results. Applies to resumes, LinkedIn, week reports, self-review material."

## [UNMATCHED]

### prd-requests-as-problem-framing
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/15
- note: proposed as NEW skill `frame-problem` – feedback prescribed the exact doc structure
- occurrences:
  - 2026-07-12 | prd-as-problem-framing.md | "When a doc request says 'frame the problem' or is pre-discovery – even if 'PRD' is used – structure as context, problem statement, why now, what we know, what to discover, success of framing. No FRs, no user stories, no scope sections."

### en-dash-over-em-dash
- status: resolved
- resolution: 2026-04-28 | added to global ~/.claude/CLAUDE.md as "Output formatting" rule (no PR — handled outside this repo)
- occurrences:
  - 2026-03-27 | feedback_en_dash.md | "Use en dash instead of em dash in all text output – general formatting preference"

### definitive-ticket-specs
- status: resolved
- resolution: 2026-04-28 | addressed by creation of write-tickets skill (commit e5f47ac)
- occurrences:
  - 2026-03-27 | feedback_ticket_writing.md | "Tickets must have clear, actionable specs – no hedging language like 'consider' or 'maybe'"

### never-read-env-files-without-permission
- status: active
- note: candidate for global ~/.claude/CLAUDE.md addition (engineering safety rule, not skill-specific)
- occurrences:
  - 2026-05-03 | feedback_env_files.md | "Never read .env files without explicit permission – they contain secrets"

### practical-objections-in-strategic-conversations
- status: active
- note: candidate for global ~/.claude/CLAUDE.md addition (general behavior, not skill-specific)
- occurrences:
  - 2026-05-03 | feedback_dont_match_register.md | "Don't let philosophical/strategic register filter out practical objections like cost, feasibility, or data gaps – those are often the most important"

### search-before-fabricating-empirical-claims
- status: active
- note: candidate for global ~/.claude/CLAUDE.md addition (general behavior, not skill-specific)
- occurrences:
  - 2026-05-03 | feedback_verify_before_fabricate.md | "Never invent estimates/numbers when a web search could ground them – fabricated numbers passed the smell test but were baseless"

### problem-discovery-skill
- status: proposed
- pr: https://github.com/nickgiro/claude-skills/pull/11
- note: candidate for NEW skill capturing problem-discovery discipline (4 converging sources)
- occurrences:
  - 2026-05-17 | feedback_problem_discovery.md | "Stay strictly in problem-space during business-problem hunting – don't drift into solutions, technical approaches, or product wedges until explicitly signaled."
  - 2026-05-17 | feedback_structural_blockers_first.md | "Ask about structural blockers (regulators, dominant incumbents, mandatory systems) in the first 1-2 turns before going deep on pain magnitude or buyer profile."
  - 2026-05-17 | feedback_check_anchor_vs_descriptor.md | "When user says 'an agency does X', confirm the actual anchor's size, sub-vertical, stack, and relationship before building TAM or evidence."
  - 2026-05-17 | feedback_solution_in_market_problem_discovery.md | "Solution shipped + fuzzy problem = parallel observational inward + hypothesis-driven outward streams. Don't interrogate launch users on why."
