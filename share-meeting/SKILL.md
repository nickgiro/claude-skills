---
name: share-meeting
description: Compose a meeting follow-up email (summary, decisions, action items) from a Granola transcript and create a Gmail draft. Lists meetings from the past 24 hours, lets the user pick one, runs the draft through /review-doc, then drops it in Gmail.
user-invocable: true
argument-hint: "[meeting name or search term]"
---

# Share Meeting Follow-Up

Compose a follow-up email from a recent meeting transcript and create a Gmail draft for the user to review before sending.

## Step 1 – Sync Granola

Before looking for meetings, sync the latest transcripts by running:

```bash
cd "C:\Users\nickg\OneDrive\Desktop\Work\meetings" && python sync-granola.py
```

If the sync fails, warn the user but continue – there may still be previously synced transcripts to work with.

## Step 2 – Find Recent Meetings

Meetings are stored at `C:\Users\nickg\OneDrive\Desktop\Work\meetings\` organized as `YYYY/MM/filename.md`. Filenames start with the date: `YYYY-MM-DD – Title.md`.

1. Compute today's date and yesterday's date.
2. Glob for `*.md` files in the meetings directory whose filenames start with either date prefix. Check both the current month and previous month directories (in case yesterday crosses a month boundary).
3. If `$ARGUMENTS` is provided, filter the results to only meetings whose title contains the argument (case-insensitive).
4. If no meetings are found, tell the user: "No meeting transcripts found from the past 24 hours. Make sure Granola has synced, or provide a filename." Then stop.

## Step 3 – Select a Meeting

- If exactly one meeting matches, confirm it with the user.
- If multiple meetings match, present a numbered list using `AskUserQuestion`:
  ```
  1. Meeting Title (YYYY-MM-DD)
  2. Another Meeting (YYYY-MM-DD)
  ```
  Let the user pick by number.

Extract the title from the filename (the part after `YYYY-MM-DD – `).

## Step 4 – Read Transcript and Compose the Email

Read the full transcript file. Parse the YAML frontmatter to extract:
- `title` – meeting name
- `date` – meeting date
- `attendees` – list of `Name <email>` strings
- `owner` – the sender (will be excluded from recipients)

Analyze the `## Transcript` section and compose a follow-up email as **HTML** (since Gmail requires HTML for formatting). Do NOT use markdown – use real HTML tags.

**Layout rules:**
- No headings (`<h1>`, `<h2>`, etc.) – use `<b>` for section titles instead
- Use `<b>` for bold, `<i>` for italics, `<u>` for underline
- Between sections, insert a visible horizontal separator: `<hr style="border:none;border-top:1px solid #ddd;margin:24px 0 16px 0">`
- Use `<ul>` / `<li>` for bullet lists
- Use `<br>` for line breaks within text blocks
- Keep font styling minimal – Gmail will use the user's default font

**Template:**

```html
<p>Hi all,</p>

<p>Thanks for the time today. Here's a quick recap from [title] on [date formatted as Mon DD, YYYY].</p>

<hr style="border:none;border-top:1px solid #ddd;margin:24px 0 16px 0">

<p><b>Summary</b></p>

<p>[1–2 punchy sentences. What was this meeting about and what's the takeaway? No play-by-play.]</p>

<hr style="border:none;border-top:1px solid #ddd;margin:24px 0 16px 0">

<p><b>Key Decisions</b></p>

<ul>
<li>[Decision 1]</li>
<li>[Decision 2]</li>
<li>[Decision 3]</li>
</ul>

<hr style="border:none;border-top:1px solid #ddd;margin:24px 0 16px 0">

<p><b>Action Items</b></p>

<ul>
<li><b>[Owner first name]:</b> [What they committed to do] [– by when, if a timeline was mentioned]</li>
<li><b>[Owner first name]:</b> [What they committed to do]</li>
</ul>

<hr style="border:none;border-top:1px solid #ddd;margin:24px 0 16px 0">

<p>Let me know if I missed anything or got something wrong.</p>

<p>Best,<br>[Owner first name from frontmatter]</p>
```

### What to extract

**Summary:** 1–2 sentences max. Lead with the core topic and the main takeaway. Think "what would I text someone who asked what the meeting was about?" – not a paragraph.

**Key Decisions:** Look for:
- Explicit agreements: "Let's do X", "We decided...", "Agreed", "Sounds good"
- Direction changes: "Instead of X, let's Y", "We're going to pivot to..."
- Prioritization calls: "Let's push X forward", "X is blocked, focus on Y"
- Technical/architectural decisions: tool choices, approach decisions, scope calls
- Commitments: "We'll ship by Friday", "Target is next sprint"

**Action Items:** Look for:
- Assignments: "I'll handle X", "You'll take care of Y", "Can you do Z?"
- Follow-ups: "Let's circle back on X", "I'll send that over"
- Deliverables: "I'll have the doc ready by Thursday"

Include the owner's name for each action item when discernible from the transcript. If a timeline was mentioned, include it.

If the transcript is too short or no meaningful decisions/actions can be extracted, tell the user and ask whether to proceed with whatever is available or skip.

## Step 5 – Review the Draft

**IMPORTANT: Do NOT invoke `/review-doc` as a skill. Perform the review inline within this same flow to avoid breaking the pipeline.**

1. Write the composed HTML email body to `.claude/tmp/share-meeting-draft.html` in the workspace directory.
2. Review the draft from three perspectives (Product Leader, CPO, CTO) – focus on clarity, tone, and completeness for a team follow-up email. Silently apply any improvements by editing the file directly. Keep it brief – this is a meeting recap, not a PRD.
3. Read the reviewed file back and output a short review summary (verdicts only, 1–2 lines each). This becomes the final email body.
4. **Immediately continue to Step 6** – do not stop or wait for user input after the review.

## Step 6 – Confirm Target Account

Before creating the draft, surface the account choice to the user via `AskUserQuestion`.

1. Detect which Gmail account is currently connected by calling `mcp__claude_ai_Gmail__search_threads` with query `in:sent from:nick.girolami@aligned.team` (pageSize 1). If results come back, the connected account is aligned; if empty, assume personal.
2. Ask the user via `AskUserQuestion`:
   - **Question:** "Which account should this draft go to?"
   - **Header:** "Account"
   - **Options:**
     - `Personal (girolaminicholas@gmail.com)` – personal Gmail account
     - `Aligned (nick.girolami@aligned.team)` – work Gmail account
   - Put whichever account matches the detected connected account first, and append `(connected)` to its label so the user can see which is active.
3. If the user's choice matches the connected account, proceed to Step 7.
4. If the user's choice does NOT match the connected account, stop and tell the user: "The [chosen] account isn't the one connected to MCP. Switch the Gmail connection and re-run, or pick the connected account." Then halt.

## Step 7 – Create Gmail Draft

1. Use `ToolSearch` with query `"+Gmail"` to discover available Gmail MCP tools (if not already loaded).
2. If Gmail is not yet authenticated, call `mcp__claude_ai_Gmail__authenticate` and wait for auth to complete.
3. Create a Gmail draft with:
   - **To:** All attendees from frontmatter EXCEPT the owner. Match on the `owner` field from the YAML frontmatter to determine who to exclude – do not hardcode an email address. Extract just the email addresses (the part inside `< >`).
   - **Subject:** `Follow Up – [title] – [date as Mon DD, YYYY]`
   - **Body:** The reviewed HTML email content from Step 5.
   - **contentType:** `text/html` – the body is HTML, not markdown.

## Step 8 – Clean Up and Confirm

1. Delete the temp file (`.claude/tmp/share-meeting-draft.html`).
2. Tell the user: "Draft created in Gmail. Open Gmail to review, edit recipients/CC/BCC, and send when ready."

## Rules

- Always use – (en dash) instead of — (em dash) in all output.
- Keep the email concise and scannable. No fluff, no filler.
- Write outcomes, not activities. "Agreed to ship X by Friday" – not "Discussed shipping timeline."
- If a section would be empty (no decisions, or no action items), omit that section rather than writing "None."
- The email tone should be professional but not stiff – this is a team follow-up, not a board report.
