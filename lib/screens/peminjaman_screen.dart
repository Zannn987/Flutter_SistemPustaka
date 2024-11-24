import 'package:flutter/material.dart';

class PeminjamanScreen extends StatefulWidget {
  const PeminjamanScreen({Key? key}) : super(key: key);
  @override
  _PeminjamanScreenState createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  List<Map<String, dynamic>> _peminjamanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPeminjaman();
  }

  Future<void> _loadPeminjaman() async {
    // Implementasi load data peminjaman dari API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _peminjamanList = [
        {
          'id': '1',
          'judul_buku': 'Flutter Development',
          'tanggal_pinjam': '2024-01-01',
          'tanggal_kembali': '2024-01-08',
          'status': 'Dipinjam',
        },
        // Tambahkan data peminjaman lainnya
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Buku'),
        backgroundColor: Colors.blue[900],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _peminjamanList.length,
              itemBuilder: (context, index) {
                final peminjaman = _peminjamanList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      peminjaman['judul_buku'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal Pinjam: ${peminjaman['tanggal_pinjam']}'),
                        Text(
                            'Tanggal Kembali: ${peminjaman['tanggal_kembali']}'),
                        Text(
                          'Status: ${peminjaman['status']}',
                          style: TextStyle(
                            color: peminjaman['status'] == 'Dipinjam'
                                ? Colors.orange
                                : Colors.green,
                          ),
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
