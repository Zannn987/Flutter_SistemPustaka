class ApiConfig {
  // Base URL untuk API
  static const String baseUrl = 'http://localhost/flutter_sistem_pustaka/api';

  // Endpoint untuk auth
  static String get loginUrl => '$baseUrl/anggota/login.php';
  static String get profileUrl => '$baseUrl/anggota/profile.php';

  // Endpoint untuk buku
  static String get bukuUrl => '$baseUrl/buku/index.php';
  static String get tambahBukuUrl => '$baseUrl/buku/tambah-buku.php';
  static String get detailBukuUrl => '$baseUrl/buku/detail.php';
  static String get searchBukuUrl => '$baseUrl/buku/search.php';

  // Endpoint untuk anggota
  static String get anggotaUrl => '$baseUrl/anggota/index.php';
  static String get tambahAnggotaUrl => '$baseUrl/anggota/tambah-anggota.php';

  // Endpoint untuk peminjaman
  static String get peminjamanUrl => '$baseUrl/peminjaman/list.php';
  static String get createPeminjamanUrl => '$baseUrl/peminjaman/create.php';
  static String get detailPeminjamanUrl => '$baseUrl/peminjaman/detail.php';

  // Endpoint untuk pengembalian
  static String get pengembalianUrl => '$baseUrl/pengembalian/create.php';
  static String get historyPengembalianUrl =>
      '$baseUrl/pengembalian/history.php';
}
