<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Accept");
header("Content-Type: application/json; charset=UTF-8");

require_once "../config/database.php";

try {

    $nim = $_POST['nim'] ?? '';
    $id_buku = $_POST['id_buku'] ?? '';
    $tanggal_pinjam = $_POST['tanggal_pinjam'] ?? '';
    $tanggal_kembali = $_POST['tanggal_kembali'] ?? '';


    error_log("Received data - NIM: $nim, ID Buku: $id_buku, Tgl Pinjam: $tanggal_pinjam, Tgl Kembali: $tanggal_kembali");


    if (empty($nim) || empty($id_buku) || empty($tanggal_pinjam) || empty($tanggal_kembali)) {
        throw new Exception("Semua field harus diisi");
    }


    $query_anggota = "SELECT id FROM anggota WHERE nim = '$nim'";
    $result_anggota = $conn->query($query_anggota);
    if (!$result_anggota || $result_anggota->num_rows === 0) {
        throw new Exception("Anggota tidak ditemukan");
    }
    $anggota = $result_anggota->fetch_assoc();
    $anggota_id = $anggota['id'];

    $query_stok = "SELECT stok FROM buku WHERE id = '$id_buku'";
    $result_stok = $conn->query($query_stok);

    if (!$result_stok) {
        throw new Exception("Error checking book stock: " . $conn->error);
    }

    $buku = $result_stok->fetch_assoc();
    if (!$buku || $buku['stok'] <= 0) {
        throw new Exception("Stok buku tidak tersedia");
    }


    $conn->begin_transaction();

    try {
        $query_pinjam = "INSERT INTO peminjaman (anggota_id, buku_id, tanggal_pinjam, tanggal_kembali) 
                        VALUES ('$anggota_id', '$id_buku', '$tanggal_pinjam', '$tanggal_kembali')";

        if (!$conn->query($query_pinjam)) {
            throw new Exception("Error inserting peminjaman: " . $conn->error);
        }

        $query_update = "UPDATE buku SET stok = stok - 1 WHERE id = '$id_buku'";
        if (!$conn->query($query_update)) {
            throw new Exception("Error updating book stock: " . $conn->error);
        }

        $conn->commit();

        echo json_encode([
            'status' => 'success',
            'message' => 'Peminjaman berhasil ditambahkan'
        ]);
    } catch (Exception $e) {
        $conn->rollback();
        throw $e;
    }
} catch (Exception $e) {
    error_log("Error in tambah-peminjaman.php: " . $e->getMessage());
    echo json_encode([
        'status' => 'error',
        'message' => 'Gagal menyimpan peminjaman: ' . $e->getMessage()
    ]);
}

$conn->close();
