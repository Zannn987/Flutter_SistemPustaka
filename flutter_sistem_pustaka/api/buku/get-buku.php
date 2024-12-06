<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

try {
    $query = "SELECT id, judul, pengarang, penerbit, tahun_terbit, stok, kategori FROM buku ORDER BY id ASC";
    $result = $conn->query($query);

    if ($result) {
        $books = array();
        while ($row = $result->fetch_assoc()) {
            $books[] = $row;
        }

        echo json_encode([
            'status' => 'success',
            'message' => 'Data buku berhasil diambil',
            'data' => $books
        ]);
    } else {
        throw new Exception($conn->error);
    }
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Gagal mengambil data buku: ' . $e->getMessage()
    ]);
}

$conn->close();
