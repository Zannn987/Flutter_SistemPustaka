import 'package:flutter/material.dart';
import '../services/buku_service.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BukuService _bukuService = BukuService();
  List<dynamic> _bukuList = [];
  bool _isLoading = true;
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBuku();
  }

  Future<void> _loadBuku() async {
    try {
      final response = await _bukuService.getBuku();
      if (response['status'] == 'success') {
        setState(() {
          _bukuList = response['data'];
          _isLoading = false;
        });
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      print('Error loading buku: $e');
      setState(() => _isLoading = false);
    }
  }

  List<dynamic> _getFilteredBooks() {
    return _bukuList.where((buku) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          buku['kategori'].toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = buku['judul']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          buku['pengarang']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _getFilteredBooks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Digital'),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                'Semua',
                'Teknologi',
                'Sains',
                'Sastra',
                'Sejarah',
                'Umum',
              ]
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF00BFA5),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: _selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredBooks.isEmpty
                    ? const Center(child: Text('Tidak ada buku ditemukan'))
                    : ListView.builder(
                        itemCount: filteredBooks.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final buku = filteredBooks[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(
                                buku['judul'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pengarang: ${buku['pengarang']}'),
                                  Text('Penerbit: ${buku['penerbit']}'),
                                  Text('Stok: ${buku['stok']}'),
                                  Text('Kategori: ${buku['kategori']}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/peminjaman-buku',
                                  arguments: buku,
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 0),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
