---
name: ask-gpt-first
description: GPT lewat Codex CLI lokal (login ChatGPT, tanpa API key) menjawab lebih dulu sesuai konteks, lengkap dengan gaya bahasa, pedagogi, dan cara berinteraksi pengguna. Claude lalu me-review tanpa mengubah jawaban GPT. Khusus Claude Code. Pakai saat pengguna mengetik "/ask-gpt-first <prompt>", atau meminta "tanya GPT", "tanya Codex", "minta pendapat GPT", "second opinion GPT", "bandingkan dengan jawaban GPT". Bila kata pertama prompt ":visually" atau "visually", skill juga membuat berkas HTML berisi visualisasi animasi interaktif dan contoh kasus. Untuk Claude yang menjawab lebih dulu lalu diperhalus GPT, pakai /ask-gpt.
---

# ask-gpt-first

Skill ini membuat Claude Code **bertanya ke Codex**, agent milik OpenAI yang terpasang di komputer yang sama. GPT menjawab lebih dulu. Codex memakai login langganan ChatGPT pengguna, jadi tidak perlu `OPENAI_API_KEY`.

**Analogi.** Claude seperti dokter yang meminta konsultasi ke dokter spesialis lain di gedung yang sama. Claude mengirim surat rujukan (prompt). Spesialis memeriksa dan menulis jawabannya. Claude lalu menyerahkan jawaban itu ke pasien apa adanya, dan boleh menambahkan catatannya sendiri secara terpisah.

Bedanya dengan `/ask-gpt`: di sana Claude yang menjawab lebih dulu, lalu GPT memperhalus.

Bila agent yang berjalan **adalah Codex sendiri**, jangan pakai skill ini. Jawab langsung.

Skrip dan aturan bersama tinggal di folder skill `ask-gpt`, jadi kedua skill wajib terpasang. **Baca `~/.claude/skills/ask-gpt/references/aturan-bersama.md` sebelum mulai.** Untuk mode visual, baca juga `~/.claude/skills/ask-gpt/references/visually.md`.

## Prasyarat

1. `codex` ada di PATH dan sudah login. Periksa dengan `codex login status`.
2. Bila belum login, berhenti dan minta pengguna menjalankan `! codex login`. Jangan beralih diam-diam ke API berbayar.

## Langkah

1. **Baca argumen.** Pisahkan penanda `:visually` dari prompt (aturan bersama bagian A).
2. **Susun prompt.** Kata-kata pengguna apa adanya, ditambah `KONTEKS DARI CLAUDE:` dan `ATURAN GAYA PENGGUNA:` bila perlu (aturan bersama bagian B). Claude tidak menulis jawabannya sendiri lebih dulu.
3. **Jalankan tanpa `--polish`:**

   ```bash
   ~/.claude/skills/ask-gpt/scripts/ask.sh [opsi] < /path/prompt.txt
   ```

   Pembuka standar menyuruh GPT menjawab lengkap, mematuhi aturan gaya pengguna, dan mendaftar keputusan terbuka alih-alih berasumsi diam-diam.
4. **Sajikan hasil** mengikuti aturan bersama bagian D. Review Claude ditulis di **Catatan Claude**, tanpa mengubah jawaban GPT.
5. **Mode visual**, bila aktif: buat HTML dari jawaban GPT, mengikuti `references/visually.md`.
6. **Simpan ID sesi.** Bila pengguna bertanya lanjutan untuk topik yang sama, pakai `--resume <id>` supaya Codex ingat percakapan sebelumnya.
