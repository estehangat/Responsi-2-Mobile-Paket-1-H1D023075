import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventaris.dart';
import '../models/user.dart';

class ApiService {
  // IP Address komputer untuk testing di HP fisik
  // Pastikan HP dan komputer terhubung ke jaringan yang sama
  static const String baseUrl = 'http://192.168.100.7:3000/api';

  // Untuk testing di web atau desktop Windows, gunakan:
  // static const String baseUrl = 'http://localhost:3000/api';

  // ==================== AUTH ====================

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Register
  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
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
        return {
          'success': false,
          'message': data['error'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
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

  // ==================== INVENTARIS CRUD ====================

  // Get all inventaris
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

  // Get single inventaris
  static Future<Inventaris> getInventarisById(int id) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/inventaris/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Inventaris.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Data tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server');
    }
  }

  // Create inventaris
  static Future<Map<String, dynamic>> createInventaris(
    Inventaris inventaris,
  ) async {
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
        return {
          'success': false,
          'message': data['error'] ?? 'Gagal menambahkan data',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  // Update inventaris
  static Future<Map<String, dynamic>> updateInventaris(
    int id,
    Inventaris inventaris,
  ) async {
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
        return {
          'success': false,
          'message': data['error'] ?? 'Gagal mengupdate data',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  // Delete inventaris
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
        return {
          'success': false,
          'message': data['error'] ?? 'Gagal menghapus data',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }
}
