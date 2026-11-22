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

## Desain: modern, rapi, mudah dibaca

Halaman yang berantakan membuat pembaca berhenti sebelum sampai ke isinya. Karena itu desain diperlakukan sebagai bagian dari penjelasan, bukan hiasan. Ikuti sistem di bawah ini di setiap halaman.

### Tata letak

- Satu kolom konten dengan lebar maksimal sekitar 760 px untuk teks. Panjang baris paling nyaman dibaca adalah 60 sampai 75 karakter.
- Visualisasi dan tabel boleh lebih lebar, sampai sekitar 1080 px.
- Jarak memakai satu skala kelipatan 8 px, yaitu 8, 16, 24, 32, dan 48. Jarak antarbagian lebih besar daripada jarak di dalam bagian, supaya kelompok isi terlihat jelas.
- Navigasi daftar isi menempel (sticky) di atas atau samping. Di layar HP, ia berubah jadi baris yang bisa digeser.
- Grid dua kolom otomatis menjadi satu kolom di bawah sekitar 720 px.

### Warna

- Pakai token warna di `:root`, yaitu latar, permukaan kartu, teks utama, teks sekunder, garis, satu warna aksen utama, satu aksen kedua, serta warna berhasil dan gagal.
- Latar memakai netral yang lembut, bukan putih murni. Aksen dipakai hemat, hanya untuk hal yang bisa diklik dan angka kunci.
- Kontras teks minimal 4,5:1 terhadap latarnya (WCAG AA), termasuk di mode gelap. Teks sekunder tetap wajib lolos batas ini.
- Mode gelap mendefinisikan ulang semua token, jangan hanya membalik latar.

### Font

- Teks memakai system font stack: `system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif`. Angka dan kode memakai `ui-monospace, SFMono-Regular, Menlo, Consolas, monospace`. Halaman tidak bergantung pada font dari internet.
- Ukuran teks isi 17 sampai 18 px dengan line-height 1,6 sampai 1,7. Skala judul tetap, misalnya 32, 24, 20, dan 17 px. Di HP judul mengecil, isi tidak.
- Angka di tabel dan kalkulator memakai `font-variant-numeric: tabular-nums` supaya kolomnya sejajar.

### Larangan tumpang tindih dan susah dibaca

Bagian ini lahir dari kesalahan nyata. Label teks pernah ditaruh di atas bar berwarna, dan teks hitam di atas biru tua jadi sulit dibaca.

- **Jangan menaruh teks di atas isian bar, gambar, atau area berwarna** kecuali kontrasnya terjamin di kedua mode. Lebih aman taruh label di atas atau di samping bar, dan nilainya di ujung bar.
- **Jangan memakai `position: absolute` untuk teks.** Posisi absolut hanya untuk penanda grafis kecil, misalnya garis threshold.
- **Label sumbu SVG tidak boleh bertabrakan.** Bila titiknya rapat, tampilkan sebagian label saja, putar label, atau pindahkan detail ke tooltip dan tabel.
- Teks panjang, kode, dan path diberi `overflow-wrap: anywhere`. Tabel dan blok kode dibungkus kontainer dengan `overflow-x: auto`, supaya halaman tidak bergeser ke samping.
- Tombol dan slider minimal 44 px tingginya di HP, dengan label yang selalu terlihat.
- Tiap visualisasi punya judul kecil, satu kalimat "apa yang dilihat", dan keterangan warna.

### Menulis di halaman

- Aturan menulis di `aturan-bersama.md` bagian B2 berlaku di sini juga. Lebih dari tiga butir dalam satu kalimat ditulis sebagai list.
- Analogi diambil dari kejadian sehari-hari di luar bidang topik. Tampilkan pemetaannya sebagai tabel kecil "analogi lawan istilah teknis".

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

1. **Uji visual dengan headless browser.** Headless browser adalah browser tanpa jendela yang bisa dijalankan dari terminal. Pilihan default skill ini [Obscura](https://github.com/h4ckf0r0day/obscura), karena ringan (sekitar 70 MB) dan tidak butuh Chromium. Bila `obscura` belum ada di PATH, sarankan pengguna memasangnya dari halaman Releases. Tool browser lain yang sudah tersedia juga boleh dipakai.
   - **Tampilan atas, satu langkah:** `obscura fetch "file:///path/halaman.html" -s atas.png`. Hasilnya satu layar 1280 x 720 dalam mode terang. Tambahkan `--eval "<js>"` untuk memeriksa DOM, misalnya jumlah elemen.
   - **Enam screenshot penuh:** jalankan `obscura serve -p 9333 --allow-file-access` di latar belakang, lalu `node ~/.claude/skills/ask-gpt/scripts/shot.mjs halaman.html <folder-out>`. Butuh Node 22 ke atas. Skrip memotret lebar 390, 768, dan 1280 px, masing-masing dalam mode terang dan gelap. Ia juga melaporkan scroll ke samping (`scrollWidth` lebih besar dari lebar jendela). Hentikan `obscura serve` sesudahnya.
   - Lihat sendiri gambarnya. Periksa daftar larangan tumpang tindih satu per satu, terutama tombol yang teksnya patah jadi dua baris.
   - **Batas Obscura:** renderer-nya belum menggambar `input type=range` seperti browser biasa, jadi slider tampil sebagai kotak polos. Itu bukan cacat halaman. Ia juga tidak mengeksekusi klik, jadi kontrol interaktif diuji lewat `--eval` atau DOM tiruan, bukan dari gambar.
2. Bila tidak ada headless browser sama sekali, minimal jalankan pemeriksaan sintaks JavaScript (`node --check` pada skrip yang diekstrak). Laporkan bahwa uji visual belum dijalankan.
3. Laporkan path absolut berkas. Halaman ini tidak dipublikasikan ke mana pun, kecuali pengguna memintanya.
