<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

try {
    $query = "SELECT * FROM buku";
    $result = mysqli_query($conn, $query);
    $buku = array();

    while ($row = mysqli_fetch_assoc($result)) {
        $buku[] = array(
            'id' => $row['id'],
            'judul' => $row['judul'],
            'pengarang' => $row['pengarang'],
            'penerbit' => $row['penerbit'],
            'tahun_terbit' => $row['tahun_terbit'],
            'stok' => $row['stok'],
            'kategori' => $row['kategori']
        );
    }

    echo json_encode([
        'status' => 'success',
        'data' => $buku
    ]);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
