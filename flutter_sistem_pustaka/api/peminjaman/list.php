<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

try {
    $nim = $_GET['nim'] ?? '';

    if (empty($nim)) {
        throw new Exception("NIM tidak ditemukan");
    }


    $query = "SELECT p.id, p.tanggal_pinjam, p.tanggal_kembali, p.status, 
              b.judul as judul_buku, b.pengarang, b.penerbit
              FROM peminjaman p 
              JOIN buku b ON p.buku_id = b.id 
              WHERE p.anggota_id IN (SELECT id FROM anggota WHERE nim = ?)
              ORDER BY p.tanggal_pinjam DESC";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $nim);
    $stmt->execute();
    $result = $stmt->get_result();

    if (!$result) {
        throw new Exception($conn->error);
    }

    $peminjaman = array();
    while ($row = $result->fetch_assoc()) {
        $peminjaman[] = array(
            'id' => $row['id'],
            'judul_buku' => $row['judul_buku'],
            'pengarang' => $row['pengarang'],
            'penerbit' => $row['penerbit'],
            'tanggal_pinjam' => $row['tanggal_pinjam'],
            'tanggal_kembali' => $row['tanggal_kembali'],
            'status' => $row['status'] ?? 'dipinjam'
        );
    }

    echo json_encode([
        'status' => 'success',
        'message' => 'Data peminjaman berhasil diambil',
        'data' => $peminjaman
    ]);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Gagal mengambil data peminjaman: ' . $e->getMessage()
    ]);
}

$conn->close();
