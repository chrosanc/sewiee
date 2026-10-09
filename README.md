# Sewiee 🛒

**Sewiee** is a Flutter mobile app for online item rental. It connects renters with item owners (merchants/stores) and covers rental transactions, integrated payments, shipping cost calculation, and order management.

---

## 🚀 Features

- **Authentication & Profile**: Registration, login, OTP verification, address management.
- **Catalog & Discovery**: Item search, category filters, rental item details.
- **Merchant Management**: Store registration, rental product management.
- **Transactions & Payments**: Midtrans Payment Gateway integration (Snap Token).
- **Shipping**: Courier shipping rate calculation.
- **Maps & Location**: Google Maps API and Places Autocomplete.
- **Notifications**: Push notifications via Firebase Cloud Messaging (FCM).

---

## 🛠 Tech Stack & Dependencies

- **Framework**: Flutter (Dart SDK `>=3.9.2`)
- **State Management**: `provider` + `get_it` (service locator)
- **Backend / BaaS**: Firebase (Auth, Firestore, Cloud Storage, Messaging, Cloud Functions)
- **Payment Gateway**: Midtrans SDK / API
- **Location & Maps**: `google_maps_flutter`, `geolocator`, `geocoding`, `google_places_sdk_flutter`
- **Networking**: `http`, `flutter_dotenv`

---

## 📂 Project Structure (Clean Architecture / MVVM)

```text
lib/
├── app/                  # Theme & global configuration
├── data/                 # Data layer
│   ├── model/            # Data models (User, Product, Order, Payment, etc.)
│   └── services/         # Services (Firebase, Payment, Address, etc.)
├── domain/               # Domain layer
│   ├── enum/             # Enums
│   └── repositories/     # Repository interfaces & implementations
└── presentation/         # UI layer (MVVM)
    ├── account/          # Account & address screens and view models
    ├── add/              # Add rental product
    ├── explore/          # Search & catalog
    ├── home/             # Home
    ├── login/ & register/# Authentication
    ├── merchant/         # Store & merchant management
    ├── order/            # Checkout & order history
    ├── products/         # Product detail
    └── widget/           # Reusable widgets
```

---

## ⚙️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.29+ / Dart SDK ^3.9.2)
- Android Studio or VS Code with the Flutter extension
- Java Development Kit (JDK) 17+

### 1. Clone the Repository

```bash
git clone https://github.com/chrosanc/sewiee.git
cd sewiee
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment (`.env`)

Copy `.env.example` to `.env` in the project root:

```bash
cp .env.example .env
```

Fill in the variables with your own API keys:

```env
SEND_OTP_API=https://your-send-otp-api-url.com
VERIFY_OTP_API=https://your-verify-otp-api-url.com
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
ONGKIR_API_KEY=your_ongkir_api_key
MIDTRANS_CLIENT_API_KEY=your_midtrans_client_key
MIDTRANS_SERVER_API_KEY=your_midtrans_server_key
```

`.env` is gitignored. On Android, the Gradle build reads `GOOGLE_MAPS_API_KEY` from it and injects it into the manifest.

### 4. Configure Firebase

- Add `google-services.json` to `android/app/`.
- Run `flutterfire configure` to generate `lib/firebase_options.dart`.

### 5. Run the App

```bash
flutter run
```

---

## 🧪 Testing

Run unit and integration tests:

```bash
# Unit tests
flutter test

# Integration test
flutter test integration_test/login_test.dart
```

---

## 📝 License

Portfolio project. The code is public for reference only; all rights reserved by the repository owner.