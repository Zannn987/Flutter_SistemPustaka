import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class BukuService {
  static const String baseUrl = '${ApiConfig.baseUrl}/buku';

  // Get semua buku
  Future<List<Map<String, dynamic>>> getAllBuku() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Gagal mengambil data buku');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get detail buku
  Future<Map<String, dynamic>> getDetailBuku(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil detail buku');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Cari buku
  Future<List<Map<String, dynamic>>> searchBuku(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?keyword=$keyword'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Gagal mencari buku');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
