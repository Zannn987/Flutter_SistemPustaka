import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF2C3E50),
      selectedItemColor: Color(0xFF00BFA5),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Buku',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Anggota',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Peminjaman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/buku');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/anggota');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/peminjaman');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
          case 4:
            // Handle logout
            SharedPreferences.getInstance().then((prefs) {
              prefs.clear();
              Navigator.pushReplacementNamed(context, '/');
            });
            break;
        }
      },
    );
  }
}
