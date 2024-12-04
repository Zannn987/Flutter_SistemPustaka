import 'package:flutter/material.dart';
import '../services/peminjaman_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeminjamanListScreen extends StatefulWidget {
  const PeminjamanListScreen({super.key});

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

  void _handleHapus(Map<String, dynamic> peminjaman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
            'Apakah Anda yakin ingin menghapus buku ini dari daftar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _peminjaman
                    .removeWhere((item) => item['id'] == peminjaman['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Buku berhasil dihapus dari daftar')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, String? tanggalKembali) {
    if (status == 'dikembalikan') {
      return Colors.green;
    }

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
    final tanggalKembali = DateTime.parse(peminjaman['tanggal_kembali']);
    final today = DateTime.now();
    final selisihHari = today.difference(tanggalKembali).inDays;
    final denda = selisihHari > 0 ? selisihHari * 2000 : 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pengembalian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin mengembalikan buku ini?'),
            if (denda > 0) ...[
              const SizedBox(height: 10),
              Text(
                'Keterlambatan: $selisihHari hari',
                style: const TextStyle(color: Colors.red),
              ),
              Text(
                'Denda: Rp ${denda.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                setState(() => _isLoading = true);
                final response = await _peminjamanService.kembalikanBuku(
                  peminjaman['id'].toString(),
                );
                if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        denda > 0
                            ? 'Buku berhasil dikembalikan. Denda: Rp ${denda.toStringAsFixed(0)}'
                            : 'Buku berhasil dikembalikan',
                      ),
                    ),
                  );
                  await _loadPeminjaman(); // Reload data
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA5),
            ),
            child: const Text('KEMBALIKAN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
        backgroundColor: const Color(0xFF1A237E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); // Kembali ke home
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPeminjaman,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _peminjaman.isEmpty
                ? const Center(child: Text('Tidak ada peminjaman'))
                : ListView.builder(
                    itemCount: _peminjaman.length,
                    itemBuilder: (context, index) {
                      final peminjaman = _peminjaman[index];
                      final status = peminjaman['status'] ?? 'dipinjam';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                peminjaman['judul_buku'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  'Pengarang: ${peminjaman['pengarang'] ?? ''}'),
                              Text('Penerbit: ${peminjaman['penerbit'] ?? ''}'),
                              Text(
                                  'Tanggal Pinjam: ${peminjaman['tanggal_pinjam'] ?? ''}'),
                              Text(
                                  'Tanggal Kembali: ${peminjaman['tanggal_kembali'] ?? ''}'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(status,
                                          peminjaman['tanggal_kembali']),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  if (status == 'dipinjam')
                                    ElevatedButton(
                                      onPressed: () =>
                                          _handlePengembalian(peminjaman),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF00BFA5),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: const Text('KEMBALIKAN'),
                                    )
                                  else
                                    TextButton(
                                      onPressed: () => _handleHapus(peminjaman),
                                      child: const Text('Hapus'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
