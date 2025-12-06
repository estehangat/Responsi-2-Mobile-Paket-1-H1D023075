# Inventaris Komputer SuperDaiva

Aplikasi Flutter untuk mencatat inventaris barang kategori Komputer di supermarket SuperDaiva.

## Fitur

- ✅ **Login & Registrasi** - Sistem autentikasi user dengan JWT
- ✅ **CRUD Inventaris** - Create, Read, Update, Delete data inventaris
- ✅ **Tema Abu-abu** - Warna utama aplikasi menggunakan abu-abu
- ✅ **API Terpisah** - Backend API menggunakan Node.js/Express

## Data Inventaris

Setiap barang inventaris mencatat:
- **Nama** (string) - Nama barang komputer
- **Harga** (int) - Harga per unit dalam Rupiah
- **Jumlah** (int) - Jumlah stok tersedia
- **Tanggal Masuk** (string) - Tanggal barang masuk ke inventaris

## Struktur Proyek

```
lib/
├── main.dart                    # Entry point aplikasi
├── models/
│   ├── inventaris.dart          # Model data inventaris
│   └── user.dart                # Model data user
├── pages/
│   ├── login_page.dart          # Halaman login
│   ├── register_page.dart       # Halaman registrasi
│   ├── inventaris_list_page.dart    # Halaman daftar inventaris
│   ├── inventaris_form_page.dart    # Halaman tambah/edit
│   └── inventaris_detail_page.dart  # Halaman detail inventaris
└── services/
    └── api_service.dart         # Service untuk komunikasi API

api/
├── package.json                 # Dependencies Node.js
└── server.js                    # API Server Express
```

## Cara Menjalankan

### 1. Setup API Backend

```bash
cd api
npm install
npm start
```

API akan berjalan di `http://localhost:3000`

### 2. Setup Flutter App

```bash
# Di root folder proyek
flutter pub get
flutter run
```

### Konfigurasi API URL

Edit file `lib/services/api_service.dart` untuk menyesuaikan URL API:

- **Emulator Android:** `http://10.0.2.2:3000/api`
- **iOS Simulator / Desktop:** `http://localhost:3000/api`
- **Device Fisik:** Ganti dengan IP komputer Anda, contoh: `http://192.168.1.100:3000/api`

## API Endpoints

### Authentication
- `POST /api/register` - Registrasi user baru
- `POST /api/login` - Login user

### Inventaris (Memerlukan Token)
- `GET /api/inventaris` - Mendapatkan semua data inventaris
- `GET /api/inventaris/:id` - Mendapatkan detail inventaris
- `POST /api/inventaris` - Menambah inventaris baru
- `PUT /api/inventaris/:id` - Mengupdate inventaris
- `DELETE /api/inventaris/:id` - Menghapus inventaris

## Screenshots

### Halaman-halaman Aplikasi:
1. **Splash Screen** - Tampilan loading dengan branding SuperDaiva
2. **Login SuperDaiva** - Halaman login user
3. **Registrasi SuperDaiva** - Halaman daftar akun baru
4. **Inventaris Komputer SuperDaiva** - Daftar semua inventaris
5. **Tambah Inventaris SuperDaiva** - Form tambah data baru
6. **Edit Inventaris SuperDaiva** - Form edit data
7. **Detail Inventaris SuperDaiva** - Detail lengkap barang

## Teknologi

- **Frontend:** Flutter/Dart
- **Backend:** Node.js, Express.js
- **Database:** SQLite (better-sqlite3)
- **Authentication:** JWT (JSON Web Token)
- **Password Hashing:** bcryptjs

## Dependencies Flutter

- `http` - HTTP client untuk API calls
- `shared_preferences` - Menyimpan token & data user
- `intl` - Format tanggal

## Dependencies API

- `express` - Web framework
- `cors` - Cross-Origin Resource Sharing
- `bcryptjs` - Password hashing
- `jsonwebtoken` - JWT authentication
- `better-sqlite3` - SQLite database

---

**Dibuat oleh:** Daiva  
**Nama Aplikasi:** SuperDaiva

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
