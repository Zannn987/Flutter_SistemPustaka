import 'peminjaman.dart';

class Pengembalian {
  final String id;
  final String tanggalDikembalikan;
  final int terlambat;
  final double denda;
  final String peminjamanId;
  final Peminjaman? peminjaman; // Relasi ke model Peminjaman

  Pengembalian({
    required this.id,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjamanId,
    this.peminjaman,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: json['id'],
      tanggalDikembalikan: json['tanggal_dikembalikan'],
      terlambat: json['terlambat'],
      denda: double.parse(json['denda'].toString()),
      peminjamanId: json['peminjaman'],
      peminjaman: json['peminjaman_detail'] != null
          ? Peminjaman.fromJson(json['peminjaman_detail'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_dikembalikan': tanggalDikembalikan,
      'terlambat': terlambat,
      'denda': denda,
      'peminjaman': peminjamanId,
    };
  }
}
