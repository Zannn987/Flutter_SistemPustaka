import 'package:flutter/material.dart';

class BukuScreen extends StatefulWidget {
  @override
  _BukuScreenState createState() => _BukuScreenState();
}

class _BukuScreenState extends State<BukuScreen> {
  List<Map<String, dynamic>> _bukuList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuku();
  }

  Future<void> _loadBuku() async {
    // Implementasi load data buku dari API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _bukuList = [
        {
          'id': '1',
          'judul': 'Flutter Development',
          'pengarang': 'John Doe',
          'penerbit': 'Tech Books',
          'tahun_terbit': 2023,
        },
        // Tambahkan data buku lainnya
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        backgroundColor: Colors.blue[900],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bukuList.length,
              itemBuilder: (context, index) {
                final buku = _bukuList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      buku['judul'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pengarang: ${buku['pengarang']}'),
                        Text('Penerbit: ${buku['penerbit']}'),
                        Text('Tahun: ${buku['tahun_terbit']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {
                        // Implementasi peminjaman buku
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
