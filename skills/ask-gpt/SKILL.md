---
name: ask-gpt
description: Claude menjawab lebih dulu, lalu GPT lewat Codex CLI lokal (login ChatGPT, tanpa API key) memperhalus jawaban itu, yaitu gaya bahasa, pedagogi, dan cara berinteraksi, supaya lebih mudah dimengerti. Claude lalu me-review tanpa mengubah teks GPT. Khusus Claude Code. Pakai saat pengguna mengetik "/ask-gpt <prompt>", atau meminta jawaban Claude "diperhalus GPT", "dipoles GPT". Bila kata pertama prompt ":visually" atau "visually", skill juga membuat berkas HTML berisi visualisasi animasi interaktif dan contoh kasus. Untuk GPT yang menjawab lebih dulu, pakai /ask-gpt-first.
---

# ask-gpt

Skill ini membuat jawaban melewati dua tangan. **Claude menjawab lebih dulu**, karena Claude melihat seluruh percakapan dan berkas project. **GPT, lewat Codex CLI** di komputer yang sama, lalu menulis ulang jawaban itu supaya lebih mudah dipahami. Codex memakai login langganan ChatGPT pengguna, jadi tidak perlu `OPENAI_API_KEY`.

**Analogi.** Claude seperti peneliti yang menulis laporan. GPT seperti editor yang membuat laporan itu enak dibaca orang awam tanpa mengubah datanya. Sesudah itu peneliti membaca hasil suntingan dan menulis catatan di kertas terpisah, tanpa mencoret naskah editor.

| Skill | Yang menjawab lebih dulu | Peran GPT |
|---|---|---|
| `/ask-gpt` | Claude | Memperhalus draf Claude |
| `/ask-gpt-first` | GPT | Menjawab sendiri, sudah lengkap dengan gaya pengguna |

Bila agent yang berjalan **adalah Codex sendiri**, jangan pakai skill ini. Jawab langsung.

Aturan yang sama untuk kedua skill ada di `references/aturan-bersama.md`. **Baca berkas itu sebelum mulai.** Untuk mode visual, baca juga `references/visually.md`.

## Prasyarat

1. `codex` ada di PATH dan sudah login. Periksa dengan `codex login status`.
2. Bila belum login, berhenti dan minta pengguna menjalankan `! codex login`. Jangan beralih diam-diam ke API berbayar.

## Langkah

1. **Baca argumen.** Pisahkan penanda `:visually` dari prompt (aturan bersama bagian A).
2. **Claude menulis draf jawaban.** Jawab pertanyaan pengguna selengkap mungkin, dengan seluruh konteks percakapan dan berkas yang Claude punya. Fokus pada isi yang benar: fakta, angka, kode, path, dan sitasi. Draf ini **belum ditampilkan** ke pengguna.
3. **Susun input untuk GPT** di berkas sementara, dengan tiga bagian berurutan:
   - `PERTANYAAN PENGGUNA:` berisi kata-kata pengguna apa adanya.
   - `DRAF CLAUDE:` berisi draf dari langkah 2, utuh.
   - Bila perlu, `KONTEKS DARI CLAUDE:` dan `ATURAN GAYA PENGGUNA:`, mengikuti aturan bersama bagian B.
4. **Jalankan dengan `--polish`:**

   ```bash
   ~/.claude/skills/ask-gpt/scripts/ask.sh --polish [opsi] < /path/input.txt
   ```

   Pembuka mode `--polish` menyuruh GPT mempertahankan substansi teknis dan menambah penjelasan, analogi, serta definisi istilah. Bila GPT menilai ada yang salah di draf, ia tidak memperbaikinya diam-diam. Ia menulisnya di bagian **Catatan GPT untuk Claude**.
5. **Sajikan hasil** mengikuti aturan bersama bagian D. Jawaban GPT tampil utuh di bawah **Jawaban GPT (Codex)**. Draf Claude tidak ditampilkan, kecuali pengguna memintanya.
6. **Review Claude** di **Catatan Claude**, tanpa mengubah teks GPT. Periksa khususnya:
   - apakah ada fakta, angka, kode, atau sitasi dari draf yang berubah atau hilang saat diperhalus;
   - tanggapan Claude atas **Catatan GPT untuk Claude**, bila ada: setuju dan mengoreksi di catatan, atau tidak setuju beserta alasannya.
7. **Mode visual**, bila aktif: buat HTML dari jawaban akhir GPT, mengikuti `references/visually.md`.
8. **Simpan ID sesi.** Bila pengguna bertanya lanjutan untuk topik yang sama, Claude menulis draf baru lalu memakai `--polish --resume <id>`.
