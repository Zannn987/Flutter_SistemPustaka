<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

try {
    // Mengambil data JSON dari body permintaan
    $data = json_decode(file_get_contents("php://input"), true);

    // Tambahkan debugging untuk melihat data yang diterima
    error_log(print_r($data, true)); // Menyimpan data yang diterima ke log

    // Memeriksa apakah semua field yang diperlukan terisi
    if (empty($data['judul']) || empty($data['pengarang']) || empty($data['penerbit']) || empty($data['tahun_terbit']) || empty($data['stok']) || empty($data['kategori'])) {
        throw new Exception('Semua field wajib diisi');
    }

    // Mengambil data dari array $data
    $judul = $data['judul'];
    $pengarang = $data['pengarang'];
    $penerbit = $data['penerbit'];
    $tahun_terbit = $data['tahun_terbit'];
    $stok = $data['stok'];
    $kategori = $data['kategori'];

    // Melanjutkan dengan logika database
    $query = "INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit, stok, kategori) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "ssssss", $judul, $pengarang, $penerbit, $tahun_terbit, $stok, $kategori);

    if (mysqli_stmt_execute($stmt)) {
        $id = mysqli_insert_id($conn);
        echo json_encode([
            'status' => 'success',
            'message' => 'Buku berhasil ditambahkan',
            'data' => [
                'id' => $id,
                'judul' => $judul,
                'pengarang' => $pengarang,
                'penerbit' => $penerbit,
                'tahun_terbit' => $tahun_terbit,
                'stok' => $stok,
                'kategori' => $kategori
            ]
        ]);
    } else {
        throw new Exception(mysqli_error($conn));
    }
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}

mysqli_close($conn);
