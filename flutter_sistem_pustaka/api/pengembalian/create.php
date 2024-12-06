<?php
require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $peminjaman_id = $_POST['peminjaman_id'];
    $tanggal_kembali = date('Y-m-d');

    // Validasi input
    if (empty($peminjaman_id)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'ID peminjaman harus diisi'
        ]);
        exit;
    }

    $query_check = "SELECT p.*, b.id as buku_id 
                   FROM peminjaman p 
                   JOIN buku b ON p.buku_id = b.id 
                   WHERE p.id = ? AND p.status = 'dipinjam' 
                   LIMIT 1";
    $stmt_check = $conn->prepare($query_check);
    $stmt_check->bind_param("s", $peminjaman_id);
    $stmt_check->execute();
    $result_check = $stmt_check->get_result();

    if ($result_check->num_rows == 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Peminjaman tidak ditemukan atau sudah dikembalikan'
        ]);
        exit;
    }

    $peminjaman = $result_check->fetch_assoc();

    $tanggal_harus_kembali = new DateTime($peminjaman['tanggal_kembali']);
    $tanggal_pengembalian = new DateTime($tanggal_kembali);
    $selisih = $tanggal_pengembalian->diff($tanggal_harus_kembali);
    $terlambat = $tanggal_pengembalian > $tanggal_harus_kembali ? $selisih->days : 0;
    $denda = $terlambat * 1000;

    $id = uniqid('KBL');

    $conn->begin_transaction();

    try {
        $query = "INSERT INTO pengembalian (id, peminjaman_id, tanggal_kembali, terlambat, denda) 
                 VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("sssid", $id, $peminjaman_id, $tanggal_kembali, $terlambat, $denda);
        $stmt->execute();

        $query_update_peminjaman = "UPDATE peminjaman SET status = 'dikembalikan' WHERE id = ?";
        $stmt_update_peminjaman = $conn->prepare($query_update_peminjaman);
        $stmt_update_peminjaman->bind_param("s", $peminjaman_id);
        $stmt_update_peminjaman->execute();

        $query_update_buku = "UPDATE buku SET stok = stok + 1 WHERE id = ?";
        $stmt_update_buku = $conn->prepare($query_update_buku);
        $stmt_update_buku->bind_param("s", $peminjaman['buku_id']);
        $stmt_update_buku->execute();

        $conn->commit();

        echo json_encode([
            'status' => 'success',
            'message' => 'Pengembalian berhasil diproses',
            'data' => [
                'id' => $id,
                'tanggal_kembali' => $tanggal_kembali,
                'terlambat' => $terlambat,
                'denda' => $denda
            ]
        ]);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode([
            'status' => 'error',
            'message' => 'Gagal memproses pengembalian: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
