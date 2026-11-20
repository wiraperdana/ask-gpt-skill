---
name: ask-gpt
description: Minta jawaban atau second opinion dari GPT lewat Codex CLI yang sudah login di komputer yang sama, tanpa API key. Khusus Claude Code. Pakai saat pengguna mengetik "/ask-gpt <prompt>", atau meminta "tanya GPT", "tanya Codex", "minta pendapat GPT", "bandingkan dengan jawaban GPT". Claude meneruskan prompt yang dibawa saat skill dipanggil ke `codex exec`, lalu menyajikan jawaban Codex apa adanya, dipisahkan jelas dari pendapat Claude sendiri.
---

# ask-gpt

Skill ini membuat Claude Code bisa **bertanya ke Codex**, agent milik OpenAI, yang terpasang di komputer yang sama. Codex memakai login langganan ChatGPT pengguna, jadi tidak perlu `OPENAI_API_KEY`.

**Analogi.** Claude seperti dokter yang meminta konsultasi ke dokter spesialis lain di gedung yang sama. Claude mengirim surat rujukan (prompt). Spesialis memeriksa dan menulis jawabannya. Claude lalu menyerahkan jawaban itu ke pasien apa adanya, dan boleh menambahkan catatannya sendiri secara terpisah.

## Kapan dipakai

- Pengguna mengetik `/ask-gpt <prompt>`. Teks setelah nama skill adalah prompt yang diteruskan.
- Pengguna meminta jawaban, review, atau second opinion dari GPT atau Codex.

Bila agent yang berjalan **adalah Codex sendiri**, jangan pakai skill ini. Jawab langsung.

## Prasyarat

1. `codex` ada di PATH dan sudah login. Periksa dengan `codex login status`.
2. Bila belum login, berhenti dan minta pengguna menjalankan `! codex login`. Jangan beralih diam-diam ke API berbayar.

## Langkah

1. **Ambil prompt.** Prompt adalah argumen yang dibawa saat skill dipanggil. Teruskan **sebagai adanya**: jangan diringkas, diterjemahkan, atau diubah maknanya.
   - Bila argumennya kosong, tanyakan ke pengguna apa yang ingin ditanyakan.
   - Bila prompt merujuk konteks percakapan ("kode tadi", "berkas ini"), Codex tidak melihat percakapan Claude. Tambahkan konteks yang dibutuhkan di bawah prompt asli dengan judul `KONTEKS DARI CLAUDE:`, misalnya path berkas atau potongan kode. Sebut ke pengguna bahwa konteks itu ditambahkan.
2. **Tentukan folder kerja.** Default folder kerja saat ini, supaya Codex bisa membaca berkas project. Pakai `--cd <dir>` bila pertanyaannya tentang folder lain.
3. **Jalankan.** Tulis prompt ke berkas sementara, lalu kirim lewat stdin:

   ```bash
   ~/.claude/skills/ask-gpt/scripts/ask.sh [opsi] < /path/prompt.txt
   ```

   Pakai heredoc berpetik (`<<'EOF'`) bila menulis prompt langsung di shell, supaya `$` dan backtick tidak diproses. Codex bisa butuh 30 detik sampai beberapa menit, jadi beri timeout Bash yang longgar (misalnya 600000 ms).
4. **Sajikan jawaban.** Tampilkan jawaban Codex di bawah judul **Jawaban GPT (Codex)**, utuh dan tanpa disunting. Bila Claude punya catatan, misalnya setuju, tidak setuju, atau menemukan kekeliruan, tulis terpisah di bawah judul **Catatan Claude**. Jangan mencampur keduanya.
5. **Simpan ID sesi.** Skrip mencetak ID sesi Codex ke stderr. Bila pengguna bertanya lanjutan untuk topik yang sama, pakai `--resume <id>` supaya Codex ingat percakapan sebelumnya.

## Opsi `ask.sh`

| Opsi | Fungsi |
|---|---|
| `--cd <dir>` | Folder kerja Codex. Default folder saat ini. |
| `--model <m>` | Pilih model Codex. Default mengikuti `~/.codex/config.toml`. |
| `--write` | Izinkan Codex mengubah berkas di folder kerja (sandbox `workspace-write`). Default `read-only`. Pakai **hanya** bila pengguna meminta Codex mengubah berkas. |
| `--resume <id\|last>` | Lanjutkan sesi Codex sebelumnya. |
| `--image <file>` | Lampirkan gambar. Boleh berulang. |
| `--raw` | Kirim prompt tanpa pembuka standar. Pembuka standar memberi tahu Codex bahwa ia sedang dimintai second opinion. |
| `--dry-run` | Cetak perintah dan prompt tanpa memanggil Codex. |

## Batasan yang wajib disampaikan bila relevan

- Prompt dan berkas yang dibaca Codex terkirim ke OpenAI. Jangan teruskan data rahasia, kredensial, atau data berlisensi tanpa izin pengguna.
- Setiap panggilan memakai kuota langganan ChatGPT pengguna.
- Codex tidak melihat percakapan Claude, kecuali yang ditulis di prompt.
- Jawaban Codex bisa keliru, sama seperti jawaban Claude. Skill ini memberi pendapat kedua, bukan kebenaran akhir.
