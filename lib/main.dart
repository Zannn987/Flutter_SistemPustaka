import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/buku_screen.dart';
import 'screens/peminjaman_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/anggota_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Informasi Perpustakaan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/buku': (context) => BukuScreen(),
        '/peminjaman': (context) => PeminjamanListScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
