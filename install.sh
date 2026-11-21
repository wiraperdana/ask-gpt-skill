#!/usr/bin/env bash
# Memasang skill ask-gpt dan ask-gpt-first sebagai symlink di ~/.claude/skills. Skill ini khusus Claude Code,
# jadi sengaja tidak dipasang ke ~/.agents/skills: Codex tidak perlu bertanya ke dirinya sendiri.
# ask-gpt-first memakai skrip dan rujukan di folder ask-gpt, jadi keduanya selalu dipasang bersama.
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="$HOME/.claude/skills"; mkdir -p "$target_dir"
status=0
for name in ask-gpt ask-gpt-first; do
  skill_dir="$repo_dir/skills/$name"; target="$target_dir/$name"
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -L "$target" && "$(readlink "$target")" == "$skill_dir" ]]; then echo "Sudah terpasang: $target"; continue; fi
    echo "Target sudah ada, periksa manual: $target" >&2; status=1; continue
  fi
  ln -s "$skill_dir" "$target"
  echo "Terpasang: $target -> $skill_dir"
done
exit $status
