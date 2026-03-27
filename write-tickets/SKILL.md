---
name: write-tickets
description: Write Linear tickets or task descriptions as definitive engineering specs. Use when creating issues, tickets, or task breakdowns.
user-invocable: true
argument-hint: "[description of work to ticket]"
---

# Write Tickets

Generate engineering tickets that are buildable specs, not suggestions.

## Rules

1. **No hedging language.** Never use "consider", "maybe", "could", "might want to", "it would be nice to", "optionally", or "potentially". Every line is an instruction.

2. **State exactly what to build.** Each ticket describes a concrete change – what file/component/endpoint is affected, what the new behavior is, and what the output looks like.

3. **Include acceptance criteria.** Every ticket ends with a checklist of verifiable conditions that define "done". Use the format:
   ```
   ## Acceptance Criteria
   - [ ] [Observable outcome]
   - [ ] [Observable outcome]
   ```

4. **One scope per ticket.** If a ticket covers two unrelated changes, split it. A ticket should be completable in one PR.

5. **Lead with context, then spec.** Structure:
   ```
   ## Summary
   [1-2 sentences: what and why]

   ## Spec
   [Exact requirements – what changes, where, how it behaves]

   ## Acceptance Criteria
   - [ ] ...
   ```

6. **Name concrete entities.** Reference specific files, components, endpoints, tables, or functions – not vague areas like "the backend" or "the UI".

7. **Specify behavior, not implementation.** Say "the endpoint returns 404 when the resource doesn't exist" – not "add an if-check somewhere".

## When invoked with arguments

If `$ARGUMENTS` is provided, treat it as a description of the work to be ticketed. Break it into however many tickets are appropriate, following all rules above. Output each ticket in full, ready to paste into Linear or GitHub Issues.

## When invoked without arguments

Ask what work needs to be ticketed.
