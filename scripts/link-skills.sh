#!/usr/bin/env bash
set -euo pipefail

# Dev-only. Links every skill in this repo into the local skill directories
# used by each agent harness:
#   ~/.claude/skills: Claude Code
#   ~/.agents/skills: Codex and other Agent Skills-compatible harnesses
# Each entry is a symlink into the repo, so a `git pull` keeps installed
# skills current. `in-progress/` is linked too: this local install is where
# its feedback loop runs.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -print0)

for DEST in "${DESTS[@]}"; do
  # A $DEST that symlinks back into this repo would make us write the per-skill
  # symlinks into the repo's own skills/ tree. Bail instead of polluting it.
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$DEST\") and re-run." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    target="$DEST/${names[$i]}"
    # $DEST is a flat namespace shared with every other source of skills, and
    # holds real directories as well as symlinks. Never clobber a real one:
    # the name collision is the thing to fix, not the directory.
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skipped ${names[$i]}: $target is a real directory, not a symlink" >&2
      continue
    fi
    ln -sfn "${srcs[$i]}" "$target"
    echo "linked ${names[$i]} -> ${srcs[$i]} ($DEST)"
  done
done
