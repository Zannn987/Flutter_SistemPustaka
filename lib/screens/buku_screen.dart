import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/buku_service.dart';
import 'tambah_buku_screen.dart';
import 'peminjaman_buku_screen.dart';

class BukuScreen extends StatefulWidget {
  const BukuScreen({Key? key}) : super(key: key);

  @override
  _BukuScreenState createState() => _BukuScreenState();
}

class _BukuScreenState extends State<BukuScreen> {
  final BukuService _bukuService = BukuService();
  List<Buku> bukuList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuku();
  }

  Future<void> _loadBuku() async {
    try {
      final response = await _bukuService.getBuku();
      setState(() {
        bukuList = (response['data'] as List)
            .map((item) => Buku.fromJson(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data buku: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        backgroundColor: Color(0xFF1A237E),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : bukuList.isEmpty
              ? Center(child: Text('Tidak ada buku'))
              : ListView.builder(
                  itemCount: bukuList.length,
                  itemBuilder: (context, index) {
                    final buku = bukuList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: ListTile(
                        title: Text(
                          buku.judul,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pengarang: ${buku.pengarang}'),
                            Text('Penerbit: ${buku.penerbit}'),
                            Text('Tahun: ${buku.tahun_terbit}'),
                            Text('Stok: ${buku.stok}'),
                            Text('Kategori: ${buku.kategori}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PeminjamanBukuScreen(buku: buku),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahBukuScreen()),
          );
          if (result == true) {
            _loadBuku(); // Refresh data setelah menambah buku
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF00BFA5),
      ),
    );
  }
}
