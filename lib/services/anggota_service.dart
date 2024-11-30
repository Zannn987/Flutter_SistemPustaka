import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AnggotaService {
  Future<Map<String, dynamic>> login(String nim, String password) async {
    try {
      print('Attempting login with NIM: $nim');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/anggota/login.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'nim': nim,
          'password': password,
        },
      ).timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in login service: $e');
      throw Exception('Gagal melakukan login: $e');
    }
  }

  // Get profile anggota
  Future<Map<String, dynamic>> getProfile(String nim) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.profileUrl}?nim=$nim'),
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

  // Get all anggota
  Future<List<dynamic>> getAllAnggota() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.anggotaUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil data anggota');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Tambah anggota baru
  Future<Map<String, dynamic>> tambahAnggota(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.tambahAnggotaUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal menambah anggota');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Map<String, dynamic>> createAnggota(
      Map<String, dynamic> anggotaData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/anggota/tambah-anggota.php'),
        body: anggotaData,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add anggota');
      }
    } catch (e) {
      throw Exception('Gagal menambahkan anggota: $e');
    }
  }

  Future<Map<String, dynamic>> getAnggota() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota/index.php'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load anggota');
      }
    } catch (e) {
      throw Exception('Gagal memuat anggota: $e');
    }
  }
}
