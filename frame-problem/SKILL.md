---
name: frame-problem
description: Write a problem-framing 1-pager for discovery – a sharp problem statement, not a solution spec. Use when the user asks to "frame a problem", write a "problem statement", or requests a PRD/1-pager for work that is early or pre-discovery.
user-invocable: true
argument-hint: "[the problem to frame, plus any context]"
---

# Frame Problem

Write a 1-pager that shapes a problem and generates discovery. The output exists to uncover a vision, not to work toward a solution.

## When this skill applies (vs a PRD)

Trigger on: "frame the problem", "problem statement", "1-pager to frame X", or any doc request for early/pre-discovery work – **even if the user says "PRD"**. In a discovery-first product culture, requirements and user stories written at this stage prematurely encode a solution and shut down discovery.

If the altitude is ambiguous (the request could be problem-framing or a solution spec), confirm with the user before writing: "Is this to shape the problem for discovery, or are we specifying a solution?"

## Structure

```
# [Problem name]

## Context
[What's happening, for whom, and where this sits in the product/business. 2–4 sentences.]

## Problem statement
[One sharp paragraph. The tension or unmet need, stated from the user's or business's side – not a missing feature.]

## Why now
[What makes this worth framing today – a trigger, a cost that's compounding, a window.]

## What we know
[Observations, signals, and constraints already in hand. Facts only – no interpretations dressed as facts.]

## What we need to discover
[Open questions, ordered by how much they'd change our understanding. These drive the discovery work.]

## What success for this framing looks like
[Not success for a solution – success for the framing itself: e.g. "we can articulate which of these three tensions is load-bearing", "we know enough to decide whether to invest a discovery cycle".]
```

## Rules

1. **No functional requirements, no user stories, no scope sections.** If you find yourself writing "the system shall" or "as a user I want", you've dropped altitude – delete it and restate as a question under "What we need to discover".

2. **Name the problem, not the feature.** "Users can't hold more than one intention at a time and abandon the flow" – not "we need multi-intention support". Abstract feature asks committed before their complexity is understood are the failure mode this skill exists to prevent.

3. **Separate knowledge from questions.** Everything asserted goes under "What we know" only if it's observed or sourced. Everything else is a discovery question.

4. **Keep it to one page.** If it's longer, the framing isn't sharp yet – cut context, not questions.

5. **Review before presenting.** Invoke `/review-doc` on the draft and apply feedback before handing it over.

## When invoked with arguments

Treat `$ARGUMENTS` as the problem and context. Draft immediately, asking at most one clarifying question if the altitude (problem vs solution) is genuinely unclear.

## When invoked without arguments

Ask the user what problem they want to frame and what context they have.
