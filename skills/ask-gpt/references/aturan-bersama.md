# Aturan bersama `/ask-gpt` dan `/ask-gpt-first`

Berkas ini dibaca oleh kedua skill. Isinya aturan yang sama untuk keduanya: apa yang boleh ditambahkan Claude ke prompt, cara membawa aturan gaya pengguna, dan cara menyajikan hasil. Ubah di sini, jangan di masing-masing `SKILL.md`, supaya kedua skill tidak menyimpang.

## A. Membaca argumen dan mode visual

Argumen skill adalah teks sesudah nama skill.

- Bila kata pertama argumen adalah `:visually` atau `visually`, mode visual aktif. Buang kata itu, sisanya adalah prompt.
- Sintaks `/ask-gpt:visually` tidak bisa dijadikan nama skill, karena Claude Code memakai titik dua untuk nama plugin. Bila pengguna mengetiknya dan Claude Code tetap meneruskannya ke skill ini, perlakukan sama dengan `:visually`.
- Bila prompt kosong, tanyakan ke pengguna apa yang ingin ditanyakan.

## B. Yang boleh ditambahkan Claude ke prompt

1. **Teruskan kata-kata pengguna apa adanya.** Jangan diringkas, diterjemahkan, atau diubah maknanya.
2. **`KONTEKS DARI CLAUDE:` hanya berisi fakta.** Codex tidak melihat percakapan Claude. Bila prompt merujuk konteks percakapan ("kode tadi", "berkas ini"), tambahkan di bawah prompt asli hal yang tidak bisa Codex ketahui sendiri: path berkas, definisi istilah, angka, dan apa yang sudah terjadi di percakapan. Tujuan, kriteria mutu, dan cara kerja tetap memakai kata-kata pengguna. Claude tidak menambahkan batas panjang, format keluaran, daftar larangan, langkah kerja, atau target mutu yang tidak diminta pengguna.
   - **Kesalahan nyata yang mendasari aturan ini (22 November 2026).** Pengguna meminta "perbaiki bahasa supaya mudah dipahami orang awam, tanpa mengurangi poin teknis". Claude menambahkan "panjang teks baru paling banyak 1,4 kali teks lama", supaya teks muat di sel. Codex mematuhi batas itu, sehingga tidak ada ruang untuk menjelaskan istilah, dan hasilnya tetap sulit dipahami. Akibatnya Codex bekerja untuk aturan karangan Claude, padahal tugasnya menjawab pengguna.
   - **Batasan teknis yang benar-benar wajib** boleh ditulis sebagai fakta beserta alasannya. Contohnya: "berkas xlsx jangan disimpan ulang, karena checkbox-nya akan rusak". Bila batasan itu berisiko menurunkan mutu jawaban, tanyakan dulu ke pengguna. Jangan memasangnya diam-diam.
   - **Untuk tugas besar,** Claude boleh menyiapkan bahan, misalnya mengekstrak teks ke berkas JSON. Itu bantuan logistik. Jangan sampai ia berubah menjadi pengganti permintaan pengguna.
3. **Bawa aturan gaya pengguna.** Codex otomatis membaca `AGENTS.md` di folder kerjanya, tetapi tidak membaca berkas instruksi Claude seperti `~/.claude/CLAUDE.md`. Folder kerja lain lewat `--cd` juga bisa tidak punya `AGENTS.md` yang sama. Karena itu, bila berkas instruksi yang dimuat Claude berisi aturan gaya atau interaksi, ringkas aturan itu ke blok `ATURAN GAYA PENGGUNA:` di bawah prompt. Contohnya bahasa, larangan tanda baca tertentu, kedalaman penjelasan, dan format keputusan. Pembuka standar `ask.sh` menyuruh Codex mematuhi blok ini.
   - Isinya **hanya aturan yang benar-benar tertulis** di berkas instruksi pengguna, diringkas tanpa ditambah. Aturan karangan Claude tidak masuk blok ini. Paling banyak sekitar 15 butir pendek. Jangan sertakan nama, profil, kredensial, data klien, isi project, atau detail pribadi lain, karena prompt terkirim ke OpenAI.
   - Bila tidak ada aturan gaya, lewati blok ini.
4. **Laporkan setiap tambahan.** Di balasannya, Claude menyebut singkat semua yang ia tambahkan di luar kata-kata pengguna, yaitu konteks, aturan gaya, dan batasan teknis. Dengan begitu pengguna bisa menilai apakah tambahan itu ikut membentuk jawaban Codex.

## B2. Aturan menulis yang selalu berlaku

Aturan ini berlaku untuk draf Claude, jawaban GPT, Catatan Claude, dan HTML mode visual. Pembuka standar `ask.sh` sudah memuatnya untuk GPT.

1. **Lebih dari tiga butir dalam satu kalimat ditulis sebagai list.** Kalimat seperti "langkahnya parsing, encoding, scaling, dan imputasi" dipecah jadi daftar berbutir. Alasannya, mata pembaca bisa menghitung dan menandai butir satu per satu.
2. **Analogi diambil dari kejadian sehari-hari yang paling umum dialami orang awam.** Contohnya memasak, belanja, antre, naik kendaraan umum, atau sekolah. Analogi harus lebih sederhana dari topiknya dan berasal dari luar bidang topik itu.
   - Topik keamanan siber tidak dianalogikan dengan "petugas keamanan". Itu masih bidang yang sama, jadi pembaca awam tidak mendapat pegangan baru.
   - Sesudah analogi, petakan setiap unsurnya kembali ke istilah teknis. Contoh: "resep = pipeline, bahan = feature, mencicipi = validasi".
3. **Judul, label, dan kalimat ditulis seperti ucapan manusia, dengan subjek dan kata kerja.** Hindari pola khas AI: frasa benda, lalu koma atau titik dua, lalu potongan keterangan.
   - "Alur 8 langkah, mengikuti satu laporan" menjadi "Satu laporan melewati 8 langkah".
   - "Recency weight: data baru lebih didengar" menjadi "Data baru diberi bobot lebih besar".
   - Ujinya: apakah kalimat itu wajar diucapkan saat ngobrol? Kalau tidak, tulis ulang. Alasannya, pola terpotong itu memaksa pembaca menyusun sendiri hubungan antarbagian, dan langsung terasa sebagai tulisan mesin.

## C. Menjalankan `ask.sh`

Tulis prompt ke berkas sementara, lalu kirim lewat stdin:

```bash
~/.claude/skills/ask-gpt/scripts/ask.sh [opsi] < /path/prompt.txt
```

Pakai heredoc berpetik (`<<'EOF'`) bila menulis prompt langsung di shell, supaya `$` dan backtick tidak diproses. Codex bisa butuh 30 detik sampai beberapa menit, jadi beri timeout Bash yang longgar (misalnya 600000 ms). Folder kerja default adalah folder saat ini, supaya Codex bisa membaca berkas project. Pakai `--cd <dir>` bila pertanyaannya tentang folder lain.

| Opsi | Fungsi |
|---|---|
| `--polish` | Mode `/ask-gpt`: stdin berisi pertanyaan pengguna dan draf Claude, Codex menulis ulang draf itu. Tanpa opsi ini, Codex menjawab sendiri (mode `/ask-gpt-first`). |
| `--cd <dir>` | Folder kerja Codex. Default folder saat ini. |
| `--model <m>` | Pilih model Codex. Default mengikuti `~/.codex/config.toml`. |
| `--write` | Izinkan Codex mengubah berkas di folder kerja (sandbox `workspace-write`). Default `read-only`. Pakai **hanya** bila pengguna meminta Codex mengubah berkas. |
| `--resume <id\|last>` | Lanjutkan sesi Codex sebelumnya. |
| `--image <file>` | Lampirkan gambar. Boleh berulang. |
| `--raw` | Kirim prompt tanpa pembuka standar. Pembuka standar memberi tahu Codex perannya, menyuruhnya mematuhi aturan gaya pengguna, dan memintanya mendaftar keputusan terbuka alih-alih berasumsi diam-diam. Tanpa pembuka, semua itu hilang. |
| `--dry-run` | Cetak perintah dan prompt tanpa memanggil Codex. |

Skrip mencetak ID sesi Codex ke stderr. Bila pengguna bertanya lanjutan untuk topik yang sama, pakai `--resume <id>` supaya Codex ingat percakapan sebelumnya.

## D. Menyajikan hasil

1. Tampilkan jawaban Codex di bawah judul **Jawaban GPT (Codex)**, utuh dan tanpa disunting.
2. Catatan Claude ditulis terpisah di bawah judul **Catatan Claude**. Jangan mencampur keduanya.
   - Teks Claude sendiri, termasuk **Catatan Claude**, tetap mengikuti seluruh aturan gaya pengguna.
   - **Catatan Claude dibuat ringkas.** Isinya hanya koreksi fakta, hal yang tidak diketahui Codex, atau risiko nyata. Jangan menulis ulang jawaban Codex, menimpa kesimpulannya, atau menumpuk saran tambahan yang tidak diminta. Bila tidak ada yang perlu dikoreksi, lewati bagian ini.
   - Bila jawaban Codex melanggar aturan gaya pengguna, jangan menyuntingnya. Sebut pelanggarannya singkat di **Catatan Claude**, supaya pengguna tahu teks itu bukan hasil aturannya.
3. Bila Codex menulis bagian **Keputusan untuk pengguna**, bawa keputusan itu ke format keputusan pengguna di bagian akhir balasan Claude, misalnya ID keputusan bila pengguna memakainya. Jangan memutuskannya atas nama pengguna. Bila Codex sudah memberi ID sendiri, abaikan ID itu dan beri ID dari penomoran sesi Claude, karena Codex tidak tahu ID mana yang sudah terpakai.
4. Bila mode visual aktif, sebut path berkas HTML-nya di akhir, sesudah **Catatan Claude**. Lihat `references/visually.md`.

## E. Batasan yang wajib disampaikan bila relevan

- Prompt dan berkas yang dibaca Codex terkirim ke OpenAI. Jangan teruskan data rahasia, kredensial, atau data berlisensi tanpa izin pengguna.
- Setiap panggilan memakai kuota langganan ChatGPT pengguna.
- Codex tidak melihat percakapan Claude, kecuali yang ditulis di prompt.
- Jawaban Codex bisa keliru, sama seperti jawaban Claude. Skill ini memberi pendapat kedua, bukan kebenaran akhir.
