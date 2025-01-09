<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/database.php';

try {
    $id_peminjaman = $_POST['id_peminjaman'];
    $tanggal_dikembalikan = date('Y-m-d');


    $query = "SELECT tanggal_kembali FROM peminjaman WHERE id = ?";
    $stmt = $koneksi->prepare($query);
    $stmt->bind_param("i", $id_peminjaman);
    $stmt->execute();
    $result = $stmt->get_result();
    $peminjaman = $result->fetch_assoc();

    if (!$peminjaman) {
        throw new Exception('Data peminjaman tidak ditemukan');
    }


    $tanggal_kembali = new DateTime($peminjaman['tanggal_kembali']);
    $tanggal_dikembalikan_obj = new DateTime($tanggal_dikembalikan);
    $selisih = $tanggal_dikembalikan_obj->diff($tanggal_kembali);
    $terlambat = $selisih->invert == 1 ? $selisih->days : 0;
    $denda = $terlambat * 2000;

    echo json_encode([
        'status' => 'success',
        'data' => [
            'terlambat' => $terlambat,
            'denda' => $denda
        ]
    ]);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
