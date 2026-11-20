# ask-gpt-skill

Skill Claude Code untuk meminta jawaban dari GPT lewat [Codex CLI](https://github.com/openai/codex) yang sudah login di komputer yang sama. Codex memakai login langganan ChatGPT, jadi tidak perlu `OPENAI_API_KEY`.

Ketik `/ask-gpt <prompt>` di Claude Code. Claude meneruskan prompt itu ke `codex exec`, lalu menampilkan jawaban Codex utuh, terpisah dari catatan Claude sendiri. Pertanyaan lanjutan bisa melanjutkan sesi Codex yang sama.

## Prasyarat

- [Claude Code](https://claude.com/claude-code).
- Codex CLI terpasang dan login (`codex login status`).

## Pasang

```bash
git clone https://github.com/wiraperdana/ask-gpt-skill.git
cd ask-gpt-skill
./install.sh
```

`install.sh` membuat symlink `~/.claude/skills/ask-gpt`. Skill ini sengaja tidak dipasang untuk Codex, karena Codex tidak perlu bertanya ke dirinya sendiri. Untuk melepas, hapus symlink itu.

## Pakai

Di Claude Code:

```
/ask-gpt Review fungsi parse_date di utils.py, apakah ada edge case yang terlewat?
```

Langsung dari terminal:

```bash
echo "Jelaskan beda RMSE dan MAE dalam dua kalimat." | skills/ask-gpt/scripts/ask.sh
echo "Beri contoh angkanya." | skills/ask-gpt/scripts/ask.sh --resume <session-id>
skills/ask-gpt/scripts/ask.sh --dry-run < prompt.txt   # lihat perintah tanpa memakai kuota
```

Opsi lain: `--cd <dir>`, `--model <m>`, `--write` (izinkan Codex mengubah berkas), `--image <file>`, `--raw`. Rinciannya ada di `skills/ask-gpt/SKILL.md`.

## Perlu diketahui

- Default sandbox Codex `read-only`: ia boleh membaca berkas di folder kerja, tetapi tidak mengubahnya.
- Prompt dan berkas yang dibaca Codex terkirim ke OpenAI. Jangan teruskan data rahasia tanpa izin.
- Setiap panggilan memakai kuota langganan ChatGPT.

## Lisensi

MIT, lihat [LICENSE](LICENSE).
