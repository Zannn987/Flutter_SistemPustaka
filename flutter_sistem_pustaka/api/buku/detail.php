<?php
require_once "../config/database.php";

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $id = isset($_GET['id']) ? $_GET['id'] : '';

    if (empty($id)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'ID buku tidak ditemukan'
        ]);
        exit;
    }


    $query = "SELECT * FROM buku WHERE id = ? LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $buku = $result->fetch_assoc();


        $query_peminjaman = "SELECT COUNT(*) as dipinjam FROM peminjaman 
                            WHERE buku_id = ? AND status = 'dipinjam'";
        $stmt_peminjaman = $conn->prepare($query_peminjaman);
        $stmt_peminjaman->bind_param("s", $id);
        $stmt_peminjaman->execute();
        $result_peminjaman = $stmt_peminjaman->get_result();
        $status_peminjaman = $result_peminjaman->fetch_assoc();

        $buku['status_tersedia'] = ($buku['stok'] > $status_peminjaman['dipinjam']);

        echo json_encode([
            'status' => 'success',
            'data' => $buku
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Buku tidak ditemukan'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method not allowed'
    ]);
}
