import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perpustakaan'),
        backgroundColor: Colors.blue[900],
      ),
      body: GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            'Daftar Buku',
            Icons.book,
            () => Navigator.pushNamed(context, '/buku'),
          ),
          _buildMenuCard(
            context,
            'Peminjaman',
            Icons.bookmark,
            () => Navigator.pushNamed(context, '/peminjaman'),
          ),
          _buildMenuCard(
            context,
            'Profile',
            Icons.person,
            () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildMenuCard(
            context,
            'Logout',
            Icons.exit_to_app,
            () async {
              // Implementasi logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue[900]),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
