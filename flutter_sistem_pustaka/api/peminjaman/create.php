<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $anggota_id = $_POST['anggota_id'];
    $buku_id = $_POST['buku_id'];
    $tanggal_pinjam = date('Y-m-d');
    $tanggal_kembali = date('Y-m-d', strtotime('+7 days'));

    if (empty($anggota_id) || empty($buku_id)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Semua field harus diisi'
        ]);
        exit;
    }

    $query_stok = "SELECT stok FROM buku WHERE id = ? LIMIT 1";
    $stmt_stok = $conn->prepare($query_stok);
    $stmt_stok->bind_param("s", $buku_id);
    $stmt_stok->execute();
    $result_stok = $stmt_stok->get_result();
    $buku = $result_stok->fetch_assoc();

    if ($buku['stok'] <= 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Buku tidak tersedia'
        ]);
        exit;
    }

    $id = uniqid('PJM');

    $conn->begin_transaction();

    try {
        $query = "INSERT INTO peminjaman (id, anggota_id, buku_id, tanggal_pinjam, tanggal_kembali, status) 
                 VALUES (?, ?, ?, ?, ?, 'dipinjam')";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("sssss", $id, $anggota_id, $buku_id, $tanggal_pinjam, $tanggal_kembali);
        $stmt->execute();

        $query_update = "UPDATE buku SET stok = stok - 1 WHERE id = ?";
        $stmt_update = $conn->prepare($query_update);
        $stmt_update->bind_param("s", $buku_id);
        $stmt_update->execute();

        $conn->commit();

        echo json_encode([
            'status' => 'success',
            'message' => 'Peminjaman berhasil dibuat',
            'data' => [
                'id' => $id,
                'tanggal_pinjam' => $tanggal_pinjam,
                'tanggal_kembali' => $tanggal_kembali
            ]
        ]);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode([
            'status' => 'error',
            'message' => 'Gagal membuat peminjaman: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
