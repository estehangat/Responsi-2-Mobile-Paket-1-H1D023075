# Inventaris Komputer SuperDaiva

Aplikasi Flutter untuk mencatat inventaris barang kategori Komputer di supermarket SuperDaiva.

## Fitur Utama

- ✅ **Login & Registrasi** - Sistem autentikasi user dengan JWT
- ✅ **CRUD Inventaris** - Create, Read, Update, Delete data inventaris
- ✅ **Tema Abu-abu** - Warna utama aplikasi menggunakan abu-abu
- ✅ **API Terpisah** - Backend API menggunakan Node.js/Express

## Data Inventaris

Setiap barang inventaris mencatat:
| Field | Tipe | Keterangan |
|-------|------|------------|
| Nama | String | Nama barang komputer |
| Harga | Integer | Harga per unit dalam Rupiah |
| Jumlah | Integer | Jumlah stok tersedia |
| Tanggal Masuk | String | Tanggal barang masuk (format: YYYY-MM-DD) |

---

## Struktur Proyek

```
lib/
├── main.dart                        # Entry point aplikasi
├── models/
│   ├── inventaris.dart              # Model data inventaris
│   └── user.dart                    # Model data user
├── pages/
│   ├── login_page.dart              # Halaman login
│   ├── register_page.dart           # Halaman registrasi
│   ├── inventaris_list_page.dart    # Halaman daftar inventaris
│   ├── inventaris_form_page.dart    # Halaman tambah/edit
│   └── inventaris_detail_page.dart  # Halaman detail inventaris
└── services/
    └── api_service.dart             # Service untuk komunikasi API

api/
├── package.json                     # Dependencies Node.js
├── server.js                        # API Server Express
└── database/
    ├── users.json                   # Data users
    └── inventaris.json              # Data inventaris
```

---

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
flutter pub get
flutter run
```

### 3. Konfigurasi API URL

Edit file `lib/services/api_service.dart`:

```dart
// Untuk Emulator Android:
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Untuk iOS Simulator / Desktop:
static const String baseUrl = 'http://localhost:3000/api';

// Untuk Device Fisik (ganti dengan IP komputer):
static const String baseUrl = 'http://192.168.x.x:3000/api';
```

---

# SPESIFIKASI API

## Base URL
```
http://localhost:3000/api
```

## Authentication

### 1. Register User
Mendaftarkan user baru ke sistem.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `POST /api/register` |
| **Method** | POST |
| **Auth Required** | Tidak |
| **Content-Type** | application/json |

**Request Body:**
```json
{
  "username": "string (required)",
  "email": "string (required)",
  "password": "string (required)"
}
```

**Response Success (201):**
```json
{
  "message": "Registrasi berhasil",
  "userId": 1
}
```

**Response Error (400):**
```json
{
  "error": "Username atau email sudah terdaftar"
}
```

---

### 2. Login User
Autentikasi user dan mendapatkan token JWT.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `POST /api/login` |
| **Method** | POST |
| **Auth Required** | Tidak |
| **Content-Type** | application/json |

**Request Body:**
```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

**Response Success (200):**
```json
{
  "message": "Login berhasil",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "daiva",
    "email": "daiva@email.com"
  }
}
```

**Response Error (401):**
```json
{
  "error": "Email atau password salah"
}
```

---

## Inventaris CRUD

> **Catatan:** Semua endpoint inventaris memerlukan header Authorization dengan Bearer Token.

**Header yang diperlukan:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

---

### 3. Get All Inventaris
Mengambil semua data inventaris milik user yang sedang login.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `GET /api/inventaris` |
| **Method** | GET |
| **Auth Required** | Ya (Bearer Token) |

**Response Success (200):**
```json
[
  {
    "id": 1,
    "nama": "Laptop ASUS ROG",
    "harga": 15000000,
    "jumlah": 5,
    "tanggal_masuk": "2024-12-01",
    "user_id": 1,
    "created_at": "2024-12-01T10:00:00.000Z",
    "updated_at": "2024-12-01T10:00:00.000Z"
  }
]
```

---

### 4. Get Inventaris by ID
Mengambil detail satu inventaris berdasarkan ID.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `GET /api/inventaris/:id` |
| **Method** | GET |
| **Auth Required** | Ya (Bearer Token) |
| **URL Parameter** | `id` - ID inventaris |

**Response Success (200):**
```json
{
  "id": 1,
  "nama": "Laptop ASUS ROG",
  "harga": 15000000,
  "jumlah": 5,
  "tanggal_masuk": "2024-12-01",
  "user_id": 1,
  "created_at": "2024-12-01T10:00:00.000Z",
  "updated_at": "2024-12-01T10:00:00.000Z"
}
```

**Response Error (404):**
```json
{
  "error": "Data tidak ditemukan"
}
```

---

### 5. Create Inventaris
Menambahkan data inventaris baru.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `POST /api/inventaris` |
| **Method** | POST |
| **Auth Required** | Ya (Bearer Token) |
| **Content-Type** | application/json |

**Request Body:**
```json
{
  "nama": "string (required)",
  "harga": "integer (required)",
  "jumlah": "integer (required)",
  "tanggal_masuk": "string YYYY-MM-DD (required)"
}
```

**Contoh Request:**
```json
{
  "nama": "Monitor LG 24 inch",
  "harga": 2500000,
  "jumlah": 10,
  "tanggal_masuk": "2024-12-06"
}
```

**Response Success (201):**
```json
{
  "message": "Data berhasil ditambahkan",
  "data": {
    "id": 2,
    "nama": "Monitor LG 24 inch",
    "harga": 2500000,
    "jumlah": 10,
    "tanggal_masuk": "2024-12-06",
    "user_id": 1,
    "created_at": "2024-12-06T10:00:00.000Z",
    "updated_at": "2024-12-06T10:00:00.000Z"
  }
}
```

---

### 6. Update Inventaris
Mengupdate data inventaris yang sudah ada.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `PUT /api/inventaris/:id` |
| **Method** | PUT |
| **Auth Required** | Ya (Bearer Token) |
| **URL Parameter** | `id` - ID inventaris |
| **Content-Type** | application/json |

**Request Body:**
```json
{
  "nama": "string (required)",
  "harga": "integer (required)",
  "jumlah": "integer (required)",
  "tanggal_masuk": "string YYYY-MM-DD (required)"
}
```

**Response Success (200):**
```json
{
  "message": "Data berhasil diupdate",
  "data": {
    "id": 1,
    "nama": "Laptop ASUS ROG (Updated)",
    "harga": 16000000,
    "jumlah": 3,
    "tanggal_masuk": "2024-12-01",
    "user_id": 1,
    "created_at": "2024-12-01T10:00:00.000Z",
    "updated_at": "2024-12-06T12:00:00.000Z"
  }
}
```

---

### 7. Delete Inventaris
Menghapus data inventaris.

| Spesifikasi | Detail |
|-------------|--------|
| **Endpoint** | `DELETE /api/inventaris/:id` |
| **Method** | DELETE |
| **Auth Required** | Ya (Bearer Token) |
| **URL Parameter** | `id` - ID inventaris |

**Response Success (200):**
```json
{
  "message": "Data berhasil dihapus"
}
```

**Response Error (404):**
```json
{
  "error": "Data tidak ditemukan"
}
```

---

## Error Responses

| Status Code | Keterangan |
|-------------|------------|
| 400 | Bad Request - Data tidak lengkap atau tidak valid |
| 401 | Unauthorized - Token tidak ditemukan |
| 403 | Forbidden - Token tidak valid atau expired |
| 404 | Not Found - Data tidak ditemukan |
| 500 | Internal Server Error - Kesalahan server |

---

# PENJELASAN KODE

## 1. Model Inventaris (`lib/models/inventaris.dart`)

Model untuk merepresentasikan data inventaris komputer.

```dart
class Inventaris {
  final int? id;           // ID unik inventaris (nullable untuk data baru)
  final String nama;       // Nama barang komputer
  final int harga;         // Harga per unit
  final int jumlah;        // Jumlah stok
  final String tanggalMasuk; // Tanggal masuk barang
  final int? userId;       // ID user pemilik data
  final String? createdAt; // Timestamp dibuat
  final String? updatedAt; // Timestamp diupdate
}
```

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `Inventaris()` | Constructor untuk membuat objek Inventaris dengan parameter required |
| `fromJson(Map<String, dynamic> json)` | Factory constructor untuk mengkonversi JSON dari API menjadi objek Inventaris |
| `toJson()` | Mengkonversi objek Inventaris menjadi Map untuk dikirim ke API |
| `hargaFormatted` | Getter untuk format harga ke format Rupiah (Rp 15.000.000) |
| `totalNilai` | Getter untuk menghitung total nilai (harga × jumlah) |
| `totalNilaiFormatted` | Getter untuk format total nilai ke Rupiah |

---

## 2. Model User (`lib/models/user.dart`)

Model untuk merepresentasikan data user.

```dart
class User {
  final int id;        // ID unik user
  final String username; // Username
  final String email;    // Email user
}
```

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `User()` | Constructor untuk membuat objek User |
| `fromJson(Map<String, dynamic> json)` | Mengkonversi JSON dari API menjadi objek User |
| `toJson()` | Mengkonversi objek User menjadi Map untuk disimpan di SharedPreferences |

---

## 3. API Service (`lib/services/api_service.dart`)

Service class untuk menangani semua komunikasi dengan backend API.

### Fungsi Authentication:

| Fungsi | Penjelasan |
|--------|------------|
| `getToken()` | Mengambil JWT token yang tersimpan di SharedPreferences |
| `saveToken(String token)` | Menyimpan JWT token ke SharedPreferences setelah login berhasil |
| `saveUser(User user)` | Menyimpan data user ke SharedPreferences dalam format JSON |
| `getUser()` | Mengambil data user yang tersimpan dan mengkonversi ke objek User |
| `logout()` | Menghapus token dan data user dari SharedPreferences |
| `isLoggedIn()` | Mengecek apakah user sudah login (token ada atau tidak) |
| `register(username, email, password)` | Mengirim request POST ke /api/register untuk mendaftarkan user baru |
| `login(email, password)` | Mengirim request POST ke /api/login, menyimpan token dan user jika berhasil |

### Fungsi CRUD Inventaris:

| Fungsi | Penjelasan |
|--------|------------|
| `getInventaris()` | Mengambil semua data inventaris user dengan GET request, return List<Inventaris> |
| `getInventarisById(int id)` | Mengambil detail satu inventaris dengan GET request berdasarkan ID |
| `createInventaris(Inventaris)` | Menambah inventaris baru dengan POST request |
| `updateInventaris(int id, Inventaris)` | Mengupdate inventaris dengan PUT request |
| `deleteInventaris(int id)` | Menghapus inventaris dengan DELETE request |

---

## 4. Halaman Login (`lib/pages/login_page.dart`)

Halaman untuk user melakukan login ke aplikasi.

**State Variables:**
- `_formKey` - GlobalKey untuk validasi form
- `_emailController` - Controller untuk input email
- `_passwordController` - Controller untuk input password
- `_isLoading` - Status loading saat proses login
- `_obscurePassword` - Toggle visibility password

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `dispose()` | Membersihkan controller saat widget dihapus dari tree |
| `_login()` | Validasi form, panggil ApiService.login(), navigasi ke halaman list jika berhasil |
| `build()` | Membangun UI dengan form email, password, tombol login, dan link ke register |

---

## 5. Halaman Register (`lib/pages/register_page.dart`)

Halaman untuk mendaftarkan akun baru.

**State Variables:**
- `_formKey` - GlobalKey untuk validasi form
- `_usernameController` - Controller untuk input username
- `_emailController` - Controller untuk input email
- `_passwordController` - Controller untuk input password
- `_confirmPasswordController` - Controller untuk konfirmasi password
- `_isLoading` - Status loading saat proses registrasi

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `dispose()` | Membersihkan semua controller |
| `_register()` | Validasi form (termasuk password match), panggil ApiService.register(), kembali ke login jika berhasil |
| `build()` | Membangun UI form registrasi dengan validasi |

---

## 6. Halaman List Inventaris (`lib/pages/inventaris_list_page.dart`)

Halaman utama yang menampilkan daftar semua inventaris.

**State Variables:**
- `_inventarisList` - List untuk menyimpan data inventaris
- `_isLoading` - Status loading saat fetch data
- `_errorMessage` - Pesan error jika gagal fetch

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `initState()` | Dipanggil saat widget dibuat, memanggil `_loadInventaris()` |
| `_loadInventaris()` | Mengambil data inventaris dari API dan update state |
| `_logout()` | Menampilkan dialog konfirmasi, hapus session, navigasi ke login |
| `_buildBody()` | Membangun body berdasarkan state (loading, error, empty, atau list) |
| `build()` | Membangun UI dengan AppBar, list inventaris, dan FAB untuk tambah data |

---

## 7. Halaman Form Inventaris (`lib/pages/inventaris_form_page.dart`)

Halaman untuk menambah atau mengedit data inventaris.

**Properties:**
- `inventaris` - Objek Inventaris (null = mode tambah, filled = mode edit)

**State Variables:**
- `_formKey` - GlobalKey untuk validasi form
- `_namaController` - Controller untuk input nama barang
- `_hargaController` - Controller untuk input harga
- `_jumlahController` - Controller untuk input jumlah
- `_tanggalController` - Controller untuk input tanggal
- `_selectedDate` - DateTime yang dipilih
- `_isLoading` - Status loading

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `isEditMode` | Getter untuk mengecek apakah mode edit atau tambah |
| `initState()` | Mengisi form dengan data existing jika mode edit |
| `_selectDate()` | Menampilkan DatePicker dan update tanggal yang dipilih |
| `_saveInventaris()` | Validasi form, panggil create atau update API berdasarkan mode |
| `build()` | Membangun UI form dengan input nama, harga, jumlah, tanggal |

---

## 8. Halaman Detail Inventaris (`lib/pages/inventaris_detail_page.dart`)

Halaman untuk melihat detail lengkap dan menghapus inventaris.

**Properties:**
- `inventaris` - Objek Inventaris yang akan ditampilkan

**State Variables:**
- `_inventaris` - Data inventaris yang bisa diupdate
- `_isLoading` - Status loading

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `initState()` | Inisialisasi `_inventaris` dari widget.inventaris |
| `_deleteInventaris()` | Menampilkan dialog konfirmasi, panggil API delete, kembali ke list |
| `_editInventaris()` | Navigasi ke form edit, reload data setelah kembali |
| `_buildDetailCard()` | Widget builder untuk card detail info |
| `build()` | Membangun UI detail dengan card info dan tombol edit/hapus |

---

## 9. Main App (`lib/main.dart`)

Entry point dan konfigurasi utama aplikasi.

**Class MyApp:**
- Konfigurasi MaterialApp dengan tema abu-abu
- Setup ColorScheme, AppBarTheme, ElevatedButtonTheme

**Class SplashScreen:**
- Halaman splash dengan branding SuperDaiva
- Cek status login dan navigasi ke halaman yang sesuai

**Fungsi-fungsi:**

| Fungsi | Penjelasan |
|--------|------------|
| `main()` | Entry point aplikasi, menjalankan MyApp |
| `_checkLoginStatus()` | Delay 2 detik, cek token, navigasi ke list atau login |
| `build()` | Membangun UI splash screen dengan logo dan loading indicator |

---

## 10. API Server (`api/server.js`)

Backend API menggunakan Express.js dengan JSON file storage.

### Konfigurasi:

| Variabel | Penjelasan |
|----------|------------|
| `PORT` | Port server (3000) |
| `JWT_SECRET` | Secret key untuk JWT |
| `DB_PATH` | Path folder database |
| `USERS_FILE` | Path file users.json |
| `INVENTARIS_FILE` | Path file inventaris.json |

### Helper Functions:

| Fungsi | Penjelasan |
|--------|------------|
| `initDB()` | Membuat file database jika belum ada |
| `readUsers()` | Membaca dan parse file users.json |
| `writeUsers(data)` | Menulis data ke file users.json |
| `readInventaris()` | Membaca dan parse file inventaris.json |
| `writeInventaris(data)` | Menulis data ke file inventaris.json |
| `generateId(items)` | Generate ID baru (max ID + 1) |

### Middleware:

| Middleware | Penjelasan |
|------------|------------|
| `cors()` | Mengaktifkan Cross-Origin Resource Sharing |
| `express.json()` | Parse request body sebagai JSON |
| `authenticateToken` | Verifikasi JWT token dari header Authorization |

### Route Handlers:

| Route | Method | Fungsi |
|-------|--------|--------|
| `/api/register` | POST | Hash password dengan bcrypt, simpan user baru |
| `/api/login` | POST | Verifikasi credentials, generate JWT token |
| `/api/inventaris` | GET | Filter inventaris by user_id, sort by created_at DESC |
| `/api/inventaris/:id` | GET | Cari inventaris by id dan user_id |
| `/api/inventaris` | POST | Buat inventaris baru dengan user_id dari token |
| `/api/inventaris/:id` | PUT | Update inventaris, cek ownership |
| `/api/inventaris/:id` | DELETE | Hapus inventaris, cek ownership |

---

## Teknologi yang Digunakan

### Frontend (Flutter)
| Package | Versi | Kegunaan |
|---------|-------|----------|
| http | ^1.1.0 | HTTP client untuk API calls |
| shared_preferences | ^2.2.2 | Menyimpan token & data user secara lokal |
| intl | ^0.19.0 | Format tanggal Indonesia |

### Backend (Node.js)
| Package | Versi | Kegunaan |
|---------|-------|----------|
| express | ^4.18.2 | Web framework untuk API |
| cors | ^2.8.5 | Mengaktifkan Cross-Origin requests |
| bcryptjs | ^2.4.3 | Hash password dengan algoritma bcrypt |
| jsonwebtoken | ^9.0.2 | Generate dan verifikasi JWT token |

---

**Dibuat oleh:** Daiva  
**Nama Aplikasi:** SuperDaiva  
**NIM:** H1D023075
