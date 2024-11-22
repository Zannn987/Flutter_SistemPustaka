import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PeminjamanService {
  static const String baseUrl = '${ApiConfig.baseUrl}/peminjaman';

  // Buat peminjaman baru
  Future<Map<String, dynamic>> createPeminjaman(
    String nimAnggota,
    String idBuku,
    String tanggalPinjam,
    String tanggalKembali,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'nim_anggota': nimAnggota,
          'id_buku': idBuku,
          'tanggal_pinjam': tanggalPinjam,
          'tanggal_kembali': tanggalKembali,
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal membuat peminjaman');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get peminjaman by NIM
  Future<List<Map<String, dynamic>>> getPeminjamanByNim(String nim) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/anggota/$nim'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Gagal mengambil data peminjaman');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get detail peminjaman
  Future<Map<String, dynamic>> getDetailPeminjaman(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil detail peminjaman');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
