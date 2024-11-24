import 'package:flutter/material.dart';
import '../models/buku.dart';

class PeminjamanFormScreen extends StatefulWidget {
  final Buku buku;

  PeminjamanFormScreen({required this.buku});

  @override
  _PeminjamanFormScreenState createState() => _PeminjamanFormScreenState();
}

class _PeminjamanFormScreenState extends State<PeminjamanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? tanggalPinjam;
  DateTime? tanggalKembali;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Peminjaman')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Buku: ${widget.buku.judul}'),
            // Form fields untuk peminjaman
          ],
        ),
      ),
    );
  }
}
