---
name: review-doc
description: Multi-perspective review of documents created in this workspace. Use this skill whenever creating or finalizing any document — including code plans, design docs, PRDs, specs, or any written deliverable. Reviewers 1-3 review ALL docs; reviewers 4-5 review design docs only.
user-invocable: true
argument-hint: [path-to-doc]
---

# Multi-Perspective Document Review

This skill runs in **two passes**:

## Pass 1 — Silent Review & Apply

Review the document at `$ARGUMENTS` (or the document just created/edited in this conversation) from all applicable expert perspectives listed below. Do NOT output the review to the terminal. Instead, **directly apply all feedback by editing the document**. Make every change the reviewers would ask for — tighten language, fill gaps, fix structure, add missing sections. Treat every REVISE item as a requirement and resolve it in the doc.

Do not ask for confirmation. Just improve the document.

## Pass 2 — Final Review & Report

After applying all changes, re-read the updated document and run the full review again. This time, **output the results to the terminal** using this format for each reviewer:

```
### [Role] Review

**Verdict:** APPROVE | REVISE (with specific items)

- Bullet feedback: what's strong, what's missing, what to change
```

If any reviewer still has REVISE items after Pass 2, apply those changes as well and note what was fixed.

---

## Required Reviewers (all documents)

### 1. Seasoned Product Leader

You are a product leader with 15+ years shipping B2B and B2C products. You've seen scope creep kill launches and vague requirements waste engineering cycles.

Review for:
- **Clarity of intent** — Can someone not in the room understand what this is and why it matters?
- **User problem framing** — Is the problem stated before the solution? Is there evidence the problem is real?
- **Scope discipline** — Is the scope tight enough to ship and learn, or is it a wish list?
- **Success criteria** — Are there measurable outcomes, not just deliverables?
- **Edge cases and risks** — What's missing that will bite the team mid-build?
- **Prioritization** — Is there a clear "must have" vs "nice to have" distinction?

### 2. CPO (Chief Product Officer)

You are a CPO who thinks in terms of portfolio strategy, market positioning, and cross-functional alignment. You care about whether this work ladders up to something bigger.

Review for:
- **Strategic alignment** — Does this advance a clear business objective or is it disconnected effort?
- **Market context** — Does the doc show awareness of competitors, timing, or market dynamics?
- **Cross-functional impact** — Are dependencies on other teams or systems acknowledged?
- **Sequencing** — Does this unlock future work or paint the team into a corner?
- **Resource justification** — Is the investment proportional to the expected impact?
- **Narrative coherence** — Could this doc convince a board or investor why this matters now?

### 3. CTO (Chief Technology Officer)

You are a CTO who has scaled systems from prototype to millions of users. You think about architecture longevity, team velocity, and technical debt as a business risk.

Review for:
- **Technical feasibility** — Are the proposed approaches realistic given the stack and team?
- **Architecture impact** — Does this create tech debt, or does it build on solid foundations?
- **Scalability and performance** — Will this hold up at 10x or 100x scale?
- **Security and compliance** — Are there data, auth, or regulatory considerations missing?
- **Operational readiness** — Monitoring, rollback, migration path — are they addressed?
- **Build vs buy** — Is the team building something that already exists as a proven tool?
- **For code plans specifically** — Are the implementation steps in a logical dependency order? Are there missing steps?

---

## Design Doc Reviewers (design docs only — skip for code plans, PRDs, and specs)

A document is a "design doc" if it covers UI/UX flows, visual design, branding, user-facing copy, landing pages, marketing materials, or similar.

### 4. Marketing Leader

You are a marketing leader who has launched products across channels. You think about positioning, messaging hierarchy, and conversion.

Review for:
- **Positioning clarity** — Is the value proposition immediately obvious?
- **Messaging hierarchy** — Does the most important message hit first? Is there a clear CTA?
- **Audience targeting** — Is the language calibrated for the intended audience, not the internal team?
- **Consistency** — Does the tone, terminology, and branding match the rest of the product?
- **Conversion thinking** — Does the design guide users toward a desired action?
- **Competitive differentiation** — Does this stand out or blend in with competitors?

### 5. Design Lead

You are a design lead with deep expertise in interaction design, visual systems, and accessibility. You think in user flows, not screens.

Review for:
- **User flow completeness** — Are all states covered (empty, loading, error, success, edge)?
- **Information hierarchy** — Is the visual weight distributed correctly?
- **Accessibility** — Color contrast, keyboard nav, screen reader considerations?
- **Consistency with design system** — Does this follow existing patterns or introduce new ones without justification?
- **Mobile/responsive** — Is the experience considered across breakpoints?
- **Cognitive load** — Is the user asked to think more than necessary?

---

## Output Format

After all reviews, add a summary section:

```
## Summary

**Consensus:** [One sentence on overall quality]
**Top 3 action items:**
1. ...
2. ...
3. ...
**Reviewers who approved without revision:** [list]
```

If there are REVISE verdicts, list the specific changes needed before the doc should be considered final.
