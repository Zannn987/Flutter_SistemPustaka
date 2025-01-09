<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $id = isset($_GET['id']) ? $_GET['id'] : '';

    if (empty($id)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'ID peminjaman tidak ditemukan'
        ]);
        exit;
    }


    $query = "SELECT p.*, b.judul as judul_buku, b.pengarang, b.penerbit,
              a.nama as nama_anggota, a.email as email_anggota
              FROM peminjaman p
              JOIN buku b ON p.buku_id = b.id
              JOIN anggota a ON p.anggota_id = a.id
              WHERE p.id = ? LIMIT 1";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $peminjaman = $result->fetch_assoc();


        if ($peminjaman['status'] == 'dipinjam') {
            $tanggal_kembali = new DateTime($peminjaman['tanggal_kembali']);
            $tanggal_sekarang = new DateTime();
            $selisih = $tanggal_sekarang->diff($tanggal_kembali);
            $terlambat = $tanggal_sekarang > $tanggal_kembali ? $selisih->days : 0;

            $peminjaman['keterlambatan'] = $terlambat;
            $peminjaman['denda'] = $terlambat * 1000;
        }

        echo json_encode([
            'status' => 'success',
            'data' => $peminjaman
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Peminjaman tidak ditemukan'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
