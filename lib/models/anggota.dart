class Anggota {
  final String id;
  final String nim;
  final String password;
  final String nama;
  final String alamat;
  final String jenis_kelamin;

  Anggota({
    required this.id,
    required this.nim,
    required this.password,
    required this.nama,
    required this.alamat,
    required this.jenis_kelamin,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id']?.toString() ?? '',
      nim: json['nim'] ?? '',
      password: json['password'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      jenis_kelamin: json['jenis_kelamin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nim': nim,
      'password': password,
      'nama': nama,
      'alamat': alamat,
      'jenis_kelamin': jenis_kelamin,
    };
  }
}
