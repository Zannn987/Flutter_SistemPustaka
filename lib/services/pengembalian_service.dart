import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PengembalianService {
  static const String baseUrl = '${ApiConfig.baseUrl}/pengembalian';

  // Proses pengembalian buku
  Future<Map<String, dynamic>> prosespengembalian(
    String idPeminjaman,
    String tanggalDikembalikan,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'id_peminjaman': idPeminjaman,
          'tanggal_dikembalikan': tanggalDikembalikan,
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memproses pengembalian');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get history pengembalian by NIM
  Future<List<Map<String, dynamic>>> getHistoryPengembalian(String nim) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history/$nim'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Gagal mengambil history pengembalian');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Hitung denda
  Future<Map<String, dynamic>> hitungDenda(
    String idPeminjaman,
    String tanggalDikembalikan,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hitung-denda'),
        body: {
          'id_peminjaman': idPeminjaman,
          'tanggal_dikembalikan': tanggalDikembalikan,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal menghitung denda');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
