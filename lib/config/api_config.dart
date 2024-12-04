class ApiConfig {
  static const String baseUrl = "http://localhost/flutter_sistem_pustaka/api";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String get loginUrl => '$baseUrl/anggota/login.php';
  static String get profileUrl => '$baseUrl/anggota/profile.php';

  static String get bukuUrl => '$baseUrl/buku/index.php';
  static String get tambahBukuUrl => '$baseUrl/buku/tambah-buku.php';
  static String get detailBukuUrl => '$baseUrl/buku/detail.php';
  static String get searchBukuUrl => '$baseUrl/buku/search.php';

  static String get anggotaUrl => '$baseUrl/anggota/index.php';
  static String get tambahAnggotaUrl => '$baseUrl/anggota/tambah-anggota.php';

  static String get peminjamanUrl => '$baseUrl/peminjaman/list.php';
  static String get createPeminjamanUrl => '$baseUrl/peminjaman/create.php';
  static String get detailPeminjamanUrl => '$baseUrl/peminjaman/detail.php';
  static String get kembalikanBukuUrl =>
      '$baseUrl/peminjaman/kembalikan-buku.php';

  static String get pengembalianUrl => '$baseUrl/pengembalian/create.php';
  static String get hapusPengembalianUrl =>
      '$baseUrl/pengembalian/hapus-pengembalian.php';
  static String get historyPengembalianUrl =>
      '$baseUrl/pengembalian/history.php';
}
