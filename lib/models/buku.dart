class Buku {
  final String id;
  final String judul;
  final String pengarang;
  final String penerbit;
  final String tahun_terbit;
  final String stok;
  final String kategori;

  Buku({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahun_terbit,
    required this.stok,
    required this.kategori,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      pengarang: json['pengarang'] ?? '',
      penerbit: json['penerbit'] ?? '',
      tahun_terbit: json['tahun_terbit'].toString(),
      stok: json['stok'].toString(),
      kategori: json['kategori'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun_terbit': tahun_terbit,
      'stok': stok,
      'kategori': kategori,
    };
  }
}
