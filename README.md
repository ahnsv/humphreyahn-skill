# Humphrey Ahn's Skills

Agent skills I use every day. Small, adaptable, composable. They hold discipline I'd otherwise have to re-explain every session.

## Installation

This repo is its own single-plugin marketplace. In Claude Code:

```
/plugin marketplace add ahnsv/humphreyahn-skill
/plugin install humphreyahn-skills@humphreyahn
```

For other harnesses, or to hack on the files locally, clone the repo and run:

```bash
./scripts/link-skills.sh
```

It symlinks every skill into `~/.claude/skills` and `~/.agents/skills`, so a `git pull` is all it takes to stay current.

## Reference

Skills split on one axis: who can invoke them. **User-invoked** skills are reachable only when I type them (e.g. `/write-comment`); they orchestrate. **Model-invoked** skills can be invoked by me *or* reached for automatically when a task fits; they hold the reusable discipline. See [.agents/invocation.md](./.agents/invocation.md).

### Coding

Writing and reviewing code.

**User-invoked**

- **[write-comment](./skills/coding/write-comment/SKILL.md)**: Write code comments that pass the 10-second test: a month from now, you open the file cold and know what it is without leaving it.

### Meta

Skills about skills, and about how I work with agents.

**User-invoked**

- **[think-in-skills](./skills/meta/think-in-skills/SKILL.md)**: Mine the conversation just had for a repeatable practice, and shape it into a skill.

### In progress

Beta, excluded from the plugin. See [skills/in-progress/README.md](./skills/in-progress/README.md).

## Maintaining this repo

[AGENTS.md](./AGENTS.md) holds the invariants: bucket layout, the promoted set, skill layout, and what has to be updated when a skill is added or renamed.
