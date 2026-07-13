# Keterangan Proyek untuk Pembuatan Use Case Diagram Sewiee

## Instruksi untuk Claude AI

Saya memiliki proyek skripsi berupa aplikasi mobile penyewaan barang bayi bernama **Sewiee** untuk **Mamanike Baby Care**. Aplikasi ini dibangun menggunakan **Flutter**, **Dart**, **Firebase Authentication**, dan **Cloud Firestore**, serta menerapkan arsitektur **Model-View-ViewModel (MVVM)**.

Saya ingin dibuatkan **Use Case Diagram** yang sesuai dengan fungsionalitas sistem aplikasi Sewiee. Diagram harus menggambarkan sistem penyewaan barang, bukan sistem customer service atau aplikasi chat.

## Deskripsi Sistem

Sewiee adalah aplikasi Android yang digunakan untuk melakukan penyewaan perlengkapan dan permainan bayi. Aplikasi membantu pelanggan untuk mencari produk, melihat ketersediaan stok secara real-time, menentukan durasi sewa, melakukan pemesanan mandiri, memilih metode pengiriman, melakukan pembayaran digital, serta memantau status pesanan dan proses pengembalian barang.

Aplikasi juga menyediakan fitur operasional untuk pihak Mamanike Baby Care sebagai merchant atau admin dalam mengelola produk, stok, pesanan, pengiriman, pengembalian, kondisi barang, dan denda.

## Aktor Utama

1. **User (Penyewa)**: pelanggan yang menggunakan aplikasi untuk mencari dan menyewa barang.
2. **Merchant (Admin/Pemilik)**: pihak Mamanike Baby Care yang mengelola inventaris dan proses penyewaan.

## Fitur User (Penyewa)

- Registrasi akun
- Verifikasi OTP setelah registrasi
- Login
- Mengelola profil akun
- Mengelola alamat pengiriman
- Melihat katalog produk
- Mencari produk
- Melihat detail produk
- Memilih durasi sewa
- Melakukan checkout atau pemesanan barang
- Memilih metode pengiriman
- Memilih ekspedisi atau kurir
- Melakukan pembayaran digital
- Mengecek status pembayaran
- Melihat status dan riwayat pesanan
- Mengonfirmasi pengembalian barang

## Fitur Merchant (Admin/Pemilik)

- Registrasi merchant
- Mengelola inventaris produk
- Menambah produk
- Mengubah data produk
- Mengatur stok dan status ketersediaan produk
- Melihat pesanan masuk
- Memverifikasi atau memproses pesanan
- Menyiapkan barang pesanan
- Memperbarui status pengiriman
- Mengelola proses pengembalian barang
- Memvalidasi pengembalian barang
- Memeriksa kondisi barang yang dikembalikan
- Menentukan denda keterlambatan atau kerusakan
- Menyelesaikan transaksi penyewaan

## Alur Bisnis Utama

1. User melakukan registrasi akun dan memverifikasi nomor telepon menggunakan OTP.
2. User melakukan login ke aplikasi.
3. User melihat katalog, mencari produk, dan membuka detail produk.
4. User memilih produk serta menentukan durasi sewa.
5. User melakukan checkout dengan memilih alamat, metode pengiriman, dan ekspedisi bila diperlukan.
6. Sistem menghitung total biaya sewa, biaya pengiriman, dan deposit.
7. User melakukan pembayaran digital dan dapat mengecek status pembayaran.
8. Merchant menerima serta memverifikasi pesanan yang telah dibayar.
9. Merchant menyiapkan barang dan memperbarui status pengiriman.
10. User memantau status pesanan hingga masa sewa selesai.
11. User mengonfirmasi proses pengembalian barang.
12. Merchant memvalidasi pengembalian, memeriksa kondisi barang, dan menentukan denda apabila terdapat keterlambatan atau kerusakan.
13. Merchant menyelesaikan transaksi penyewaan.

## Ketentuan Use Case Diagram

- Gunakan dua aktor utama saja: **User (Penyewa)** dan **Merchant (Admin/Pemilik)**.
- Judul sistem pada boundary diagram: **Sewiee - Aplikasi Mobile Penyewaan Barang**.
- Gunakan nama use case dalam Bahasa Indonesia yang formal dan berupa aktivitas.
- Jangan memasukkan fitur yang tidak ada pada aplikasi, seperti Chat CS, ChatBot, History Chat, Data Pertanyaan, Halaman Chat CS, dan manajemen customer service.
- Gunakan relasi `<<include>>` hanya untuk proses yang wajib dilakukan sebagai bagian dari use case utama.
- Gunakan relasi `<<extend>>` untuk proses pilihan atau kondisi tertentu.

## Relasi yang Direkomendasikan

- `Registrasi` `<<include>>` `Verifikasi OTP`
- `Login` `<<include>>` `Validasi Kredensial`
- `Checkout` `<<include>>` `Pilih Durasi Sewa`
- `Checkout` `<<include>>` `Pilih Metode Pengiriman`
- `Checkout` `<<include>>` `Hitung Total Biaya`
- `Pembayaran Digital` `<<include>>` `Cek Status Pembayaran`
- `Validasi Pengembalian Barang` `<<include>>` `Periksa Kondisi Barang`
- `Tentukan Denda` `<<extend>>` `Validasi Pengembalian Barang`, karena hanya dilakukan jika terdapat keterlambatan atau kerusakan.
- `Cari Produk` `<<extend>>` `Lihat Katalog Produk`, karena pencarian dilakukan apabila user ingin menemukan produk tertentu.
- `Pilih Ekspedisi` `<<extend>>` `Pilih Metode Pengiriman`, karena hanya diperlukan apabila user memilih pengiriman menggunakan ekspedisi.

## Permintaan Output

Tolong buatkan:

1. Daftar aktor dan deskripsinya.
2. Daftar use case untuk User dan Merchant.
3. Relasi asosiasi antara aktor dan use case.
4. Relasi `<<include>>` dan `<<extend>>` yang tepat.
5. Narasi formal untuk menjelaskan Use Case Diagram pada BAB IV skripsi.
6. Kode PlantUML untuk menghasilkan Use Case Diagram.
