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
7. **Penjelasan lengkap yang bisa dibuka.** Teks utama tetap ringkas. Setiap kalimat atau butir yang memuat istilah teknis, nama kolom, angka yang perlu ditafsirkan, atau peringatan diberi blok `<details>` yang tertutup secara default. `<details>` adalah elemen HTML bawaan yang bisa dibuka dan ditutup tanpa JavaScript.
   - **Letaknya tepat di bawah kalimat atau butir yang dijabarkan**, bukan dikumpulkan di akhir bagian. Satu blok untuk satu hal.
   - **Judulnya berupa pertanyaan yang menyebut halnya**, misalnya "Apa itu OOF dan KFold 5?" atau "Kenapa KFold acak ini kelemahan?". Judul umum seperti "Penjelasan lengkap" tidak dipakai.
   - **Isinya mengikuti pola tetap:** apa itu, analoginya dari analogi utama halaman, pemetaan unsur analogi ke istilah, kenapa penting, dan status kepastian. Yang belum diverifikasi di kode atau data diberi tanda "perlu dicek". Peringatan ditulis eksplisit bersama akibatnya. Angka karangan diberi label "angka contoh".
   - Blok ditutup dengan satu **kalimat sederhana untuk demo** yang bisa langsung dibacakan.
   - Kalimat yang sudah jelas tidak diberi blok.
   - Tampilan: judul blok jelas terlihat bisa diklik, misalnya diawali tanda panah, setinggi minimal 44 px, dan bisa dibuka dengan keyboard. Blok yang dibuka mendorong isi di bawahnya, tidak menutupinya. Bila halaman punya autoplay, membuka blok menghentikan autoplay.

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
- **Satu analogi utama untuk seluruh halaman**, termasuk isi blok `<details>`. Konsep berikutnya dijelaskan sebagai bagian lain dari dunia analogi yang sama (aturan bersama B2 nomor 4).

## Diagram dengan notasi standar

Selain visualisasi interaktif, setiap mekanisme yang punya bentuk baku dijelaskan dengan **diagram bernotasi standar**. Notasi standar dipilih karena banyak orang sudah pernah melihatnya, dan sumber belajarnya tersedia di mana-mana.

### Memilih notasi dari bentuk pertanyaan

| Yang dijelaskan | Notasi |
|---|---|
| Urutan langkah dengan cabang keputusan | Flowchart (ISO 5807) atau UML Activity Diagram |
| Proses kerja lintas peran atau bagian | BPMN 2.0 dengan swimlane |
| Pesan bolak-balik antarpihak, berurutan waktu | UML Sequence Diagram |
| Perpindahan data antarproses dan penyimpanan | DFD (Data Flow Diagram) |
| Status yang berubah karena kejadian | UML State Machine |
| Struktur data dan hubungan antartabel | ERD, notasi crow's foot |
| Struktur kelas atau komponen | UML Class atau Component Diagram, atau C4 model |
| Jadwal dan tahapan waktu | Gantt chart |
| Sebab dan akibat | Causal loop diagram atau DAG |
| Angka dan kinerja | Bentuk grafik baku, misalnya confusion matrix, kurva ROC, atau line chart |

Diagram manual hanya dibuat bila tidak ada notasi standar yang cocok, misalnya pembagian KFold. Caption-nya menyebut terus terang "diagram manual".

### Alat, menurut urutan prioritas

1. **Library yang di-embed di dalam HTML.** Kode library ditulis inline di tag `<script>`, jadi halaman tetap satu berkas dan bisa dibuka offline.
   - **Mermaid** untuk flowchart, sequence, state, ERD, class, dan Gantt. Ukurannya sekitar 5,5 MB (`mermaid.min.js`).
   - **bpmn-js** (viewer, sekitar 190 KB) untuk BPMN 2.0. Diagramnya ditulis sebagai XML BPMN inline.
   - **PlantUML** untuk diagram UML yang tidak didukung Mermaid. PlantUML dijalankan saat halaman dibuat (butuh Java dan `plantuml.jar`), lalu hasilnya ditempel sebagai SVG statis. Karena hanya SVG yang ikut, halaman tidak membawa library tambahan.
   - Ambil library dari npm dengan versi persis, misalnya `npm pack mermaid@<versi>`, lalu simpan di `~/.cache/ask-gpt/lib/` supaya bisa dipakai ulang. Catat nama dan versinya di komentar HTML.
2. **Berkas terpisah**, hanya bila cara pertama tidak mungkin. Misalnya library tidak bisa berjalan inline, atau ukuran berkas melewati batas yang diminta pengguna. Taruh library di folder `<nama-halaman>_assets/` di samping HTML dengan path relatif, lalu sebutkan di laporan bahwa folder itu wajib ikut disalin.
3. **SVG manual**, untuk diagram tanpa notasi standar.

### Aturan setiap diagram

- **Wajib ada legenda.** Legenda menjelaskan setiap simbol yang dipakai dengan bahasa sehari-hari, misalnya "belah ketupat = titik keputusan" atau "panah putus-putus = pesan balasan". Tidak ada pengecualian, termasuk untuk diagram manual dan grafik.
- **Caption menyebut notasinya**, misalnya "Notasi: UML Sequence Diagram".
- Letaknya tepat di dekat teks yang dijelaskannya. Satu diagram untuk satu pertanyaan, dengan paling banyak sekitar 12 simpul. Diagram yang lebih besar dipecah.
- Pakai sebagian kecil simbol dari notasi itu saja, dan setiap simbol yang dipakai harus sesuai arti resminya.
- Label memakai istilah teknis yang sama dengan teks. Tombol "versi analogi" boleh ditambahkan untuk mengganti label ke analogi utama halaman.
- Warna diagram mengikuti token warna halaman. Atur tema library, misalnya `mermaid.initialize({theme:'base', themeVariables:{...}})`, dan render ulang saat pengguna mengganti mode terang atau gelap.
- Sertakan teks alternatif, misalnya `aria-label` atau ringkasan teks di bawah diagram.

### Catatan praktis Mermaid (dari uji 22 November 2026)

- Simpan sumber diagram di atribut `data-src`, lalu render dengan `mermaid.render()` setelah `mermaid.initialize({startOnLoad:false, theme:'base', themeVariables:{...}})`. Ambil warna dari token CSS halaman lewat `getComputedStyle`.
- Pasang `MutationObserver` pada atribut `data-theme` supaya diagram dirender ulang saat mode terang atau gelap diganti.
- Bila render gagal, tampilkan sumber diagram sebagai teks. Halaman tidak boleh kosong diam-diam.
- Hindari label yang diawali angka dan titik, misalnya `1. Kumpulkan`, karena Mermaid bisa membacanya sebagai list Markdown. Tulis `Langkah 1<br/>Kumpulkan`.
- Label yang memuat tanda kurung atau titik dua diberi tanda kutip, misalnya `C -->|"P(a=1)"| R`.
- Simbol legenda digambar dengan CSS kecil yang meniru bentuk aslinya, misalnya kapsul, persegi, jajaran genjang, atau silinder. Legenda tetap terbaca walau diagramnya gagal tampil.

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
   - **Blok tertutup dan terbuka:** jalankan skrip dua kali, sekali biasa dan sekali dengan `--open-details`. Blok yang terbuka tetap wajib lolos cek tumpang tindih dan scroll ke samping.
   - **Bagian tertentu:** `--clip "<selector>"` memotret satu elemen saja, dan `--eval "<js>"` menjalankan perintah sebelum dipotret, misalnya mengeklik tombol langkah ke-4 di stepper.
   - **Batas Obscura untuk diagram dari library:** Obscura belum bisa mengukur teks di dalam SVG. Akibatnya Mermaid dan bpmn-js tetap jalan dan membuat SVG, tetapi diagramnya menciut jadi 16 x 16 px dan tidak terlihat di screenshot (diuji 22 November 2026). Untuk diagram seperti ini, uji lewat `--eval`: pastikan elemen `svg` terbentuk dan tidak ada error. Lalu minta pengguna memeriksa tampilannya di browser biasa, dan laporkan bahwa diagram belum diperiksa secara visual. SVG statis dari PlantUML dan SVG manual tetap tampil normal di Obscura.
   - Lihat sendiri gambarnya. Periksa daftar larangan tumpang tindih satu per satu, terutama tombol yang teksnya patah jadi dua baris.
   - **Batas Obscura:** renderer-nya belum menggambar `input type=range` seperti browser biasa, jadi slider tampil sebagai kotak polos. Itu bukan cacat halaman. Ia juga tidak mengeksekusi klik, jadi kontrol interaktif diuji lewat `--eval` atau DOM tiruan, bukan dari gambar.
2. Bila tidak ada headless browser sama sekali, minimal jalankan pemeriksaan sintaks JavaScript (`node --check` pada skrip yang diekstrak). Laporkan bahwa uji visual belum dijalankan.
3. Laporkan path absolut berkas. Halaman ini tidak dipublikasikan ke mana pun, kecuali pengguna memintanya.
