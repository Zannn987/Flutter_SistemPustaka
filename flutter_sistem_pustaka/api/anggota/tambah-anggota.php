<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include_once '../config/database.php';

try {

    if (empty($_POST['nim']) || empty($_POST['password']) || empty($_POST['nama']) || empty($_POST['jenis_kelamin'])) {
        throw new Exception('Semua field wajib diisi');
    }

    $nim = $_POST['nim'];
    $password = $_POST['password'];
    $nama = $_POST['nama'];
    $alamat = $_POST['alamat'] ?? '';
    $jenis_kelamin = $_POST['jenis_kelamin'];


    $check_query = "SELECT id FROM anggota WHERE nim = ?";
    $check_stmt = mysqli_prepare($conn, $check_query);
    mysqli_stmt_bind_param($check_stmt, "s", $nim);
    mysqli_stmt_execute($check_stmt);
    $check_result = mysqli_stmt_get_result($check_stmt);

    if (mysqli_fetch_assoc($check_result)) {
        throw new Exception('NIM sudah terdaftar');
    }


    $query = "INSERT INTO anggota (nim, password, nama, alamat, jenis_kelamin) VALUES (?, ?, ?, ?, ?)";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "sssss", $nim, $password, $nama, $alamat, $jenis_kelamin);

    if (mysqli_stmt_execute($stmt)) {
        $id = mysqli_insert_id($conn);
        echo json_encode([
            'status' => 'success',
            'message' => 'Registrasi berhasil',
            'data' => [
                'id' => $id,
                'nim' => $nim,
                'nama' => $nama,
                'alamat' => $alamat,
                'jenis_kelamin' => $jenis_kelamin
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
