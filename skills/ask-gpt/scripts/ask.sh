#!/usr/bin/env bash
# Meneruskan satu prompt ke Codex CLI di mesin yang sama, lalu mencetak jawaban akhirnya.
# Pakai: ask.sh [--cd <dir>] [--model <m>] [--write] [--resume <id|last>] [--image <file>]... [--raw] [--dry-run] < prompt.txt
# Prompt dibaca dari stdin. ID sesi Codex dicetak ke stderr supaya bisa dilanjutkan dengan --resume.
set -euo pipefail

dir="$PWD"; model=""; sandbox="read-only"; resume=""; raw=0; dry=0; images=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cd) dir=$2; shift 2 ;;
    --model) model=$2; shift 2 ;;
    --write) sandbox="workspace-write"; shift ;;
    --resume) resume=$2; shift 2 ;;
    --image) images+=("$2"); shift 2 ;;
    --raw) raw=1; shift ;;
    --dry-run) dry=1; shift ;;
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
    *) echo "Argumen tidak dikenal: $1" >&2; exit 2 ;;
  esac
done
command -v codex >/dev/null || { echo "codex tidak ada di PATH. Pasang Codex CLI lalu jalankan 'codex login'." >&2; exit 3; }
[[ -d "$dir" ]] || { echo "Folder tidak ditemukan: $dir" >&2; exit 2; }
for f in "${images[@]+"${images[@]}"}"; do [[ -f "$f" ]] || { echo "Gambar tidak ditemukan: $f" >&2; exit 2; }; done
[[ ! -t 0 ]] || { echo "Prompt wajib lewat stdin, misalnya: ask.sh < prompt.txt" >&2; exit 2; }

work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
{
  if [[ $raw -eq 0 ]]; then
    cat <<'PRE'
You are being consulted as a second opinion by another AI coding agent (Claude Code) running on the same machine. Answer the request below directly and completely. State uncertainty plainly. If you inspect files, cite paths.

Follow the user's style and interaction rules: those in any instruction files you loaded (such as AGENTS.md), and those in an "ATURAN GAYA PENGGUNA:" block if the request contains one. They cover language, tone, formatting, depth of explanation, and how decisions are put to the user. The block wins when the two conflict.

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
