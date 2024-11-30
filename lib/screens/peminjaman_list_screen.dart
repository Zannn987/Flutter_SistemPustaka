import 'package:flutter/material.dart';
import '../services/peminjaman_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeminjamanListScreen extends StatefulWidget {
  const PeminjamanListScreen({Key? key}) : super(key: key);

  @override
  _PeminjamanListScreenState createState() => _PeminjamanListScreenState();
}

class _PeminjamanListScreenState extends State<PeminjamanListScreen> {
  final PeminjamanService _peminjamanService = PeminjamanService();
  List<Map<String, dynamic>> _peminjaman = [];
  bool _isLoading = true;
  String _nim = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nim = prefs.getString('nim') ?? '';
    });
    await _loadPeminjaman();
  }

  Future<void> _loadPeminjaman() async {
    try {
      final response = await _peminjamanService.getPeminjaman(_nim);
      if (response['status'] == 'success') {
        setState(() {
          _peminjaman = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data peminjaman: $e')),
      );
    }
  }

  Color _getStatusColor(String status, String? tanggalKembali) {
    if (status == 'dikembalikan') {
      return Colors.green;
    }

    // Cek keterlambatan jika status masih dipinjam
    if (tanggalKembali != null) {
      final tanggalKembaliDate = DateTime.parse(tanggalKembali);
      final today = DateTime.now();
      if (today.isAfter(tanggalKembaliDate)) {
        return Colors.red; // Terlambat
      }
    }
    return Colors.orange; // Masih dipinjam
  }

  void _handlePengembalian(Map<String, dynamic> peminjaman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Pengembalian'),
        content: Text('Apakah Anda yakin ingin mengembalikan buku ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                setState(() => _isLoading = true);
                final response = await _peminjamanService.kembalikanBuku(
                  peminjaman['id'].toString(),
                );
                if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response['message'])),
                  );
                  await _loadPeminjaman(); // Reload data setelah pengembalian
                } else {
                  throw Exception(response['message']);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal mengembalikan buku: $e')),
                );
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: Text('Kembalikan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadPeminjaman,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _peminjaman.isEmpty
              ? Center(child: Text('Tidak ada peminjaman'))
              : ListView.builder(
                  itemCount: _peminjaman.length,
                  itemBuilder: (context, index) {
                    final peminjaman = _peminjaman[index];
                    final status = peminjaman['status'] ?? 'dipinjam';

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text(
                          peminjaman['judul_buku'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pengarang: ${peminjaman['pengarang'] ?? ''}'),
                            Text('Penerbit: ${peminjaman['penerbit'] ?? ''}'),
                            Text(
                                'Tanggal Pinjam: ${peminjaman['tanggal_pinjam'] ?? ''}'),
                            Text(
                                'Tanggal Kembali: ${peminjaman['tanggal_kembali'] ?? ''}'),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: status == 'dikembalikan'
                                        ? Colors.green
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                if (status != 'dikembalikan') ...[
                                  SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () =>
                                        _handlePengembalian(peminjaman),
                                    child: Text('Kembalikan'),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
