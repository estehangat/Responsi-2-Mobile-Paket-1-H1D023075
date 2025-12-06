# Responsi 2 Mobile Paket 1

```
Nama      : Daiva Paundra Gevano
NIM       : H1D023075
Shift     : A
Shift KRS : F
```

## Demo Aplikasi
https://github.com/user-attachments/assets/71907110-1dab-4cf3-9033-afe8ee93ea1d

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
    "email": "daiva@admin.com"
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
    "nama": "Laptop",
    "harga": 15000000,
    "jumlah": 12,
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
  "nama": "Laptop",
  "harga": 15000000,
  "jumlah": 12,
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
  "nama": "Laptop",
  "harga": 15000000,
  "jumlah": 12,
  "tanggal_masuk": "2024-12-06"
}
```

**Response Success (201):**
```json
{
  "message": "Data berhasil ditambahkan",
  "data": {
    "id": 2,
    "nama": "Laptop",
    "harga": 15000000,
    "jumlah": 12,
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
    "nama": "Laptop",
    "harga": 18000000,
    "jumlah": 12,
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

### Struktur Class:
```dart
class Inventaris {
  final int? id;             // ID unik (nullable untuk data baru)
  final String nama;         // Nama barang komputer
  final int harga;           // Harga per unit
  final int jumlah;          // Jumlah stok
  final String tanggalMasuk; // Tanggal masuk barang
  final int? userId;         // ID user pemilik
  final String? createdAt;   // Timestamp dibuat
  final String? updatedAt;   // Timestamp diupdate
}
```

### Fungsi fromJson - Konversi JSON ke Object:
```dart
factory Inventaris.fromJson(Map<String, dynamic> json) {
  return Inventaris(
    id: json['id'],
    nama: json['nama'],
    harga: json['harga'],
    jumlah: json['jumlah'],
    tanggalMasuk: json['tanggal_masuk'],
    userId: json['user_id'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}
```
**Penjelasan:** Factory constructor yang mengkonversi response JSON dari API menjadi objek Inventaris.

### Fungsi toJson - Konversi Object ke JSON:
```dart
Map<String, dynamic> toJson() {
  return {
    'nama': nama,
    'harga': harga,
    'jumlah': jumlah,
    'tanggal_masuk': tanggalMasuk,
  };
}
```
**Penjelasan:** Mengkonversi objek Inventaris menjadi Map untuk dikirim ke API saat create/update.

### Fungsi Lainnya:

| Fungsi | Penjelasan |
|--------|------------|
| `Inventaris()` | Constructor untuk membuat objek Inventaris dengan parameter required |
| `hargaFormatted` | Getter untuk format harga ke format Rupiah (Rp 15.000.000) |
| `totalNilai` | Getter untuk menghitung total nilai (harga × jumlah) |
| `totalNilaiFormatted` | Getter untuk format total nilai ke Rupiah |

---

## 1.2 Model User (`lib/models/user.dart`)

Model untuk merepresentasikan data user.

```dart
class User {
  final int id;        // ID unik user
  final String username; // Username
  final String email;    // Email user
}
```

| Fungsi | Penjelasan |
|--------|------------|
| `User()` | Constructor untuk membuat objek User |
| `fromJson(Map<String, dynamic> json)` | Mengkonversi JSON dari API menjadi objek User |
| `toJson()` | Mengkonversi objek User menjadi Map untuk disimpan di SharedPreferences |

---

## 2. API Service (`lib/services/api_service.dart`)

Service class untuk komunikasi dengan backend API.

### Fungsi Login:
```dart
static Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveToken(data['token']);
      await saveUser(User.fromJson(data['user']));
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['error'] ?? 'Login gagal'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
  }
}
```
**Penjelasan:** Mengirim POST request ke `/api/login`, jika berhasil menyimpan token dan data user ke SharedPreferences.

### Fungsi Register:
```dart
static Future<Map<String, dynamic>> register(
  String username, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['error'] ?? 'Registrasi gagal'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
  }
}
```
**Penjelasan:** Mengirim data registrasi ke API dan mengembalikan status berhasil/gagal.

### Fungsi Get All Inventaris:
```dart
static Future<List<Inventaris>> getInventaris() async {
  try {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/inventaris'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Inventaris.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data inventaris');
    }
  } catch (e) {
    throw Exception('Tidak dapat terhubung ke server');
  }
}
```
**Penjelasan:** Mengambil semua data inventaris dari API dengan menyertakan Bearer token untuk autentikasi.

### Fungsi Create Inventaris:
```dart
static Future<Map<String, dynamic>> createInventaris(Inventaris inventaris) async {
  try {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/inventaris'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(inventaris.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'],
        'data': Inventaris.fromJson(data['data']),
      };
    } else {
      return {'success': false, 'message': data['error'] ?? 'Gagal menambahkan data'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
  }
}
```
**Penjelasan:** Mengirim POST request untuk menambah inventaris baru dengan data dari objek Inventaris.

### Fungsi Update Inventaris:
```dart
static Future<Map<String, dynamic>> updateInventaris(int id, Inventaris inventaris) async {
  try {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/inventaris/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(inventaris.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': data['message'],
        'data': Inventaris.fromJson(data['data']),
      };
    } else {
      return {'success': false, 'message': data['error'] ?? 'Gagal mengupdate data'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
  }
}
```
**Penjelasan:** Mengirim PUT request untuk mengupdate inventaris berdasarkan ID.

### Fungsi Delete Inventaris:
```dart
static Future<Map<String, dynamic>> deleteInventaris(int id) async {
  try {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/inventaris/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['error'] ?? 'Gagal menghapus data'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
  }
}
```
**Penjelasan:** Mengirim DELETE request untuk menghapus inventaris berdasarkan ID.

### Fungsi Lainnya:

| Fungsi | Penjelasan |
|--------|------------|
| `getToken()` | Mengambil JWT token yang tersimpan di SharedPreferences |
| `saveToken(String token)` | Menyimpan JWT token ke SharedPreferences setelah login berhasil |
| `saveUser(User user)` | Menyimpan data user ke SharedPreferences dalam format JSON |
| `getUser()` | Mengambil data user yang tersimpan dan mengkonversi ke objek User |
| `logout()` | Menghapus token dan data user dari SharedPreferences |
| `isLoggedIn()` | Mengecek apakah user sudah login (token ada atau tidak) |
| `getInventarisById(int id)` | Mengambil detail satu inventaris dengan GET request berdasarkan ID |

---

## 3. Halaman Login (`lib/pages/login_page.dart`)

### Fungsi _login - Proses Login:
```dart
Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    final result = await ApiService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InventarisListPage()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    }
  }
}
```
**Penjelasan:** Validasi form, panggil API login, jika berhasil navigasi ke halaman list, jika gagal tampilkan snackbar error.

### Komponen dan State:

| Komponen/State | Penjelasan |
|----------------|------------|
| `_formKey` | GlobalKey untuk validasi form |
| `_emailController` | Controller untuk input email |
| `_passwordController` | Controller untuk input password |
| `_isLoading` | Status loading saat proses login |
| `_obscurePassword` | Toggle visibility password |
| `dispose()` | Membersihkan controller saat widget dihapus dari tree |
| `build()` | Membangun UI dengan form email, password, tombol login, dan link ke register |

---

## 3.2 Halaman Register (`lib/pages/register_page.dart`)

Halaman untuk mendaftarkan akun baru.

| Komponen/State | Penjelasan |
|----------------|------------|
| `_formKey` | GlobalKey untuk validasi form |
| `_usernameController` | Controller untuk input username |
| `_emailController` | Controller untuk input email |
| `_passwordController` | Controller untuk input password |
| `_confirmPasswordController` | Controller untuk konfirmasi password |
| `_isLoading` | Status loading saat proses registrasi |
| `dispose()` | Membersihkan semua controller |
| `_register()` | Validasi form (termasuk password match), panggil ApiService.register(), kembali ke login jika berhasil |
| `build()` | Membangun UI form registrasi dengan validasi |

---

## 4. Halaman Form Inventaris (`lib/pages/inventaris_form_page.dart`)

### Fungsi _saveInventaris - Simpan Data:
```dart
Future<void> _saveInventaris() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    final inventaris = Inventaris(
      nama: _namaController.text.trim(),
      harga: int.parse(_hargaController.text),
      jumlah: int.parse(_jumlahController.text),
      tanggalMasuk: _tanggalController.text,
    );

    Map<String, dynamic> result;
    if (isEditMode) {
      result = await ApiService.updateInventaris(widget.inventaris!.id!, inventaris);
    } else {
      result = await ApiService.createInventaris(inventaris);
    }

    setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    }
  }
}
```
**Penjelasan:** Membuat objek Inventaris dari input form, kemudian memanggil create atau update API tergantung mode (tambah/edit).

### Komponen dan State:

| Komponen/State | Penjelasan |
|----------------|------------|
| `inventaris` | Property objek Inventaris (null = mode tambah, filled = mode edit) |
| `_formKey` | GlobalKey untuk validasi form |
| `_namaController` | Controller untuk input nama barang |
| `_hargaController` | Controller untuk input harga |
| `_jumlahController` | Controller untuk input jumlah |
| `_tanggalController` | Controller untuk input tanggal |
| `_selectedDate` | DateTime yang dipilih |
| `_isLoading` | Status loading |
| `isEditMode` | Getter untuk mengecek apakah mode edit atau tambah |
| `initState()` | Mengisi form dengan data existing jika mode edit |
| `_selectDate()` | Menampilkan DatePicker dan update tanggal yang dipilih |
| `build()` | Membangun UI form dengan input nama, harga, jumlah, tanggal |

---

## 4.2 Halaman List Inventaris (`lib/pages/inventaris_list_page.dart`)

Halaman utama yang menampilkan daftar semua inventaris.

| Komponen/State | Penjelasan |
|----------------|------------|
| `_inventarisList` | List untuk menyimpan data inventaris |
| `_isLoading` | Status loading saat fetch data |
| `_errorMessage` | Pesan error jika gagal fetch |
| `initState()` | Dipanggil saat widget dibuat, memanggil `_loadInventaris()` |
| `_loadInventaris()` | Mengambil data inventaris dari API dan update state |
| `_logout()` | Menampilkan dialog konfirmasi, hapus session, navigasi ke login |
| `_buildBody()` | Membangun body berdasarkan state (loading, error, empty, atau list) |
| `build()` | Membangun UI dengan AppBar, list inventaris, dan FAB untuk tambah data |

---

## 4.3 Halaman Detail Inventaris (`lib/pages/inventaris_detail_page.dart`)

Halaman untuk melihat detail lengkap dan menghapus inventaris.

| Komponen/State | Penjelasan |
|----------------|------------|
| `inventaris` | Property objek Inventaris yang akan ditampilkan |
| `_inventaris` | Data inventaris yang bisa diupdate |
| `_isLoading` | Status loading |
| `initState()` | Inisialisasi `_inventaris` dari widget.inventaris |
| `_deleteInventaris()` | Menampilkan dialog konfirmasi, panggil API delete, kembali ke list |
| `_editInventaris()` | Navigasi ke form edit, reload data setelah kembali |
| `_buildDetailCard()` | Widget builder untuk card detail info |
| `build()` | Membangun UI detail dengan card info dan tombol edit/hapus |

---

## 5. API Server (`api/server.js`)

### Middleware authenticateToken - Verifikasi JWT:
```javascript
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token tidak ditemukan' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Token tidak valid' });
    }
    req.user = user;
    next();
  });
};
```
**Penjelasan:** Middleware yang memverifikasi JWT token dari header Authorization. Jika valid, data user disimpan di `req.user`.

### Route POST /api/register - Registrasi User:
```javascript
app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ error: 'Semua field harus diisi' });
    }

    const users = readUsers();
    
    const existingUser = users.find(u => u.username === username || u.email === email);
    if (existingUser) {
      return res.status(400).json({ error: 'Username atau email sudah terdaftar' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = {
      id: generateId(users),
      username,
      email,
      password: hashedPassword,
      created_at: new Date().toISOString()
    };

    users.push(newUser);
    writeUsers(users);

    res.status(201).json({ message: 'Registrasi berhasil', userId: newUser.id });
  } catch (error) {
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});
```
**Penjelasan:** Menerima data registrasi, cek duplikat, hash password dengan bcrypt, simpan user baru ke database.

### Route POST /api/login - Login User:
```javascript
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const users = readUsers();
    const user = users.find(u => u.email === email);
    
    if (!user) {
      return res.status(401).json({ error: 'Email atau password salah' });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Email atau password salah' });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, email: user.email },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login berhasil',
      token,
      user: { id: user.id, username: user.username, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});
```
**Penjelasan:** Verifikasi email dan password, jika valid generate JWT token dengan expiry 24 jam.

### Route POST /api/inventaris - Create Inventaris:
```javascript
app.post('/api/inventaris', authenticateToken, (req, res) => {
  try {
    const { nama, harga, jumlah, tanggal_masuk } = req.body;

    if (!nama || harga === undefined || jumlah === undefined || !tanggal_masuk) {
      return res.status(400).json({ error: 'Semua field harus diisi' });
    }

    const allInventaris = readInventaris();
    
    const newInventaris = {
      id: generateId(allInventaris),
      nama,
      harga,
      jumlah,
      tanggal_masuk,
      user_id: req.user.id,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    allInventaris.push(newInventaris);
    writeInventaris(allInventaris);

    res.status(201).json({ message: 'Data berhasil ditambahkan', data: newInventaris });
  } catch (error) {
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});
```
**Penjelasan:** Menerima data inventaris, validasi field, simpan dengan user_id dari token, return data yang baru dibuat.

### Route DELETE /api/inventaris/:id - Hapus Inventaris:
```javascript
app.delete('/api/inventaris/:id', authenticateToken, (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const allInventaris = readInventaris();
    
    const index = allInventaris.findIndex(
      item => item.id === id && item.user_id === req.user.id
    );
    
    if (index === -1) {
      return res.status(404).json({ error: 'Data tidak ditemukan' });
    }

    allInventaris.splice(index, 1);
    writeInventaris(allInventaris);

    res.json({ message: 'Data berhasil dihapus' });
  } catch (error) {
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
});
```
**Penjelasan:** Cari inventaris berdasarkan ID dan user_id (ownership check), hapus dari array, simpan kembali ke file.

### Konfigurasi dan Helper Functions:

| Variabel/Fungsi | Penjelasan |
|-----------------|------------|
| `PORT` | Port server (3000) |
| `JWT_SECRET` | Secret key untuk JWT |
| `DB_PATH` | Path folder database |
| `USERS_FILE` | Path file users.json |
| `INVENTARIS_FILE` | Path file inventaris.json |
| `initDB()` | Membuat file database jika belum ada |
| `readUsers()` | Membaca dan parse file users.json |
| `writeUsers(data)` | Menulis data ke file users.json |
| `readInventaris()` | Membaca dan parse file inventaris.json |
| `writeInventaris(data)` | Menulis data ke file inventaris.json |
| `generateId(items)` | Generate ID baru (max ID + 1) |

### Route Lainnya:

| Route | Method | Penjelasan |
|-------|--------|------------|
| `/api/inventaris` | GET | Filter inventaris by user_id, sort by created_at DESC |
| `/api/inventaris/:id` | GET | Cari inventaris by id dan user_id |
| `/api/inventaris/:id` | PUT | Update inventaris, cek ownership |

---

## 6. Main App (`lib/main.dart`)

Entry point dan konfigurasi utama aplikasi.

| Class/Fungsi | Penjelasan |
|--------------|------------|
| `MyApp` | Konfigurasi MaterialApp dengan tema abu-abu, setup ColorScheme, AppBarTheme, ElevatedButtonTheme |
| `SplashScreen` | Halaman splash dengan branding SuperDaiva, cek status login dan navigasi ke halaman yang sesuai |
| `main()` | Entry point aplikasi, menjalankan MyApp |
| `_checkLoginStatus()` | Delay 2 detik, cek token, navigasi ke list atau login |
| `build()` | Membangun UI splash screen dengan logo dan loading indicator |
