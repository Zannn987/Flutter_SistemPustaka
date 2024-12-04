<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

try {

    $judul = $_POST['judul'] ?? '';
    $pengarang = $_POST['pengarang'] ?? '';
    $penerbit = $_POST['penerbit'] ?? '';
    $tahun_terbit = $_POST['tahun_terbit'] ?? '';
    $stok = $_POST['stok'] ?? '';


    if (empty($judul) || empty($pengarang) || empty($penerbit) || empty($tahun_terbit) || empty($stok)) {
        throw new Exception("Semua field harus diisi");
    }


    $query = "INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit, stok) 
              VALUES (?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("sssss", $judul, $pengarang, $penerbit, $tahun_terbit, $stok);

    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Buku berhasil ditambahkan',
            'data' => [
                'id' => $conn->insert_id,
                'judul' => $judul,
                'pengarang' => $pengarang,
                'penerbit' => $penerbit,
                'tahun_terbit' => $tahun_terbit,
                'stok' => $stok
            ]
        ]);
    } else {
        throw new Exception("Gagal menambahkan buku");
    }
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Gagal menambahkan buku: ' . $e->getMessage()
    ]);
}

$conn->close();
