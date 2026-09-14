---
name: human-taste-review
description: "Turn someone else's PR into a narrated, scroll-through tour, so you understand the change before you judge it."
argument-hint: "PR URL - e.g., https://github.com/wandb/workflows/pull/<pr-number>"
disable-model-invocation: true
---

# Human taste review

You are about to review someone else's PR. Before you can have taste about a
change, you have to understand it. This builds one HTML file that explains the
change — why, then what, then how — and reads it aloud if you want it to.

Invoked by the reviewer, on the reviewer's machine. Takes a PR number. Nothing
is posted anywhere; the tour ends and you go comment on GitHub yourself.

## Out of scope

- **Convention miss** — automated PR review already catches it.
- **CI failure** — a prerequisite to this review, not a finding of it.

## What taste actually reviews

Three questions. Everything else is a convention check wearing a costume.

1. **Does this change need to exist?** The lazy reviewer's first question.
2. **Is this the root cause, or a patch on the symptom?** One guard in the
   shared function, or a guard in every caller.
3. **Will someone understand this at 3am?** Clever is what gets decoded under
   pressure.

## Process

**0. Confirm CI is green.** `gh pr checks <n>`. Red or still pending means
stop — you'd be reviewing taste on code that doesn't run yet.

**1. Gather.** No checkout, no branch switch:

```
gh pr view <n> --json title,body,commits,files,url
gh pr diff <n>
```

If the body links an issue, read that too. It usually holds the why.

**2. Build the narrative before you build the page.** Three passes, in order,
because each one constrains the next:

- **Why** — what broke, or what was impossible before. One paragraph.
- **What** — the changes that follow from that why. One line each.
- **How** — for each what, the mechanism. This is where code excerpts belong.

**3. The honesty rule.** If you cannot state the why from the PR body, the
commits, and the linked issue — say that in the tour. Do not infer one from the
diff. "This PR does not explain why it exists" is the most useful thing the
tour can tell a reviewer, and inventing a plausible why destroys it. That
invention is the exact slop this skill exists to avoid.

**4. Cap the tour.** A ten-change PR is not a twenty-screen tour — that is the
thing this skill exists to prevent. Above roughly seven steps, say the PR is too
big to tour and name only the two or three whats that carry the change. A
reviewer who needs all ten wants the diff, not narration.

**5. Fill in the tour.** Copy [TOUR-TEMPLATE.html](./TOUR-TEMPLATE.html) to the
scratchpad, replace its one JSON block, and `open` it. You are writing narration,
not HTML — the contract is in [INTERACTIVE-TOUR.md](./INTERACTIVE-TOUR.md).

## Writing for the ear

The narration is the product. It gets read aloud, and speech is a much harsher
editor than the eye — vague prose survives silent reading and dies out loud.

- **Never speak an identifier or a path.** "The sensor module," not
  `sensors/dagster_sensor.py:42`. If a symbol has to be seen, put it in the
  code excerpt, not the sentence.
- **Short sentences.** One clause. A listener has no scrollback.
- **No lists.** "First, second, third" read aloud is a shopping receipt. Prose
  with actual connective tissue — *because*, *so*, *which meant* — is what
  makes a change make sense.
- **Say the stakes early.** A listener who doesn't know why they're listening
  has already stopped.

Read a step back to yourself before you ship it. If it sounds like a changelog,
rewrite it.
