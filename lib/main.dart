import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/buku_screen.dart';
import 'screens/peminjaman_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/anggota_screen.dart';
import 'screens/peminjaman_buku_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Informasi Perpustakaan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/buku': (context) => const BukuScreen(),
        '/anggota': (context) => AnggotaScreen(),
        '/peminjaman': (context) => const PeminjamanListScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/peminjaman-buku') {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => PeminjamanBukuScreen(buku: args),
          );
        }
        return null;
      },
    );
  }
}
