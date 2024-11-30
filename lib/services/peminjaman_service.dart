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

  Future<Map<String, dynamic>> savePeminjaman(
      Map<String, dynamic> peminjamanData) async {
    try {
      print('Sending data: $peminjamanData'); // Debug print

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/peminjaman/tambah-peminjaman.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: peminjamanData,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save peminjaman: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal menyimpan peminjaman: $e');
    }
  }

  Future<Map<String, dynamic>> getPeminjaman(String nim) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/peminjaman/list.php?nim=$nim'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load peminjaman');
      }
    } catch (e) {
      throw Exception('Gagal memuat peminjaman: $e');
    }
  }

  Future<Map<String, dynamic>> kembalikanBuku(String peminjamanId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.kembalikanBukuUrl),
        body: {
          'id': peminjamanId,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'error') {
          throw Exception(jsonResponse['message']);
        }
        return jsonResponse;
      } else {
        throw Exception('Failed to return book');
      }
    } catch (e) {
      print('Error in kembalikanBuku: $e');
      throw Exception('Gagal mengembalikan buku: $e');
    }
  }
}
