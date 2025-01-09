<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

// Ambil data JSON
$input = file_get_contents("php://input");
$data = json_decode($input, true);

// Langsung insert ke database
$query = "INSERT INTO anggota (nim, password, nama, alamat, jenis_kelamin) VALUES (?, ?, ?, ?, ?)";
$stmt = mysqli_prepare($conn, $query);
mysqli_stmt_bind_param(
    $stmt,
    "sssss",
    $data['nim'],
    $data['password'],
    $data['nama'],
    $data['alamat'],
    $data['jenis_kelamin']
);

if (mysqli_stmt_execute($stmt)) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Berhasil menambah anggota'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => mysqli_error($conn)
    ]);
}

mysqli_close($conn);
