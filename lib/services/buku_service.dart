import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class BukuService {
  Future<Map<String, dynamic>> getBuku() async {
    try {
      print(
          'Fetching books from: ${ApiConfig.baseUrl}/buku/get-buku.php'); // Debug URL

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/buku/get-buku.php'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}'); // Debug response
      print('Response body: ${response.body}'); // Debug response body

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBuku: $e'); // Debug error
      rethrow; // Lempar error untuk ditangani di UI
    }
  }

  Future<Map<String, dynamic>> saveBuku(Map<String, dynamic> bukuData) async {
    try {
      print('Saving book data: $bukuData'); // Debugging

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/buku/tambah-buku.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: bukuData,
      );

      print('Response status: ${response.statusCode}'); // Debugging
      print('Response body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal menyimpan buku: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving book: $e'); // Debugging
      throw Exception('Gagal menyimpan buku: $e');
    }
  }
}
