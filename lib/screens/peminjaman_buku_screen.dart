import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/peminjaman_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeminjamanBukuScreen extends StatefulWidget {
  final Buku buku;

  const PeminjamanBukuScreen({Key? key, required this.buku}) : super(key: key);

  @override
  _PeminjamanBukuScreenState createState() => _PeminjamanBukuScreenState();
}

class _PeminjamanBukuScreenState extends State<PeminjamanBukuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _peminjamanService = PeminjamanService();
  bool _isLoading = false;
  String _nim = '';
  final _tanggalPinjamController = TextEditingController();
  final _tanggalKembaliController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Set tanggal pinjam hari ini
    _tanggalPinjamController.text = DateTime.now().toString().split(' ')[0];
    // Set tanggal kembali 7 hari dari sekarang
    _tanggalKembaliController.text =
        DateTime.now().add(Duration(days: 7)).toString().split(' ')[0];
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nim = prefs.getString('nim') ?? '';
      print('Loaded NIM: $_nim');
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Buku'),
        backgroundColor: Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail Buku
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.buku.judul,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Pengarang: ${widget.buku.pengarang}'),
                    Text('Penerbit: ${widget.buku.penerbit}'),
                    Text('Stok: ${widget.buku.stok}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Form Peminjaman
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NIM Peminjam',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _nim,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _tanggalPinjamController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Pinjam',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context, _tanggalPinjamController),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _tanggalKembaliController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Kembali',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () =>
                        _selectDate(context, _tanggalKembaliController),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePeminjaman,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00BFA5),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('PINJAM BUKU'),
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

  Future<void> _savePeminjaman() async {
    try {
      setState(() => _isLoading = true);

      if (_nim.isEmpty) {
        throw Exception('NIM tidak ditemukan. Silakan login ulang.');
      }

      final peminjamanData = {
        'nim': _nim,
        'id_buku': widget.buku.id,
        'tanggal_pinjam': _tanggalPinjamController.text,
        'tanggal_kembali': _tanggalKembaliController.text,
      };

      print('Sending data: $peminjamanData'); // Debug print

      final response = await _peminjamanService.savePeminjaman(peminjamanData);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Peminjaman berhasil')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal melakukan peminjaman: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tanggalPinjamController.dispose();
    _tanggalKembaliController.dispose();
    super.dispose();
  }
}
