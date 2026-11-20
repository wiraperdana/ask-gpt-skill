#!/usr/bin/env bash
# Memasang skill ask-gpt sebagai symlink di ~/.claude/skills. Skill ini khusus Claude Code,
# jadi sengaja tidak dipasang ke ~/.agents/skills: Codex tidak perlu bertanya ke dirinya sendiri.
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$repo_dir/skills/ask-gpt"
target_dir="$HOME/.claude/skills"; target="$target_dir/ask-gpt"
mkdir -p "$target_dir"
if [[ -e "$target" || -L "$target" ]]; then
  if [[ -L "$target" && "$(readlink "$target")" == "$skill_dir" ]]; then echo "Sudah terpasang: $target"; exit 0; fi
  echo "Target sudah ada, periksa manual: $target" >&2; exit 1
fi
ln -s "$skill_dir" "$target"
echo "Terpasang: $target -> $skill_dir"
