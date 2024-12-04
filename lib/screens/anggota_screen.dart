import 'package:flutter/material.dart';
import '../services/anggota_service.dart';
import '../widgets/bottom_navigation.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({super.key});

  @override
  _AnggotaScreenState createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  final AnggotaService _anggotaService = AnggotaService();
  List<dynamic> _anggotaList = [];

  @override
  void initState() {
    super.initState();
    _loadAnggota();
  }

  Future<void> _loadAnggota() async {
    try {
      final response = await _anggotaService.getAnggota();
      setState(() {
        _anggotaList = response['data'];
      });
    } catch (e) {
      print('Error loading anggota: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
        backgroundColor: const Color(0xFF1A237E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _anggotaList.length,
        itemBuilder: (context, index) {
          final anggota = _anggotaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(anggota['nama'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NIM: ${anggota['nim'] ?? ''}'),
                  Text('Alamat: ${anggota['alamat'] ?? ''}'),
                  Text('Jenis Kelamin: ${anggota['jenis_kelamin'] ?? ''}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-anggota');
        },
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 2),
    );
  }
}
