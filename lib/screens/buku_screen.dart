import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/buku_service.dart';
import 'peminjaman_form_screen.dart';
import 'tambah_buku_screen.dart';

class BukuScreen extends StatefulWidget {
  const BukuScreen({Key? key}) : super(key: key);

  @override
  State<BukuScreen> createState() => _BukuScreenState();
}

class _BukuScreenState extends State<BukuScreen> {
  final BukuService _bukuService = BukuService();
  List<Buku> bukuList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuku();
  }

  Future<void> _loadBuku() async {
    try {
      setState(() => isLoading = true);
      final data = await _bukuService.getBuku();
      setState(() {
        bukuList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bukuList.isEmpty
              ? const Center(child: Text('Tidak ada buku'))
              : ListView.builder(
                  itemCount: bukuList.length,
                  itemBuilder: (context, index) {
                    final buku = bukuList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(buku.judul),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(buku.pengarang),
                            Text(
                                'Stok: ${buku.stok} | Kategori: ${buku.kategori}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PeminjamanFormScreen(buku: buku),
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
            MaterialPageRoute(builder: (context) => const TambahBukuScreen()),
          );
          if (result == true) {
            _loadBuku(); // Refresh data setelah menambah buku
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
