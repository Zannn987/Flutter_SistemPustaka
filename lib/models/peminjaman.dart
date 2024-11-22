import 'anggota.dart';
import 'buku.dart';

class Peminjaman {
  final String id;
  final String tanggalPinjam;
  final String tanggalKembali;
  final String anggotaId;
  final String bukuId;
  final Anggota? anggota; // Relasi ke model Anggota
  final Buku? buku; // Relasi ke model Buku

  Peminjaman({
    required this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggotaId,
    required this.bukuId,
    this.anggota,
    this.buku,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
      anggotaId: json['anggota'],
      bukuId: json['buku'],
      anggota: json['anggota_detail'] != null
          ? Anggota.fromJson(json['anggota_detail'])
          : null,
      buku: json['buku_detail'] != null
          ? Buku.fromJson(json['buku_detail'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_pinjam': tanggalPinjam,
      'tanggal_kembali': tanggalKembali,
      'anggota': anggotaId,
      'buku': bukuId,
    };
  }
}
