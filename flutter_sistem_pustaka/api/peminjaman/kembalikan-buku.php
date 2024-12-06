<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once '../config/database.php';

try {

    if (!isset($_POST['id'])) {
        throw new Exception('ID peminjaman tidak ditemukan');
    }

    $id_peminjaman = $_POST['id'];
    $tanggal_dikembalikan = date('Y-m-d');


    $query_peminjaman = "SELECT * FROM peminjaman WHERE id = ?";
    $stmt_peminjaman = $conn->prepare($query_peminjaman);

    if (!$stmt_peminjaman) {
        throw new Exception('Prepare statement failed: ' . $conn->error);
    }

    $stmt_peminjaman->bind_param("i", $id_peminjaman);
    $stmt_peminjaman->execute();
    $result = $stmt_peminjaman->get_result();
    $peminjaman = $result->fetch_assoc();

    if (!$peminjaman) {
        throw new Exception('Data peminjaman tidak ditemukan');
    }


    $tanggal_kembali = new DateTime($peminjaman['tanggal_kembali']);
    $tanggal_dikembalikan_obj = new DateTime($tanggal_dikembalikan);
    $selisih = $tanggal_dikembalikan_obj->diff($tanggal_kembali);
    $terlambat = $selisih->invert == 1 ? $selisih->days : 0;
    $denda = $terlambat * 2000;


    $conn->begin_transaction();

    try {

        $query_update = "UPDATE peminjaman SET status = 'dikembalikan' WHERE id = ?";
        $stmt_update = $conn->prepare($query_update);
        $stmt_update->bind_param("i", $id_peminjaman);

        if (!$stmt_update->execute()) {
            throw new Exception('Gagal mengupdate status peminjaman');
        }


        $query_insert = "INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman_id) 
                        VALUES (?, ?, ?, ?)";
        $stmt_insert = $conn->prepare($query_insert);
        $stmt_insert->bind_param("siid", $tanggal_dikembalikan, $terlambat, $denda, $id_peminjaman);

        if (!$stmt_insert->execute()) {
            throw new Exception('Gagal menyimpan data pengembalian');
        }


        $conn->commit();

        sendJSON([
            'status' => 'success',
            'message' => 'Buku berhasil dikembalikan',
            'data' => [
                'tanggal_dikembalikan' => $tanggal_dikembalikan,
                'terlambat' => $terlambat,
                'denda' => $denda
            ]
        ]);
    } catch (Exception $e) {

        $conn->rollback();
        throw new Exception('Gagal menyimpan data: ' . $e->getMessage());
    }
} catch (Exception $e) {
    sendJSON([
        'status' => 'error',
        'message' => $e->getMessage()
    ], 400);
}

if (isset($stmt_peminjaman)) $stmt_peminjaman->close();
if (isset($stmt_update)) $stmt_update->close();
if (isset($stmt_insert)) $stmt_insert->close();
$conn->close();
