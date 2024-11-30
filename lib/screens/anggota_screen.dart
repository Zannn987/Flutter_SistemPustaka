import 'package:flutter/material.dart';
import '../services/anggota_service.dart';
import 'tambah_anggota_screen.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({Key? key}) : super(key: key);

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  final AnggotaService _anggotaService = AnggotaService();
  List<Map<String, dynamic>> _anggota = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnggota();
  }

  Future<void> _loadAnggota() async {
    try {
      final response = await _anggotaService.getAnggota();
      if (response['status'] == 'success') {
        setState(() {
          _anggota = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data anggota: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadAnggota,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _anggota.isEmpty
                  ? Center(child: Text('Tidak ada anggota'))
                  : ListView.builder(
                      itemCount: _anggota.length,
                      itemBuilder: (context, index) {
                        final anggota = _anggota[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: ListTile(
                            title: Text(
                              anggota['nama'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NIM: ${anggota['nim'] ?? ''}'),
                                Text('Email: ${anggota['email'] ?? ''}'),
                                Text('No. HP: ${anggota['no_hp'] ?? ''}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahAnggotaScreen(),
                ),
              );
              if (result == true) {
                _loadAnggota();
              }
            },
            backgroundColor: Color(0xFF1A4393),
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
