import 'package:flutter/material.dart';
import 'buku_screen.dart';
import 'anggota_screen.dart';
import 'peminjaman_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BukuScreen(),
    const AnggotaScreen(),
    const PeminjamanScreen(),
    const ProfileScreen(),
    const SizedBox(),
  ];

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A4393),
        title: Row(
          children: [
            Image.asset(
              'assets/buku.png',
              height: 30,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'SISTEM INFORMASI\nPERPUSTAKAAN',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C3545),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF2C3545),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == 4) {
                _handleLogout(context);
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Buku',
                backgroundColor: Color(0xFF2C3545),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Anggota',
                backgroundColor: Color(0xFF2C3545),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Peminjaman',
                backgroundColor: Color(0xFF2C3545),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Color(0xFF2C3545),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
                backgroundColor: Color(0xFF2C3545),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
