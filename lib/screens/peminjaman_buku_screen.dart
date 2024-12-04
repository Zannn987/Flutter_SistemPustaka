import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/peminjaman_service.dart';

class PeminjamanBukuScreen extends StatefulWidget {
  final Map<String, dynamic> buku;

  const PeminjamanBukuScreen({super.key, required this.buku});

  @override
  _PeminjamanBukuScreenState createState() => _PeminjamanBukuScreenState();
}

class _PeminjamanBukuScreenState extends State<PeminjamanBukuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalPinjamController = TextEditingController();
  final _tanggalKembaliController = TextEditingController();
  final PeminjamanService _peminjamanService = PeminjamanService();
  bool _isLoading = false;
  String _nim = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _tanggalPinjamController.text = DateTime.now().toString().split(' ')[0];
    _tanggalKembaliController.text =
        DateTime.now().add(const Duration(days: 7)).toString().split(' ')[0];
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nim = prefs.getString('nim') ?? '';
    });
  }

  Future<void> _savePeminjaman() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        final peminjamanData = {
          'nim': _nim,
          'id_buku': widget.buku['id'].toString(),
          'tanggal_pinjam': _tanggalPinjamController.text,
          'tanggal_kembali': _tanggalKembaliController.text,
        };

        final response =
            await _peminjamanService.savePeminjaman(peminjamanData);

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buku berhasil dipinjam')),
          );

          Navigator.pop(context, true);
        } else {
          throw Exception(response['message']);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal meminjam buku: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Buku'),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul: ${widget.buku['judul']}'),
            Text('Pengarang: ${widget.buku['pengarang']}'),
            Text('Penerbit: ${widget.buku['penerbit']}'),
            Text('Tahun: ${widget.buku['tahun_terbit']}'),
            Text('Stok: ${widget.buku['stok']}'),
            Text('Kategori: ${widget.buku['kategori']}'),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tanggalPinjamController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Pinjam',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tanggalKembaliController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Kembali',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePeminjaman,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('PINJAM BUKU'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tanggalPinjamController.dispose();
    _tanggalKembaliController.dispose();
    super.dispose();
  }
}
