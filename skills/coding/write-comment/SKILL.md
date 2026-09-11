---
name: write-comment
description: "Write a comment in code in a reasonable, human-friendly fashion."
disable-model-invocation: true
---

# Write comments in code

## The 10-second test

**One month from now you open this file cold. Within 10 seconds you should know
what it is — without opening anything else.**

That is the whole standard. Every comment either buys you seconds or spends
them. No one reads a wall of text; a wall of text spends the entire budget
before you reach the code.

Two things blow the budget, and they are the only two worth policing:

- **Length** — you can't read 12 lines in 10 seconds.
- **Context switches** — a comment that sends you to another repo, another
  file, or a ticket costs minutes, not seconds. It doesn't matter how true it is.

## Spend the budget on the header

One comment is non-negotiable: the top of the file. It answers **"what is one
of these?"** — one row, one record, one object — and nothing else.

```sql
-- ✅ Two lines. A month later this is all you need.
-- One row per (pull request, Jira issue key) mentioned by a wandb/core PR, with
-- where the key was found and how much that placement is worth.
```

Say where the definitions live *if* they live elsewhere — `Tier meanings are on
the columns in schema.yml` — and stop. The header is not the place for how it
works, what you tried first, or why the design is the way it is.

If the filename already says what the file is, you may not need a header at all.

## Below the header, comment only the exceptions

Once past the header the reader is scanning for surprises. A comment there is
one of exactly three things:

1. **Why this and not the obvious thing.** `least()` clamps here *because*
   moving an issue between projects resets `created`, which would otherwise
   make the span negative.
2. **A ceiling.** What this cannot do, so nobody builds on sand. "The first
   request is the baseline for every review on it, so latency under-reports for
   a reviewer added late."
3. **A pointer to the canonical home** — one line, when the real definition
   lives on a schema file, a type, or an ADR.

Anything else, cut. Code that needs no explanation gets no comment.

## Never make the reader leave

A comment naming something they cannot open is worse than no comment: it
advertises that context exists, then withholds it. A month later the referent
has usually moved or died.

| Don't name | Because |
| --- | --- |
| A PR or issue number in another repo | They can't open it, and it dies when that repo moves |
| A file path in another codebase | Stale the moment that file is renamed |
| An internal system, tool, or team | In-group shorthand to everyone else |
| A constant from an upstream service | They can't see its value or its members |

Keep the *reasoning*, drop the *reference*. "The extractor's `TIMELINE_ITEM_TYPES`
omits dismissal events" becomes "dismissals aren't in the upstream event feed."
The fact survives; the dead link doesn't.

## Things that quietly stop being true

Never embed a count, a percentage, a row total, or a date. In a month they are
wrong, and nothing fails — the comment just starts lying, and you trust the
rest of the file a little less.

```sql
-- ❌ A commit can carry more than one -- 62 of them name two different agents
-- ✅ A commit can carry several, so the agent is resolved over the whole set
```

"Can carry several" is still true next year. If a number is load-bearing, it
belongs in a test that fails when it changes — not in prose.

## One home per explanation

When the project has a docs surface — a schema file, an interface, a public
docstring — that surface owns the definition, because a consumer can read it
without the source. The comment points at it and adds only what a *code reader*
needs that a *consumer* doesn't.

Two copies always drift. By the time anyone notices, you can't tell which is
right.

## Put it on the thing it describes

A comment sits immediately above the construct it explains. If you write "the
regex below" and the next twelve lines are a loop, the comment belongs up on
the regex. A reader who has to hunt for the referent assumes the comment is
stale and stops trusting the rest.

## Match the house style

Before inventing a helper or constant to make something self-documenting, grep
how the rest of the codebase spells it. A wrapper used only by your files is a
dialect the next reader has to learn. If everyone else writes `/ 3600.0`
inline, write `/ 3600.0` inline.

## Real before/after

A dbt model header, cut on review:

```sql
-- ❌ 8 lines, two dead references, one stale percentage. A month later you are
--    three clicks deep and still don't know what a row is.
-- The evidence tiers and their confidences are the prototype's (wandb/core PR
-- #49463, scripts/pr_metrics/src/pr_metrics/sources/jira.py): a key under the
-- PR template's "## JIRA Issue(s)" heading was put there on purpose and is
-- trusted outright; a key anywhere else in the body carries ~90% of all links;
-- the title and then the branch name are progressively weaker, and a
-- branch-only key is the bottom tier.

-- ✅ 3 lines. What a row is, and where the rest lives.
-- One row per (pull request, Jira issue key) mentioned by a wandb/core PR, with
-- where the key was found and how much that placement is worth. Tier meanings
-- are on the columns in schema.yml.
```

## Red flags — the budget is already blown

- The header is longer than three lines
- A `#`-number, or a path into a repo that isn't this one
- A digit that came from running a query
- A sentence you also wrote in the schema file, the docstring, or the PR body
- "the prototype", "the ticket", "per our discussion", "as discussed"
- A header explaining what the file *does* instead of what one row *is*
- "below" or "above" pointing more than a few lines away
