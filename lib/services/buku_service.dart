import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buku.dart';
import '../config/api_config.dart';

class BukuService {
  Future<List<Buku>> getBuku() async {
    try {
      final url = Uri.parse(ApiConfig.bukuUrl);
      print('Mencoba mengakses URL: $url');

      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Periksa status response
        if (responseData['status'] == 'success') {
          // Pastikan 'data' berisi List
          if (responseData['data'] is List) {
            return (responseData['data'] as List)
                .map((json) => Buku.fromJson(json))
                .toList();
          } else {
            throw Exception('Format data tidak sesuai');
          }
        } else {
          throw Exception(
              responseData['message'] ?? 'Gagal mengambil data buku');
        }
      } else {
        throw Exception('Gagal mengambil data buku: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBuku: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Buku> tambahBuku(Buku buku) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.bukuUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(buku.toJson()),
      );

      if (response.statusCode == 201) {
        return Buku.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal menambah buku');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> saveBuku(Map<String, dynamic> bukuData) async {
    try {
      // Konversi nilai ke tipe data yang sesuai
      final dataToSend = {
        'judul': bukuData['judul'],
        'pengarang': bukuData['pengarang'],
        'penerbit': bukuData['penerbit'] ?? '',
        'tahun_terbit': bukuData['tahun_terbit']?.toString() ?? '',
        'stok': bukuData['stok']?.toString() ?? '0',
        'kategori': bukuData['kategori'] ?? 'Umum',
      };

      final url = Uri.parse(ApiConfig.tambahBukuUrl);
      print('Mengirim data ke: $url');
      print('Data yang dikirim: $dataToSend');

      final response = await http.post(
        url,
        body: dataToSend,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Gagal menambahkan buku');
      }
    } catch (e) {
      print('Error in saveBuku: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
