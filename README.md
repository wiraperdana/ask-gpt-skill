# ask-gpt-skill

Skill Claude Code untuk meminta jawaban dari GPT lewat [Codex CLI](https://github.com/openai/codex) yang sudah login di komputer yang sama. Codex memakai login langganan ChatGPT, jadi tidak perlu `OPENAI_API_KEY`.

Repo ini berisi dua skill. Keduanya menghasilkan jawaban GPT yang tampil utuh, lalu review Claude di bagian terpisah tanpa mengubah teks GPT.

| Skill | Alurnya |
|---|---|
| `/ask-gpt <prompt>` | Claude menjawab lebih dulu. GPT lalu memperhalus gaya bahasa, pedagogi, dan cara berinteraksinya supaya lebih mudah dimengerti, tanpa mengubah substansi teknis. |
| `/ask-gpt-first <prompt>` | GPT menjawab lebih dulu sesuai konteks, lengkap dengan gaya pengguna. |

Tambahkan `:visually` sebagai kata pertama, misalnya `/ask-gpt :visually <prompt>`. Selain jawaban teks, skill juga membuat satu berkas HTML berisi visualisasi animasi interaktif, contoh kasus, kamus istilah, dan cek pemahaman. Berkas itu bisa dibuka dengan klik ganda, tanpa internet. Sintaks `/ask-gpt:visually` tanpa spasi tidak bisa dijadikan nama skill, karena Claude Code memakai titik dua untuk nama plugin.

Pertanyaan lanjutan bisa melanjutkan sesi Codex yang sama.

## Prasyarat

- [Claude Code](https://claude.com/claude-code).
- Codex CLI terpasang dan login (`codex login status`).

## Pasang

```bash
git clone https://github.com/wiraperdana/ask-gpt-skill.git
cd ask-gpt-skill
./install.sh
```

`install.sh` membuat symlink `~/.claude/skills/ask-gpt` dan `~/.claude/skills/ask-gpt-first`. Keduanya selalu dipasang bersama, karena `ask-gpt-first` memakai skrip dan rujukan di folder `ask-gpt`. Skill ini sengaja tidak dipasang untuk Codex, karena Codex tidak perlu bertanya ke dirinya sendiri. Untuk melepas, hapus kedua symlink itu.

## Pakai

Di Claude Code:

```
/ask-gpt Jelaskan kenapa indeks database mempercepat query.
/ask-gpt-first Review fungsi parse_date di utils.py, apakah ada edge case yang terlewat?
/ask-gpt :visually Bagaimana cara kerja gradient descent?
```

Langsung dari terminal:

```bash
echo "Jelaskan beda RMSE dan MAE dalam dua kalimat." | skills/ask-gpt/scripts/ask.sh
echo "Beri contoh angkanya." | skills/ask-gpt/scripts/ask.sh --resume <session-id>
skills/ask-gpt/scripts/ask.sh --dry-run < prompt.txt   # lihat perintah tanpa memakai kuota
```

Opsi lain: `--polish` (mode `/ask-gpt`, stdin berisi pertanyaan dan draf Claude), `--cd <dir>`, `--model <m>`, `--write` (izinkan Codex mengubah berkas), `--image <file>`, `--raw`. Rinciannya ada di `skills/ask-gpt/references/aturan-bersama.md`.

## Perlu diketahui

- Gaya dan cara berinteraksi Anda ikut terbawa. Codex membaca `AGENTS.md` di folder kerjanya, dan Claude menambahkan ringkasan aturan gaya dari berkas instruksi Claude Anda, tanpa data pribadi. Keputusan yang mestinya Anda ambil didaftar di akhir jawaban, tidak diputuskan diam-diam.
- Default sandbox Codex `read-only`: ia boleh membaca berkas di folder kerja, tetapi tidak mengubahnya.
- Prompt dan berkas yang dibaca Codex terkirim ke OpenAI. Jangan teruskan data rahasia tanpa izin.
- Setiap panggilan memakai kuota langganan ChatGPT.

## Lisensi

MIT, lihat [LICENSE](LICENSE).
