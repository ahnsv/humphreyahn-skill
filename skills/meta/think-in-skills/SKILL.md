---
name: think-in-skills
description: "Turn the conversation just had into a skill."
disable-model-invocation: true
---

# Think in skills

Look back over the conversation we just had and find the repeatable practice buried in it. Then shape that into a skill.

The agent needs a clear direction, so the output is a skill with:

- A `name` matching its directory, and a `description` written for its invocation mode (see `.agents/invocation.md`).
- A bucket: `coding/`, `meta/`, or `in-progress/` if it isn't proven yet.
- One decision the skill makes that the default behaviour gets wrong. If there isn't one, there is no skill here.
