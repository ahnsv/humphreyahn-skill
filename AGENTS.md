# Maintaining this repo

Skills live in bucket folders under `skills/`:

- `coding/`: writing and reviewing code
- `meta/`: skills about skills, and about how I work with agents
- `in-progress/`: beta. Public on purpose, feedback wanted, not shipped in the plugin.

`coding/` and `meta/` are the **promoted** buckets. The plugin ships exactly the promoted set: every skill in them must appear in the top-level `README.md` and in `.claude-plugin/plugin.json`'s `skills` array. Skills in `in-progress/` must appear in neither.

The `skills` array is enumerated by hand rather than globbed (`"skills": "./skills/"`), because the enumeration is what enforces the promoted boundary. A glob would ship `in-progress/` too.

Run `claude plugin validate . --strict` after touching either manifest.

## Skill layout

- One skill per directory: `skills/<bucket>/<name>/SKILL.md`.
- `name:` in the frontmatter matches the directory name. The directory name is what the user types.
- A skill that grows reference material keeps it inside its own directory (`skills/coding/write-comment/EXAMPLES.md`), never as a `../other-skill/FILE.md` cross-reference.

## Invocation

Every `SKILL.md` is either **user-invoked** (`disable-model-invocation: true`, reachable only when I type it) or **model-invoked** (the model can reach for it when a task fits). The choice changes how the `description` is written. See [.agents/invocation.md](./.agents/invocation.md).

The top-level `README.md` and each promoted bucket's `README.md` group entries under **User-invoked** and **Model-invoked**. `in-progress/` uses a flat list.

## Bucket READMEs

Each bucket has a `README.md` listing every skill in it with a one-line description, the skill name linked to its `SKILL.md`. A skill that exists and isn't listed is a skill nobody will find.

## Local install

`scripts/link-skills.sh` symlinks every skill in the repo into `~/.claude/skills` and `~/.agents/skills`. `in-progress/` is linked too: that local install is exactly where its feedback loop runs. Because each entry is a symlink into this repo, a `git pull` keeps installed skills current. Re-run the script after adding, removing, or renaming a skill.

`scripts/list-skills.sh` prints every `SKILL.md` path in the repo.
