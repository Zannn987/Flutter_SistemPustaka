import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      ).timeout(const Duration(seconds: 10));

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
      // Simpan ID di SharedPreferences saat login
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('user_id'); // Pastikan menyimpan ID saat login

      if (id == null) {
        throw Exception('ID pengguna tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota/profile.php?id=$id'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          return decodedResponse;
        } else {
          throw Exception(decodedResponse['message']);
        }
      } else {
        throw Exception('Gagal mengambil data profile');
      }
    } catch (e) {
      print('Error in getProfile: $e');
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
  Future<Map<String, dynamic>> tambahAnggota({
    required String nim,
    required String nama,
    required String password,
    required String alamat,
    required String jenisKelamin,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'nim': nim,
        'nama': nama,
        'password': password,
        'alamat': alamat,
        'jenis_kelamin': jenisKelamin,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.tambahAnggotaUrl),
        body: data,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal menambah anggota');
      }
    } catch (e) {
      print('Error in tambahAnggota: $e');
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
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

      print('Get Anggota Response: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw Exception('Failed to load anggota');
      }
    } catch (e) {
      print('Error in getAnggota: $e');
      throw Exception('Gagal memuat anggota: $e');
    }
  }
}
