# Mode visual (`:visually`)

Mode ini aktif bila kata pertama argumen `/ask-gpt` atau `/ask-gpt-first` adalah `:visually` atau `visually`. Selain jawaban teks, skill menghasilkan **satu berkas HTML** yang menjelaskan isi jawaban dengan visualisasi animasi interaktif dan contoh kasus. Targetnya: siapa pun yang membacanya bisa mengerti, termasuk orang yang baru pertama kali bertemu topik itu.

**Analogi.** Jawaban teks seperti resep tertulis. HTML ini seperti video masak yang bisa dijeda, diulang, dan bahannya bisa Anda ganti sendiri untuk melihat apa yang berubah.

## Siapa yang membuat, dan sumbernya

- **Claude membangun HTML-nya**, sesudah jawaban akhir GPT keluar. Claude bisa menjalankan dan menguji halaman itu di mesin ini.
- **Sumber isinya jawaban akhir GPT**, yaitu draf yang sudah diperhalus (`/ask-gpt`) atau jawaban GPT (`/ask-gpt-first`). Pakai istilah, analogi, contoh, dan urutan penjelasan yang sama. Jangan menambah klaim fakta baru. Bila sebuah visualisasi butuh angka contoh yang tidak ada di jawaban, beri label jelas "angka ilustrasi".
- Koreksi fakta dari **Catatan Claude** tidak diam-diam dimasukkan ke HTML. Bila koreksi itu penting, tampilkan sebagai kotak "Catatan Claude" yang terpisah di halaman.

## Isi wajib halaman

1. **Inti dalam satu paragraf** di bagian paling atas, yaitu kesimpulan jawaban.
2. **Minimal satu visualisasi interaktif** untuk mekanisme utama, bukan sekadar hiasan. Pembaca bisa mengubah sesuatu, misalnya lewat slider, tombol langkah, atau pilihan, lalu melihat akibatnya bergerak. Animasinya menunjukkan sebab dan akibat, langkah demi langkah.
3. **Contoh kasus** yang dekat dengan kehidupan sehari-hari, dikerjakan lengkap dari awal sampai hasil. Bila ada hitungan, tampilkan setiap langkah dengan angkanya.
4. **Kamus istilah**: setiap istilah teknis di halaman, didefinisikan dengan bahasa sederhana.
5. **Cek pemahaman** pendek (2 sampai 4 soal) dengan umpan balik langsung saat dijawab.
6. Bila jawaban memuat keputusan untuk pengguna, tampilkan opsinya apa adanya. Halaman tidak memilihkan.

## Aturan teknis

- **Satu berkas mandiri** yang bisa dibuka dengan klik ganda (`file://`), tanpa server dan tanpa koneksi internet. CSS dan JavaScript ditulis inline. Rumus ditulis dengan HTML, SVG, atau MathML, bukan pustaka dari CDN.
- **Tampilan terang secara default**, dengan tombol untuk mode gelap. Ikuti aturan pengguna bila ia menetapkan lain.
- **Rapi di layar HP** (lebar sekitar 360 px), tanpa scroll ke samping.
- **Aksesibel:** semua kontrol bisa dipakai dengan keyboard, warna bukan satu-satunya pembawa makna, dan animasi menghormati `prefers-reduced-motion`.
- Bahasa dan gaya halaman mengikuti aturan gaya pengguna, sama seperti jawaban teks.

## Lokasi berkas

- Ikuti konvensi lokasi deliverable dari berkas instruksi pengguna bila ada, misalnya folder `_output/` milik project.
- Bila tidak ada konvensi, simpan di `./ask-gpt-output/` di folder kerja.
- Nama berkas: `<slug-topik>.html` dalam huruf kecil dan tanda hubung. Bila berkas dengan nama sama sudah ada, jangan ditimpa. Tambahkan tanggal `-YYYYMMDD`.

## Uji sebelum melapor

1. Buka halaman di browser lokal bila tersedia, misalnya lewat tool browser atau headless Chrome. Periksa bahwa tidak ada error di console dan setiap kontrol interaktif benar-benar mengubah tampilan.
2. Bila browser tidak tersedia, minimal jalankan pemeriksaan sintaks JavaScript (`node --check` pada skrip yang diekstrak). Laporkan bahwa uji visual belum dijalankan.
3. Laporkan path absolut berkas. Halaman ini tidak dipublikasikan ke mana pun, kecuali pengguna memintanya.
