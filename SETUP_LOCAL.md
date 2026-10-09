# Setup Lokal - Secure API Keys

Projekt ini menggunakan API keys yang **tidak disimpan dalam repository**. Ikuti langkah berikut untuk development lokal:

## 1. Buat `.env` di root folder

```bash
cp .env.example .env
```

Isi dengan API keys Anda yang valid:

```env
SEND_OTP_API=<your-send-otp-api>
VERIFY_OTP_API=<your-verify-otp-api>
GOOGLE_MAPS_API_KEY=<your-google-maps-key>
ONGKIR_API_KEY=<your-ongkir-api-key>
MIDTRANS_CLIENT_API_KEY=<your-midtrans-client-key>
MIDTRANS_SERVER_API_KEY=<your-midtrans-server-key>
```

**PENTING:** File `.env` sudah di-gitignore dan tidak akan ter-commit.

## 2. Konfigurasi Android

File [android/app/build.gradle.kts](./android/app/build.gradle.kts) secara otomatis membaca `GOOGLE_MAPS_API_KEY` dari `.env` dan memasukkan ke `AndroidManifest.xml` saat build.

Tidak perlu setup tambahan—cukup build seperti biasa:

```bash
flutter run
# atau
flutter build apk
flutter build appbundle
```

## 3. Firebase Setup

```bash
flutterfire configure --project=<your-firebase-project>
```

File `google-services.json` akan generate dan sudah di-gitignore.

## ⚠️ Keamanan

- **Jangan commit `.env`** — sudah di-gitignore
- Jika keys ter-expose, **regenerate immediately** dari console masing-masing service
- Gunakan API key restrictions di console (App restrictions, API restrictions)
- Untuk Android: restrict ke Android app only + package name + signing cert

---

Untuk CI/CD (GitHub Actions, Firebase Hosting, dll), gunakan GitHub Secrets untuk menyimpan API keys.
