---
name: problem-discovery
description: Disciplined protocol for business-problem discovery conversations. Use when the user is hunting for a business problem, sharpening a pain point, evaluating a wedge, anchoring on a company to instrument, or running post-launch problem discovery against a shipped product. Enforces: structural-blockers-first, anchor-specifics-before-inference, problem-space-discipline, and parallel inward/outward streams when a solution is already in market.
user-invocable: true
argument-hint: "[problem description or anchor]"
---

# Problem Discovery

This skill enforces discovery discipline when the user is hunting, sharpening, or characterizing a business problem. It is not for solution design – it is for sharpening *who hurts, when, why, and how much* without prematurely collapsing into product talk.

## When to invoke

Activate when the user is doing any of the following:

- Hunting a business problem ("help me find a problem worth $20k MRR", "what's a wedge in X")
- Sharpening a pain point or buyer ("how big is this pain, who pays")
- Evaluating an anchor company as a potential instrumented design partner
- Doing post-launch discovery on a shipped product with a fuzzy problem ("we launched, retention is unclear, what should we learn")
- Building a TAM, evidence pack, or buyer profile around a stated problem

Do NOT activate for: solution design sessions, spec writing, architecture, or any conversation where the user has already named a concrete problem + segment + buyer and is moving to build.

## Core protocol

### Rule 1 — Establish structural constraints in turn 1–2

Before going deep on pain magnitude, cost structure, or buyer profile, ask about the constraint set:

- What system, regulation, vendor, or mandatory process does this work happen inside or alongside?
- Is anyone already paying for a tool that owns this workflow?
- Who sets the rules – the buyer, a regulator, a downstream party?
- Is the workflow gatekept (compliance, audit, certification)?

Treat "what eats the economics here?" as a precondition to "how big is the pain?" If the constraint set rules out a software wedge (regulated system + dominant incumbent + closed API), park the problem fast instead of sharpening it further.

Domain examples where this trap lives: pharma (Veeva PromoMats), finance (Bloomberg, core banking), legal (iManage, NetDocuments), healthcare (Epic, Cerner), construction (Procore).

### Rule 2 — Confirm anchor specifics before inferring sub-vertical

When the user names an anchor with a generic descriptor ("an agency does X", "a startup struggles with Y"), treat the descriptor as conversational shorthand, not a vertical claim. Before building a generalized problem statement, TAM, or evidence pack, ask one upfront question:

- What size and sub-vertical is the anchor?
- What stack are they on?
- Is it the user's company, a client, or an example?

One sentence in turn 2 ("What size and discipline is the agency you have in mind, and is it your company or an example?") prevents three turns of mis-framed work. If the user corrects you, do not overcorrect into the opposite extreme – ask one clarifying question and re-anchor cleanly.

### Rule 3 — Stay in problem-space until explicitly signaled

Do NOT propose or hint at solutions, technical approaches, product wedges, or "the answer is X" during discovery. Solution-talk too early collapses problem definition prematurely.

Instead, push on problem-space dimensions:

- Who feels the pain
- When it triggers
- Frequency
- Cost per occurrence
- Current workaround
- Structural constraints (see Rule 1)
- Buyer vs. user
- Willingness/authority to pay

If a solution thought is unavoidable, name it as a constraint or open question, not a recommendation. Wait for explicit signal that the user wants to move into solution mode before going there.

### Rule 4 — Solution in market + fuzzy problem → parallel inward + outward streams

When the user has shipped a product but the problem space is fuzzy, propose two parallel discovery streams. Do NOT defer segment work, and do NOT interrogate launch users on motivation.

**Workstream A (inward, observational):** Characterize the launch cohort using intake + telemetry + light qualitative ("tell me about your situation," not "why are you using this"). Output is descriptive cohort archetypes, not segments. The launch cohort cannot reliably introspect on retention drivers, especially with a novelty/habit-loaded product – treat self-report on retention motivation as unreliable signal.

**Workstream B (outward, hypothesis-driven):** Name candidate **segment-problem-mechanism triples** ("[X people] have [Y problem] and [product] helps via [Z mechanism]"), recruit self-identifiers, ship the product framed against Y, measure value with a pre-defined bar. This is where the *why* gets answered – through structured testing, not launch-user interrogation.

The streams cross-pollinate: A's patterns generate B's hypotheses; B's wins get re-checked in A's data. The unit in Workstream B is the triple, not pure segments or pure problems – because a shipped product is a solution looking for a problem-shape its mechanism uniquely fits.

## Output shape

When invoked, structure the conversation as follows:

1. **Opening turn:** If the user has named an anchor with a generic descriptor, ask the anchor-specifics question (Rule 2). Otherwise, ask the structural-constraints question (Rule 1).
2. **Turns 2–4:** Sharpen the constraint set and the problem-space dimensions. Do not propose solutions.
3. **When to recommend parking:** If structural blockers (regulated system + dominant incumbent + closed API) emerge, name it and recommend parking the problem rather than sharpening further.
4. **When to recommend parallel streams:** If the user reveals a shipped solution + fuzzy problem, propose Workstream A + B explicitly and offer to draft both.
5. **Solution mode transition:** Only move into solution-space when the user explicitly signals (e.g. "ok, what should we build", "what's the wedge"). Until then, stay disciplined.

## What this skill is NOT

- It is not strategy review (use `review-strategy` for that, with its scope guard)
- It is not ticket writing (use `write-tickets`)
- It is not doc review (use `review-doc`)
- It does not edit any artifacts – it shapes the conversation
