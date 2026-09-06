# Sewiee 🛒

**Sewiee** adalah aplikasi *mobile* berbasis Flutter untuk penyewaan barang secara *online*. Aplikasi ini menghubungkan penyewa (*renter*) dengan pemilik barang (*merchant/store*) untuk kemudahan transaksi sewa produk, sistem pembayaran terintegrasi, kalkulasi ongkir, hingga manajemen pesanan.

---

## 🚀 Fitur Utama

- **Otentikasi & Profil User**: Registrasi, Login, Verifikasi OTP, Pengaturan Alamat.
- **Katalog & Jelajah Produk**: Pencarian barang, filter kategori, detail barang sewa.
- **Manajemen Merchant**: Registrasi toko, kelola produk sewa, manajemen merchant.
- **Transaksi & Pembayaran**: Integrasi Midtrans Payment Gateway (Snap Token).
- **Pengiriman**: Kalkulasi tarif ekpedisi/ongkir.
- **Peta & Lokasi**: Integrasi Google Maps API & Places Autocomplete.
- **Notifikasi**: Push notification via Firebase Cloud Messaging (FCM).

---

## 🛠 Tech Stack & Dependencies

- **Framework**: Flutter (Dart SDK `>=3.9.2`)
- **State Management**: `provider` + `get_it` (Service Locator)
- **Backend / BaaS**: Firebase (Auth, Firestore, Cloud Storage, Messaging, Cloud Functions)
- **Payment Gateway**: Midtrans SDK / API
- **Location & Maps**: `google_maps_flutter`, `geolocator`, `geocoding`, `google_places_sdk_flutter`
- **Networking**: `http`, `flutter_dotenv`

---

## 📂 Struktur Proyek (Clean Architecture / MVVM)

```text
lib/
├── app/                  # Theme & konfigurasi global
├── data/                 # Data Layer
│   ├── model/            # Data models (User, Product, Order, Payment, dll)
│   └── services/         # Services (Firebase, Payment, Address, dll)
├── domain/               # Domain Layer
│   ├── enum/             # Enums
│   └── repositories/     # Repository interfaces & implementations
└── presentation/         # UI Layer (MVVM)
    ├── account/          # Skrin & ViewModel Akun & Alamat
    ├── add/              # Tambah produk sewa
    ├── explore/          # Pencarian & Katalog
    ├── home/             # Beranda
    ├── login/ & register/# Otentikasi
    ├── merchant/         # Kelola toko & merchant
    ├── order/            # Checkout & Riwayat Pesanan
    ├── products/         # Detail produk
    └── widget/           # Reusable widgets
```

---

## ⚙️ Cara Memulai (Getting Started)

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.29+ / SDK ^3.9.2)
- Android Studio / VS Code + Flutter Extension
- Java Development Kit (JDK) 17+

### 1. Clone Repository

```bash
git clone https://github.com/username/sewiee.git
cd sewiee
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi Environment (`.env`)

Salin file `.env.example` menjadi `.env` di root folder:

```bash
cp .env.example .env
```

Isi variabel lingkungan sesuai API Key milik Anda:

```env
SEND_OTP_API=https://your-send-otp-api-url.com
VERIFY_OTP_API=https://your-verify-otp-api-url.com
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
ONGKIR_API_KEY=your_ongkir_api_key
MIDTRANS_CLIENT_API_KEY=your_midtrans_client_key
MIDTRANS_SERVER_API_KEY=your_midtrans_server_key
```

### 4. Konfigurasi Firebase

- Tambahkan `google-services.json` ke folder `android/app/`.
- Jalankan `flutterfire configure` untuk men-generate `lib/firebase_options.dart`.

### 5. Jalankan Aplikasi

```bash
flutter run
```

---

## 🧪 Testing

Jalankan unit test & integration test:

```bash
# Unit test
flutter test

# Integration test
flutter test integration_test/login_test.dart
```

---

## 📝 Lisensi

Project ini dibuat untuk kebutuhan internal / privat (`publish_to: 'none'`).
