import 'package:flutter/material.dart';
import '../services/anggota_service.dart';

class TambahAnggotaScreen extends StatefulWidget {
  const TambahAnggotaScreen({super.key});

  @override
  _TambahAnggotaScreenState createState() => _TambahAnggotaScreenState();
}

class _TambahAnggotaScreenState extends State<TambahAnggotaScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedJenisKelamin;

  // Controller untuk input
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _alamatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Anggota'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(labelText: 'NIM'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              maxLines: 2,
            ),
            DropdownButtonFormField<String>(
              value: _selectedJenisKelamin,
              decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              items: const [
                DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'P', child: Text('Perempuan')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih jenis kelamin';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _selectedJenisKelamin = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await AnggotaService().tambahAnggota(
                    nim: _nimController.text,
                    nama: _namaController.text,
                    password: _passwordController.text,
                    alamat: _alamatController.text,
                    jenisKelamin: _selectedJenisKelamin!,
                  );

                  if (response['status'] == 'success') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Berhasil menambah anggota')),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              response['message'] ?? 'Gagal menambah anggota')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
}
