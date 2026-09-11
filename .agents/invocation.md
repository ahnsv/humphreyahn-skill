# User-invoked vs model-invoked

Every `SKILL.md` here is a skill. The one axis that splits them is **invocation**: who can reach it.

## User-invoked

Reachable only when I type its name. Set `disable-model-invocation: true` in the frontmatter.

The `description` is **human-facing**: a one-line summary read by a person scanning the slash-command list. Strip trigger phrasing ("Use when the user says...") -- nothing is matching on it.

These are the orchestrators. A user-invoked skill may call model-invoked skills, but never another user-invoked one.

## Model-invoked

Reachable by the model *or* by me. The default: omit `disable-model-invocation`.

The `description` is **model-facing** and keeps rich trigger phrasing ("Use when the user wants..., mentions..., asks for...") so auto-invocation actually fires.

The test for whether a skill should be model-invoked: *could the model usefully reach for this on its own?* Reuse is the reason to extract a skill, not the test for how it's invoked. A coding standard the agent should apply whenever it writes code is model-invoked; a workflow I decide to start is user-invoked.

These hold the reusable discipline.

## Dependencies between skills

Express a dependency as an explicit instruction to **call the Skill tool** with the named skill:

> Call the Skill tool with "<model-invoked-skill>".

Not a deep `../other-skill/FILE.md` link, and not a bare `/skill` mention left for the model to interpret. Naming the tool is what gets it fired: harnesses expose skill invocation as a tool the model calls, and spelling that out beats dropping a `/name` into prose and hoping it reads as a command. Dropping the leading `/` also keeps it harness-neutral.

The Skill tool takes one skill per call. A step needing two skills is two calls: say `Call the Skill tool twice, for "a" and "b"`, not "call it with a and b".

This convention only holds when the named skill is **model-invoked**. A user-invoked skill can never be reached this way, including by naming it to the Skill tool. Where a step's precondition is a user-invoked skill, phrase it as an instruction for the human: "tell the user to run `/<that-skill>`".

Router prose that just names skills for a human to pick from (bucket `README.md`s) isn't invoking anything, so it keeps `/skill`-style names as plain labels.
