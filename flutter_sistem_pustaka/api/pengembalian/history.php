<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/database.php';

try {
    $nim = isset($_GET['nim']) ? $_GET['nim'] : null;

    if (!$nim) {
        throw new Exception('NIM tidak ditemukan');
    }

    $query = "SELECT pg.*, p.tanggal_pinjam, p.tanggal_kembali, 
              b.judul as judul_buku, b.pengarang, b.penerbit
              FROM pengembalian pg
              JOIN peminjaman p ON pg.peminjaman_id = p.id
              JOIN buku b ON p.buku_id = b.id
              JOIN anggota a ON p.anggota_id = a.id
              WHERE a.nim = ?
              ORDER BY pg.tanggal_dikembalikan DESC";

    $stmt = $koneksi->prepare($query);
    $stmt->bind_param("s", $nim);
    $stmt->execute();
    $result = $stmt->get_result();

    $pengembalian = [];
    while ($row = $result->fetch_assoc()) {
        $pengembalian[] = $row;
    }

    echo json_encode([
        'status' => 'success',
        'data' => $pengembalian
    ]);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
