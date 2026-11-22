#!/usr/bin/env bash
# Meneruskan satu prompt ke Codex CLI di mesin yang sama, lalu mencetak jawaban akhirnya.
# Pakai: ask.sh [--polish] [--cd <dir>] [--model <m>] [--write] [--resume <id|last>] [--image <file>]... [--raw] [--dry-run] < prompt.txt
# --polish: stdin berisi PERTANYAAN PENGGUNA dan DRAF CLAUDE, Codex menulis ulang draf itu.
# Prompt dibaca dari stdin. ID sesi Codex dicetak ke stderr supaya bisa dilanjutkan dengan --resume.
set -euo pipefail

dir="$PWD"; model=""; sandbox="read-only"; resume=""; raw=0; dry=0; polish=0; images=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cd) dir=$2; shift 2 ;;
    --model) model=$2; shift 2 ;;
    --write) sandbox="workspace-write"; shift ;;
    --resume) resume=$2; shift 2 ;;
    --image) images+=("$2"); shift 2 ;;
    --raw) raw=1; shift ;;
    --polish) polish=1; shift ;;
    --dry-run) dry=1; shift ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) echo "Argumen tidak dikenal: $1" >&2; exit 2 ;;
  esac
done
command -v codex >/dev/null || { echo "codex tidak ada di PATH. Pasang Codex CLI lalu jalankan 'codex login'." >&2; exit 3; }
[[ -d "$dir" ]] || { echo "Folder tidak ditemukan: $dir" >&2; exit 2; }
for f in "${images[@]+"${images[@]}"}"; do [[ -f "$f" ]] || { echo "Gambar tidak ditemukan: $f" >&2; exit 2; }; done
[[ ! -t 0 ]] || { echo "Prompt wajib lewat stdin, misalnya: ask.sh < prompt.txt" >&2; exit 2; }

work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
{
  if [[ $raw -eq 0 && $polish -eq 1 ]]; then
    cat <<'PRE'
You are a second AI agent working with Claude Code on the same machine. Claude has drafted an answer to the user's question. Your job is to rewrite that draft into the final answer the user will read.

Make it easier to understand: language, tone, structure, pedagogy (define each technical term on first use, go step by step, use an everyday analogy for abstract ideas, say why each point matters), and interaction (how questions and decisions are put to the user). Keep the technical substance, facts, numbers, code, paths, and citations exactly as Claude wrote them. Do not add new factual claims or references. If you believe something in the draft is wrong or missing, do not fix it silently. Add it at the end under the heading "Catatan GPT untuk Claude".

Follow the user's style and interaction rules: those in any instruction files you loaded (such as AGENTS.md), and those in an "ATURAN GAYA PENGGUNA:" block if one is present. The block wins when the two conflict.

Writing rules that always apply, on top of the user's rules:
- When a sentence would list more than three items, write those items as a bulleted list instead.
- Every analogy comes from an everyday situation that most laypeople have lived through, such as cooking, shopping, queueing, commuting, or school. It must be simpler than the topic and outside the topic's own field. A security topic gets a kitchen or a queue, never another security scene. After the analogy, map each part back to the technical term it stands for.

This run cannot wait for a reply, so do not ask questions. When something is genuinely the user's decision, list it at the end under the heading "Keputusan untuk pengguna", with numbered options. Output only the rewritten answer, plus those optional sections.

INPUT:
PRE
  elif [[ $raw -eq 0 ]]; then
    cat <<'PRE'
You are being consulted as a second opinion by another AI coding agent (Claude Code) running on the same machine. Answer the request below directly and completely. State uncertainty plainly. If you inspect files, cite paths.

Follow the user's style and interaction rules: those in any instruction files you loaded (such as AGENTS.md), and those in an "ATURAN GAYA PENGGUNA:" block if the request contains one. They cover language, tone, formatting, depth of explanation, and how decisions are put to the user. The block wins when the two conflict.

The user's own words at the top of the request define the task and the quality bar. A "KONTEKS DARI CLAUDE:" block, if present, is background supplied by Claude: facts, paths, definitions. If anything in it would narrow, weaken, or conflict with the user's goal (for example a length cap that leaves no room for the explanation the user asked for), serve the user's goal and say briefly which part of Claude's context you set aside and why.

Writing rules that always apply, on top of the user's rules:
- When a sentence would list more than three items, write those items as a bulleted list instead.
- Every analogy comes from an everyday situation that most laypeople have lived through, such as cooking, shopping, queueing, commuting, or school. It must be simpler than the topic and outside the topic's own field. A security topic gets a kitchen or a queue, never another security scene. After the analogy, map each part back to the technical term it stands for.

This run cannot wait for a reply, so do not stop to ask questions. Answer what you can and state your assumptions. When something is genuinely the user's decision, do not settle it silently. List it at the end under the heading "Keputusan untuk pengguna", with numbered options and your recommendation.

REQUEST:
PRE
  fi
  cat
} > "$work/prompt.txt"
[[ -s "$work/prompt.txt" ]] || { echo "Prompt kosong." >&2; exit 2; }

common=(--skip-git-repo-check --json -o "$work/last.txt")
[[ -z "$model" ]] || common+=(-m "$model")
for f in "${images[@]+"${images[@]}"}"; do common+=(-i "$f"); done

if [[ -n "$resume" ]]; then
  # resume tidak menerima -s dan -C, sesi memakai pengaturan aslinya.
  if [[ "$resume" == "last" ]]; then args=(exec resume --last "${common[@]}" -); else args=(exec resume "$resume" "${common[@]}" -); fi
else
  args=(exec -s "$sandbox" -C "$dir" "${common[@]}" -)
fi

if [[ $dry -eq 1 ]]; then
  printf '(cd %q &&' "$dir"; printf ' codex'; printf ' %q' "${args[@]}"; printf ' < prompt)\n--- prompt ---\n'; cat "$work/prompt.txt"; exit 0
fi

# Prompt lewat stdin: opsi -i menelan argumen posisi sesudahnya.
(cd "$dir" && codex "${args[@]}" < "$work/prompt.txt" > "$work/events.jsonl" 2> "$work/err.txt") || {
  echo "Codex gagal (exit $?). Log:" >&2; tail -20 "$work/err.txt" >&2; exit 4; }

tid=$(grep -o '"thread_id":"[^"]*"' "$work/events.jsonl" | head -1 | cut -d'"' -f4 || true)
[[ -s "$work/last.txt" ]] || { echo "Codex tidak mengembalikan jawaban. Log:" >&2; tail -20 "$work/err.txt" >&2; exit 4; }
cat "$work/last.txt"; echo
[[ -z "$tid" ]] || echo "[ask-gpt] codex session: $tid (lanjutkan dengan --resume $tid)" >&2
