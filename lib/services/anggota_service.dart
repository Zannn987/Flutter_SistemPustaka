import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AnggotaService {
  static const String baseUrl = '${ApiConfig.baseUrl}/anggota';

  // Login anggota
  Future<Map<String, dynamic>> login(String nim, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'nim': nim,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login gagal');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get profile anggota
  Future<Map<String, dynamic>> getProfile(String nim) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/$nim'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil data profile');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Update password
  Future<bool> updatePassword(
      String nim, String oldPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-password'),
        body: {
          'nim': nim,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
